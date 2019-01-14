# YYCache源码解析


##  需要解决的问题

1. 如何实现内存和磁盘缓存的？
2. 内存缓存和磁盘缓存的算法？
3. 如何保证线程安全的？
4. 可以学习到什么？


# 一、YYMemoryCache 

`YYMemoryCache`是线程安全的内存缓存库。提供的存取方法与`NSCache`相似，使用方便。

特点：

1. 采用LRU算法(最近最少使用)。
2. 可以设置缓存时长、大小和数量等。
3. App内存报警和进入后台自动清除缓存

## 1.1 实现原理

查看源码发现，在`YYMemoryCache`内部使用了双向链表来存储数据。

链表结点`_YYLinkedMapNode`:

```objc
@interface _YYLinkedMapNode : NSObject {
    @package
    __unsafe_unretained _YYLinkedMapNode *_prev; // retained by dic
    __unsafe_unretained _YYLinkedMapNode *_next; // retained by dic
    id _key;
    id _value;
    NSUInteger _cost;
    NSTimeInterval _time;
}
@end
```
用来存储数据内容，`_prev`和`_next`两个指针。

另外，`_YYLinkedMap`的定义了链表的基本操作，例如：头部添加、删除和移动到头部。

了解了数据结构，我们看看是如何使用链表存储数据的。

在内存使用了`pthread_mutex_lock`保证线程安全。先来看看他的基本用法：

```objc
// 定义变量
pthread_mutex_t _lock; 
// 初始化
pthread_mutex_init(&_lock, NULL)
// 加锁，这种方式会导致阻塞，锁被其他线程使用，在使用需要等待锁释放。
pthread_mutex_lock(&_lock)
// 解锁
pthread_mutex_unlock(&_lock)
// 销毁
pthread_mutex_destory(&_lock)

// 非阻塞互斥锁锁定

pthread_mutex_trylock(&_lock)
```
`pthread_mutex_trylock()` 是 `pthread_mutex_lock()` 的非阻塞版本。如果 mutex 所引用的互斥对象当前被任何线程（包括当前线程）锁定，则将立即返回该调用。否则，该互斥锁将处于锁定状态，调用线程是其属主。

