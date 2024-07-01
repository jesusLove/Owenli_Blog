#  CocoaLumberjack

> CocoaLumberjack is a fast & simple, yet powerful & flexible logging framework for Mac and iOS.

一个快速、简单但功能强大且灵活的Mac和iOS日志库。

# 一、基础

通过`CocoaPods`可以方便安装。通过官方仓库查看基本介绍[CocoaLumberjack](https://github.com/CocoaLumberjack/CocoaLumberjack)

引入头文件`#import <CocoaLumberjack/CocoaLumberjack.h>`，注意还需要配置`Log`级别。这些一般会写在`.pch`文件中。

```objc
#import "CocoaLumberjack.h"

#ifdef DEBUG
static const DDLogLevel ddLogLevel = DDLogLevelVerbose;
#else
static const DDLogLevel ddLogLevel = DDLogLevelError;
#endif

```

提供的Log方式：

1. `DDLog` ：框架的核心
2. `DDOSLogger` : iOS 10和之后使用
3. `DDTTYLogger`:  将日志在控制台输出
4.  `DDASLLogger` : 发送到苹果日志系统，在console.app上显示。
5. `DDFileLogger` : 将日志写入到本地文件。


Log级别：

```
typedef NS_OPTIONS(NSUInteger, DDLogFlag){
    /**
    *  0...00001 DDLogFlagError
    */
    DDLogFlagError      = (1 << 0), // x错误

    /**
    *  0...00010 DDLogFlagWarning  
    */
    DDLogFlagWarning    = (1 << 1),// 警告

    /**
    *  0...00100 DDLogFlagInfo
    */
    DDLogFlagInfo       = (1 << 2), // 信息

    /**
    *  0...01000 DDLogFlagDebug 
    */
    DDLogFlagDebug      = (1 << 3), // 调试

    /**
    *  0...10000 DDLogFlagVerbose
    */
    DDLogFlagVerbose    = (1 << 4)
};
```
