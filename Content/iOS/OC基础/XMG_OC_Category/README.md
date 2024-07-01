1. Category实现原理

    Category编译后的底层结构是category_t结构体，里面存放着分类的对象方法、类方法、属性、协议等信息。
    在运行时会将数据合并到，主类中去。源码runtime-new.h中
 
2. 和扩展的区别是什么？

	* 扩展在编译的时候，它的数据就已经包含在类信息中。
	* 分类需要在运行时，才会将数据合并到类信息中。
 

3. 问：Category中有load方法吗？load方法是什么时候调用的？load 方法能继承吗？
    答：Category中有load方法，load方法在程序启动装载类信息的时候就会调用。load方法可以继承。调用子类的load方法之前，会先调用父类的load方法
4. 问：load、initialize的区别，以及它们在category重写的时候的调用的次序。

    答：区别在于调用方式和调用时刻
    
    调用方式：load是根据函数地址直接调用，initialize是通过objc_msgSend调用
    
    调用时刻：load是runtime加载类、分类的时候调用（只会调用1次），initialize是类第一次接收到消息的时候调用，每一个类只会initialize一次（父类的initialize方法可能会被调用多次）
    
    调用顺序：先调用类的load方法，先编译那个类，就先调用load。在调用load之前会先调用父类的load方法。分类中load方法不会覆盖本类的load方法，先编译的分类优先调用load方法。initialize先初始化父类，之后再初始化子类。如果子类没有实现+initialize，会调用父类的+initialize（所以父类的+initialize可能会被调用多次），如果分类实现了+initialize，就覆盖类本身的+initialize调用。

[iOS底层原理总结 - Category的本质](https://juejin.im/post/5aef0a3b518825670f7bc0f3)