关于互斥锁可以参考[多线程编程指南](https://docs.oracle.com/cd/E19253-01/819-7051/sync-12/index.html)


## 1.2 存储Key-Value

API中提供了两个存储接口：

```objc
- (void)setObject:(nullable id)object forKey:(id)key;
- (void)setObject:(nullable id)object forKey:(id)key withCost:(NSUInteger)cost;
```
接下来看看数据是如何存储的。上面两个方法实际上是前者调用了后者。

```objc

- (void)setObject:(id)object forKey:(id)key withCost:(NSUInteger)cost {
    // 1. Key不能为空
    if (!key) return;
    // 2. Value为空，Key不为空。如果链表中存在节点就删除。
    if (!object) {
        [self removeObjectForKey:key];
        return;
    }
    // 3. 加锁
    pthread_mutex_lock(&_lock);
    // 4. 根据Key值从链表中获取节点。
    _YYLinkedMapNode *node = CFDictionaryGetValue(_lru->_dic, (__bridge const void *)(key));
    NSTimeInterval now = CACurrentMediaTime();

    if (node) {
        // 5. 如果节点存在，重置节点数据。
        // 注意同时需要将节点移到链表头部。
        _lru->_totalCost -= node->_cost;
        _lru->_totalCost += cost;
        node->_cost = cost;
        node->_time = now;
        node->_value = object;
        [_lru bringNodeToHead:node];
    } else {
        // 6.创建节点，添加数据
        // 插入到链表头部
        node = [_YYLinkedMapNode new];
        node->_cost = cost;
        node->_time = now;
        node->_key = key;
        node->_value = object;
        [_lru insertNodeAtHead:node];
    }
    if (_lru->_totalCost > _costLimit) {
        dispatch_async(_queue, ^{
            [self trimToCost:_costLimit];
        });
    }
    // 7. 淘汰策略
    if (_lru->_totalCount > _countLimit) {
        _YYLinkedMapNode *node = [_lru removeTailNode];
        if (_lru->_releaseAsynchronously) {
            dispatch_queue_t queue = _lru->_releaseOnMainThread ? dispatch_get_main_queue() : YYMemoryCacheGetReleaseQueue();
            dispatch_async(queue, ^{
                [node class]; //hold and release in queue
            });
        } else if (_lru->_releaseOnMainThread && !pthread_main_np()) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [node class]; //hold and release in queue
            });
        }
    }
    // 8. 解锁
    pthread_mutex_unlock(&_lock);
}
```
## 1.3 读取Key-Value

```objc
- (id)objectForKey:(id)key {
    if (!key) return nil;
    // 1. 加锁
    pthread_mutex_lock(&_lock);
    // 2. 读取链表节点
    _YYLinkedMapNode *node = CFDictionaryGetValue(_lru->_dic, (__bridge const void *)(key));
    // 3. 存在，重置时间和插入到首部
    if (node) {
        node->_time = CACurrentMediaTime();
        [_lru bringNodeToHead:node];
    }
    // 4. 解锁
    pthread_mutex_unlock(&_lock);
    // 5. 返回数据
    return node ? node->_value : nil;
}
```


# 二、YYDiskCache 

磁盘缓存技术大致分为三类：

1. 基于文件读写 ：一个Value对应一个文件，通过文件读写来缓存数据。优点：实现简单；缺点：不方便扩展、没有元数据，难以实现好的淘汰算法，数据统计缓慢。
2. 基于MMAP文件内存映射 ：将文件映射到内存。缺点：文件大时性能较差，容易丢失数据。
3. 基于数据库 ：支持元数据、扩展方便、数据统计速度快，可以实现淘汰算法。缺点：存在数据库读写瓶颈。

## 2.1 实现原理

`YYDiskCache`使用数据库配合文件的存储方式。这种既有文件存取方式的快速，又可以存储元数据、实现LRU淘汰算法，更块的数据统计。

`YYDiskCache`中使用`NSMapTable`对象。关于`NSMapTable`这篇文章[NSHash​Table & NSMap​Table - NSHipster](https://nshipster.cn/nshashtable-and-nsmaptable/)有介绍。

`NSMapTable`是`NSDictonary`的通用版本。具有以下特征：

1. `NSDictionary`和`NSMutableDictionary`对键进行拷贝，对值持有强引用。
2. `NSMapTable`是可变的，没有不可变版本。
3. 持有键和值的弱引用，当键或者值当中一个被释放，整个这一项就会被移除掉。
4. 可以在加入成员时进行Copy操作。
5. 可以存储任意的指针、通过指针来进行相等性和算列检查。

`YYDiskCache`采用信号量实现线程同步。

```objc
// 1. 定义变量
dispatch_semaphore_t _lock;
// 2. 初始化，指定参数唯一表示同步
 _lock = dispatch_semaphore_create(1); 
// 3. 信号量值 > 0时，将信号量值减一，执行后面的代码。信号量 <= 0时，等待。
dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
// 4. 信号量值 + 1
dispatch_semaphore_signal(_lock);
```


## 2.2 实现细节

如何因为采用了混合存储模式，即数据库+文件。所以在初始化时需要配置使用哪种，在`NS_DESIGNATED_INITIALIZER`中：

```objc
- (nullable instancetype)initWithPath:(NSString *)path
                      inlineThreshold:(NSUInteger)threshold NS_DESIGNATED_INITIALIZER;
```
参数：`threshold`: 0：表示使用文件存储；NSUIntegerMax：代表使用sqlite数据库存储，其他值使用混合存储。推荐使用`1024 * 20`。

## 2.3 实现

存储操作被封装到`YYKVStorage`中。`YYKVStorageItem`用来存储键值对和元数据。`YYKVStorage`封装访问数据库的方法，存储、读取、删除等。

