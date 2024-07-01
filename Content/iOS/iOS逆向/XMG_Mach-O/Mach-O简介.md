编写的C++\OC\Swift代码 -> 可执行的（Mach-O）

# 动态库共享缓存

从iOS3.1开始，为了提高性能，绝大多数的系统动态库文件都打包存放在一个缓存文件中。
缓存文件路径：`/System/Library/Caches/com.apple.dyld/dyld_shared_cache_armX`

`dyld_shared_cache_armX`的`X`iPhoneARM处理器指令集架构
v6
v7
v7s
arm64

所有指令集都是向下兼容的。

优点：节省内存

例如：UIKit, MapKit等Mach-O文件在其中。

# 动态库的加载

使用`dyld`加载动态库,位置`/usr/lib/dyld`,加载动态库缓存文件。

`dyld`
* dynamic link editor，动态链接编辑器
* dynamic loader，动态加载器

dyld源码
* https://opensource.apple.com/tarballs/dyld/

# 分离动态库共享缓存中的UIKit

首先下载`dyld`源码，找到`launch-cache/dsc_extractor.cpp`文件。
复制其中的`main`函数，放入新建的`cpp`文件中命名为`dsc_extractor.cpp`

编译`dsc_extractor.cpp`通过命令

```
clang++ -0 dsc_extractor dsc_extractor.cpp
```

使用`dsc_extractor`

```
./dsc_extractor  动态库共享缓存文件的路径   用于存放抽取结果的文件夹
```

# Mach-O

Mach-O是Mach object的缩写，是Mac\iOS上用于存储程序、库的标准格式。

在`xnu`源码中，查看到Mach-O格式的详细定义（https://opensource.apple.com/tarballs/xnu/）
* EXTERNAL_HEADERS/mach-o/fat.h
* EXTERNAL_HEADERS/mach-o/loader.h


## 常见的Mach-O文件类型

`MH_OBJECT`
目标文件（.o）
静态库文件(.a），静态库其实就是N个.o合并在一起

`MH_EXECUTE`：可执行文件
.app/xx

`MH_DYLIB`：动态库文件
.dylib
.framework/xx

`MH_DYLINKER`：动态链接编辑器
/usr/lib/dyld

`MH_DSYM`：存储着二进制文件符号信息的文件
.dSYM/Contents/Resources/DWARF/xx（常用于分析APP的崩溃信息）




