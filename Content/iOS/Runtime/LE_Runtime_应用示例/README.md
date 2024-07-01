#  Runtime应用示例

常见使用：

1. 交换类方法
2. 拦截和替换系统类方法
3. 为分类添加属性
4. 获取类的所有成员变量，包含名称和类型
5. 获取属性值重写归档和归档方法
6. 字典转模型：
    ①. 模型属性个数多于字典key的个数
    ②. 模型中嵌套模型
    ③. 数组中嵌套模型

# 交换实例方法或类方法

```objective-c
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method playM = class_getInstanceMethod(self, @selector(play));
        Method studyM = class_getInstanceMethod(self, @selector(study));
        method_exchangeImplementations(playM, studyM);
    });
}

- (void)play {
    NSLog(@"%s", __func__);
}
- (void)study {
    NSLog(@"%s", __func__);
}
```
> 调用play会输出study，因为交换了两者这实现

## 拦截系统类方法

```
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method m1 = class_getClassMethod([UIImage class], @selector(le_imageNamed:));
        Method m2 = class_getClassMethod([UIImage class], @selector(imageNamed:));
        method_exchangeImplementations(m1, m2);
    });
}
// 自定义方法，用来替换UIImage方法
+ (UIImage *)le_imageNamed:(NSString *)name {
    double osVersion = [[UIDevice currentDevice].systemVersion doubleValue];
    if (osVersion >= 7.0) {
        name = [name stringByAppendingString:@"_os7"];
    }
    return [self le_imageNamed:name];
}
```

## 为分类添加属性

```
@property (nonatomic, copy) NSNumber *le_count; // 添加的属性

- (void)setLe_count:(NSNumber *)le_count {
    objc_setAssociatedObject(self, @selector(le_count), le_count, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (NSNumber *)le_count {
    eturn objc_getAssociatedObject(self, @selector(le_count));
}

```

## 归档和解档

```

// 忽略的属性
- (NSArray *)ignoredNames {
return @[];
}
// 解档
- (instancetype)initWithCoder:(NSCoder *)aDecoder {

    if (self = [super init]) {
        unsigned int outCount = 0;
        Ivar *ivars = class_copyIvarList([self class], &outCount);

        for (int i = 0; i < outCount; i ++) {
            Ivar ivar = ivars[i];

            NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
            if ([[self ignoredNames] containsObject:key]) {
                continue;
            }

            id value = [aDecoder decodeObjectForKey:key];

            [self setValue:value forKey:key];
        }
        free(ivars);
    }
    return self;
}
// 归档
-(void)encodeWithCoder:(NSCoder *)aCoder {
    unsigned int outCount = 0;
    Ivar *ivars = class_copyIvarList([self class], &outCount);

    for (int i = 0; i < outCount; i ++) {
        Ivar ivar = ivars[i];

        NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
        if ([[self ignoredNames] containsObject:key]) {
            continue;
        }

        id value = [self valueForKeyPath:key];

        [aCoder encodeObject:value forKey:key];
    }
    free(ivars);
}
```
