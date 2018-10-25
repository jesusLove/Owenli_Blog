 1. 一个对象占用多大空间的问题？

	 系统分配了16字节给Person对象，通过malloc_size函数获得
	 但Person对象内部只使用了8个字节的空间，64位环境下，通过class_getInstanceSize函数获得。


 
 实例，类，元类

 ```objective-c
 struct NSObject_IMPL {
    Class isa; // isa 指针占用8字节。
 };
 ```

 1. instance
 
	 通过alloc产生的对象，每次都会产生新的实例对象
	 
	 存放成员变量（包含isa）
 
 2. class
 
	 每个类在内存中有且仅有一个class对象
	 
	 isa指针
	 
	 superCalss指针
	 
	 类的属性信息（@property）类的对象方法信息（Instance Method）
	 
	 类的协议信息(protocol) 类的成员变量信息（ivar）
 
 3. meta-class
 
	 isa指针
	 
	 superClass指针
	 
	 类的类方法信息（class Method)