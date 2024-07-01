//
//  ViewController.m
//  XMG_OC_KVO原理
//
//  Created by lqq on 2018/9/26.
//  Copyright © 2018年 LQQ. All rights reserved.
//

#import "ViewController.h"
#import "LEPerson.h"
#import <objc/runtime.h>


@interface ViewController ()
@property (nonatomic, strong) LEPerson *person; // 不添加KVO
@property (nonatomic, strong) LEPerson *personKVO; // 添加KVO
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化对象
    self.person = [[LEPerson alloc] init];
    self.person.age = 10;
    self.personKVO = [[LEPerson alloc] init];
    NSLog(@"添加监听之前：%@ %@", object_getClass(self.personKVO), object_getClass(self.person));
    // LEPerson LEPerson
    NSLog(@"添加监听之前：%p %p", [self.personKVO methodForSelector:@selector(setAge:)], [self.person methodForSelector:@selector(setAge:)]);
    
    
    // 添加KVO
    [self.personKVO addObserver:self forKeyPath:@"age" options: NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
    
    NSLog(@"添加监听之后：%@ %@", object_getClass(self.personKVO), object_getClass(self.person));
    //输出：NSKVONotifying_LEPerson LEPerson
    NSLog(@"添加监听之后：%p %p", [self.personKVO methodForSelector:@selector(setAge:)], [self.person methodForSelector:@selector(setAge:)]);
    // 输出方法实现地址,通过 p (IMP)地址获取名称。
    
    // 查看重写了哪些方法！
    [self printMethodNamedOfClass:object_getClass(self.personKVO)];
    // setAge:,class,dealloc,_isKVOA
    [self printMethodNamedOfClass:object_getClass(self.person)];
    // test,setAge:,age
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
//    self.personKVO.age ++;
//    self.person.age ++;
//
    // 测试直接修改成员变量是否会触发KVO
//    [self.personKVO test];
    
    // 手动触发KVO
    [self.personKVO testKVO];
    
}
// 监控响应方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {

    NSLog(@"%@ %@ %@", object, keyPath, change);
}

- (void)dealloc
{
    [self.personKVO removeObserver:self forKeyPath:@"age"];
}


//打印方法
- (void)printMethodNamedOfClass:(Class)cls {
    unsigned int count;
    // 方法类列表
    Method *methodList = class_copyMethodList(cls, &count);
    NSMutableString *methodNames = [NSMutableString string];
    
    for (int i = 0; i < count; i ++) {
        Method method = methodList[i];
        NSString *methodName = NSStringFromSelector(method_getName(method));
        [methodNames appendFormat:@"%@,", methodName];
    }
    free(methodList);
    NSLog(@"%@", methodNames);
}
@end



/*
 
 KVO的实现原理：
 
    利用Runtime动态生成一个子类，并且让实例对象的ISA指针指向这个全新的子类。
    修改实例对象的属性时，会调用Foundation的_NSSetXXXValueAndNotify函数
    willChangeValueForKey:
    父类原来的setter
    didChangeValueForKey:
    内部会触发监听器的监听方法
 
    示例：
 
     (lldb) p (IMP)0x10cf12500
     (IMP) $0 = 0x000000010cf12500 (XMG_OC_KVO原理`-[LEPerson setAge:] at LEPerson.h:13)
     (lldb) p (IMP)0x10d2b7f8e
     (IMP) $1 = 0x000000010d2b7f8e (Foundation`_NSSetIntValueAndNotify)
 
 如何手动触发KVO？
 
    手动调用willChangeValueForKey:和didChangeValueForKey:

 直接修改成员变量会触发KVO吗？
 
    上面第51行测试，发现不会触发
 

 查看KVO动态子类都重写哪些方法？
 
    setAge:,class,dealloc,_isKVOA,
 
 */
