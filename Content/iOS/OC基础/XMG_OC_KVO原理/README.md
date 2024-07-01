1. KVO的实现原理：
 
	利用Runtime动态生成一个子类，并且让实例对象的ISA指针指向这个全新的子类。
	修改实例对象的属性时，会调用Foundation的_NSSetXXXValueAndNotify函数
	willChangeValueForKey:
	父类原来的setter
	didChangeValueForKey:
	内部会触发监听器的监听方法
	 
	示例：
	
	```objective-c
	(lldb) p (IMP)0x10cf12500
	(IMP) $0 = 0x000000010cf12500 (XMG_OC_KVO原理`-[LEPerson setAge:] at LEPerson.h:13)
	(lldb) p (IMP)0x10d2b7f8e
	(IMP) $1 = 0x000000010d2b7f8e (Foundation`_NSSetIntValueAndNotify)
	```
 
2. 如何手动触发KVO？
 
	手动调用willChangeValueForKey:和didChangeValueForKey:

3. 直接修改成员变量会触发KVO吗？
 
	上面第51行测试，发现不会触发
 
4. 查看KVO动态子类都重写哪些方法？
 
	setAge:,class,dealloc,_isKVOA,