//
//  NSObject+YYModel.m
//  YYModel <https://github.com/ibireme/YYModel>
//
//  Created by ibireme on 15/5/10.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import "NSObject+YYModel.h"
#import "YYClassInfo.h"
#import <objc/message.h>

// 编译器指令
/**
 
 __attribute__: 用来声明单个编译器指令，帮助编译器检查错误以及做出更多优化。
 */
// 强制内联
#define force_inline __inline__ __attribute__((always_inline))

/// Foundation Class Type
/// Foundation类属性
typedef NS_ENUM (NSUInteger, YYEncodingNSType) {
    YYEncodingTypeNSUnknown = 0,
    YYEncodingTypeNSString,
    YYEncodingTypeNSMutableString,
    YYEncodingTypeNSValue,
    YYEncodingTypeNSNumber,
    YYEncodingTypeNSDecimalNumber,
    YYEncodingTypeNSData,
    YYEncodingTypeNSMutableData,
    YYEncodingTypeNSDate,
    YYEncodingTypeNSURL,
    YYEncodingTypeNSArray,
    YYEncodingTypeNSMutableArray,
    YYEncodingTypeNSDictionary,
    YYEncodingTypeNSMutableDictionary,
    YYEncodingTypeNSSet,
    YYEncodingTypeNSMutableSet,
};

/// Get the Foundation class type from property info.
static force_inline YYEncodingNSType YYClassGetNSType(Class cls) {
    if (!cls) return YYEncodingTypeNSUnknown;
    if ([cls isSubclassOfClass:[NSMutableString class]]) return YYEncodingTypeNSMutableString;
    if ([cls isSubclassOfClass:[NSString class]]) return YYEncodingTypeNSString;
    if ([cls isSubclassOfClass:[NSDecimalNumber class]]) return YYEncodingTypeNSDecimalNumber;
    if ([cls isSubclassOfClass:[NSNumber class]]) return YYEncodingTypeNSNumber;
    if ([cls isSubclassOfClass:[NSValue class]]) return YYEncodingTypeNSValue;
    if ([cls isSubclassOfClass:[NSMutableData class]]) return YYEncodingTypeNSMutableData;
    if ([cls isSubclassOfClass:[NSData class]]) return YYEncodingTypeNSData;
    if ([cls isSubclassOfClass:[NSDate class]]) return YYEncodingTypeNSDate;
    if ([cls isSubclassOfClass:[NSURL class]]) return YYEncodingTypeNSURL;
    if ([cls isSubclassOfClass:[NSMutableArray class]]) return YYEncodingTypeNSMutableArray;
    if ([cls isSubclassOfClass:[NSArray class]]) return YYEncodingTypeNSArray;
    if ([cls isSubclassOfClass:[NSMutableDictionary class]]) return YYEncodingTypeNSMutableDictionary;
    if ([cls isSubclassOfClass:[NSDictionary class]]) return YYEncodingTypeNSDictionary;
    if ([cls isSubclassOfClass:[NSMutableSet class]]) return YYEncodingTypeNSMutableSet;
    if ([cls isSubclassOfClass:[NSSet class]]) return YYEncodingTypeNSSet;
    return YYEncodingTypeNSUnknown;
}

/// Whether the type is c number.
static force_inline BOOL YYEncodingTypeIsCNumber(YYEncodingType type) {
    switch (type & YYEncodingTypeMask) {
        case YYEncodingTypeBool:
        case YYEncodingTypeInt8:
        case YYEncodingTypeUInt8:
        case YYEncodingTypeInt16:
        case YYEncodingTypeUInt16:
        case YYEncodingTypeInt32:
        case YYEncodingTypeUInt32:
        case YYEncodingTypeInt64:
        case YYEncodingTypeUInt64:
        case YYEncodingTypeFloat:
        case YYEncodingTypeDouble:
        case YYEncodingTypeLongDouble: return YES;
        default: return NO;
    }
}

/// Parse a number value from 'id'.
/// 根据Value转为Number
static force_inline NSNumber *YYNSNumberCreateFromID(__unsafe_unretained id value) {
    
    // 创建点字符Set，只有一个元素 点。
    // 创建一个字典：内部包含所有为null的类型和Bool的可能值
    static NSCharacterSet *dot;
    static NSDictionary *dic;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 一个点
        dot = [NSCharacterSet characterSetWithRange:NSMakeRange('.', 1)];
        // 所有的可能的空值，和Bool类型
        dic = @{@"TRUE" :   @(YES),
                @"True" :   @(YES),
                @"true" :   @(YES),
                @"FALSE" :  @(NO),
                @"False" :  @(NO),
                @"false" :  @(NO),
                @"YES" :    @(YES),
                @"Yes" :    @(YES),
                @"yes" :    @(YES),
                @"NO" :     @(NO),
                @"No" :     @(NO),
                @"no" :     @(NO),
                @"NIL" :    (id)kCFNull,
                @"Nil" :    (id)kCFNull,
                @"nil" :    (id)kCFNull,
                @"NULL" :   (id)kCFNull,
                @"Null" :   (id)kCFNull,
                @"null" :   (id)kCFNull,
                @"(NULL)" : (id)kCFNull,
                @"(Null)" : (id)kCFNull,
                @"(null)" : (id)kCFNull,
                @"<NULL>" : (id)kCFNull,
                @"<Null>" : (id)kCFNull,
                @"<null>" : (id)kCFNull};
    });
    
    // 1. 验证参数
    if (!value || value == (id)kCFNull) return nil;
    // 2. 是否是NSNumber类型，如果是直接返回
    if ([value isKindOfClass:[NSNumber class]]) return value;
    // 2. 字符串类型
    if ([value isKindOfClass:[NSString class]]) {
        // 2.1 查看是否是Bool类型或者空，查表
        NSNumber *num = dic[value];
        // 2.2 是Bool类型返回
        if (num) {
            if (num == (id)kCFNull) return nil;
            return num;
        }
        // 2.3 是否含有 . 这个字符；如果有将转为Number类型；例如： “123.456”会转为 123.456
        // 如果是 “123456” 怎会转为整数
        if ([(NSString *)value rangeOfCharacterFromSet:dot].location != NSNotFound) {
            const char *cstring = ((NSString *)value).UTF8String;
            if (!cstring) return nil;
            // double atof（const char * str;
            // 解析C字符串str，将其内容解释为浮点数，并将其值作为a返回double。
            double num = atof(cstring);
            // isnan是否是非数字值
            // isinf 返回x是无穷大值（正无穷还是负无穷）。
            if (isnan(num) || isinf(num)) return nil;
            return @(num);
        } else {
            const char *cstring = ((NSString *)value).UTF8String;
            if (!cstring) return nil;
            // atoll 解析C字符串str，将其内容解释为一个整数，作为类型的值返回long long int。
            return @(atoll(cstring));
        }
    }
    return nil;
}

/// Parse string to date.
static force_inline NSDate *YYNSDateFromString(__unsafe_unretained NSString *string) {
    typedef NSDate* (^YYNSDateParseBlock)(NSString *string);
    #define kParserNum 34
    static YYNSDateParseBlock blocks[kParserNum + 1] = {0};
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        {
            /*
             2014-01-20  // Google
             */
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
            formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
            formatter.dateFormat = @"yyyy-MM-dd";
            blocks[10] = ^(NSString *string) { return [formatter dateFromString:string]; };
        }
        
        {
            /*
             2014-01-20 12:24:48
             2014-01-20T12:24:48   // Google
             2014-01-20 12:24:48.000
             2014-01-20T12:24:48.000
             */
            NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
            formatter1.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
            formatter1.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
            formatter1.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss";
            
            NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
            formatter2.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
            formatter2.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
            formatter2.dateFormat = @"yyyy-MM-dd HH:mm:ss";

            NSDateFormatter *formatter3 = [[NSDateFormatter alloc] init];
            formatter3.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
            formatter3.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
            formatter3.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS";

            NSDateFormatter *formatter4 = [[NSDateFormatter alloc] init];
            formatter4.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
            formatter4.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
            formatter4.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSS";
            
            blocks[19] = ^(NSString *string) {
                if ([string characterAtIndex:10] == 'T') {
                    return [formatter1 dateFromString:string];
                } else {
                    return [formatter2 dateFromString:string];
                }
            };

            blocks[23] = ^(NSString *string) {
                if ([string characterAtIndex:10] == 'T') {
                    return [formatter3 dateFromString:string];
                } else {
                    return [formatter4 dateFromString:string];
                }
            };
        }
        
        {
            /*
             2014-01-20T12:24:48Z        // Github, Apple
             2014-01-20T12:24:48+0800    // Facebook
             2014-01-20T12:24:48+12:00   // Google
             2014-01-20T12:24:48.000Z
             2014-01-20T12:24:48.000+0800
             2014-01-20T12:24:48.000+12:00
             */
            NSDateFormatter *formatter = [NSDateFormatter new];
            formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
            formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZ";

            NSDateFormatter *formatter2 = [NSDateFormatter new];
            formatter2.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
            formatter2.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSSZ";

            blocks[20] = ^(NSString *string) { return [formatter dateFromString:string]; };
            blocks[24] = ^(NSString *string) { return [formatter dateFromString:string]?: [formatter2 dateFromString:string]; };
            blocks[25] = ^(NSString *string) { return [formatter dateFromString:string]; };
            blocks[28] = ^(NSString *string) { return [formatter2 dateFromString:string]; };
            blocks[29] = ^(NSString *string) { return [formatter2 dateFromString:string]; };
        }
        
        {
            /*
             Fri Sep 04 00:12:21 +0800 2015 // Weibo, Twitter
             Fri Sep 04 00:12:21.000 +0800 2015
             */
            NSDateFormatter *formatter = [NSDateFormatter new];
            formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
            formatter.dateFormat = @"EEE MMM dd HH:mm:ss Z yyyy";

            NSDateFormatter *formatter2 = [NSDateFormatter new];
            formatter2.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
            formatter2.dateFormat = @"EEE MMM dd HH:mm:ss.SSS Z yyyy";

            blocks[30] = ^(NSString *string) { return [formatter dateFromString:string]; };
            blocks[34] = ^(NSString *string) { return [formatter2 dateFromString:string]; };
        }
    });
    if (!string) return nil;
    if (string.length > kParserNum) return nil;
    YYNSDateParseBlock parser = blocks[string.length];
    if (!parser) return nil;
    return parser(string);
    #undef kParserNum
}


/// Get the 'NSBlock' class.
static force_inline Class YYNSBlockClass() {
    static Class cls;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        void (^block)(void) = ^{};
        cls = ((NSObject *)block).class;
        while (class_getSuperclass(cls) != [NSObject class]) {
            cls = class_getSuperclass(cls);
        }
    });
    return cls; // current is "NSBlock"
}



/**
 Get the ISO date formatter.
 
 ISO8601 format example:
 2010-07-09T16:13:30+12:00
 2011-01-11T11:11:11+0000
 2011-01-26T19:06:43Z
 
 length: 20/24/25
 */
static force_inline NSDateFormatter *YYISODateFormatter() {
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZ";
    });
    return formatter;
}

/// Get the value with key paths from dictionary
/// The dic should be NSDictionary, and the keyPath should not be nil.
static force_inline id YYValueForKeyPath(__unsafe_unretained NSDictionary *dic, __unsafe_unretained NSArray *keyPaths) {
    id value = nil;
    for (NSUInteger i = 0, max = keyPaths.count; i < max; i++) {
        value = dic[keyPaths[i]];
        if (i + 1 < max) {
            if ([value isKindOfClass:[NSDictionary class]]) {
                dic = value;
            } else {
                return nil;
            }
        }
    }
    return value;
}

/// Get the value with multi key (or key path) from dictionary
/// The dic should be NSDictionary
static force_inline id YYValueForMultiKeys(__unsafe_unretained NSDictionary *dic, __unsafe_unretained NSArray *multiKeys) {
    id value = nil;
    for (NSString *key in multiKeys) {
        if ([key isKindOfClass:[NSString class]]) {
            value = dic[key];
            if (value) break;
        } else {
            value = YYValueForKeyPath(dic, (NSArray *)key);
            if (value) break;
        }
    }
    return value;
}




/// A property info in object model.
@interface _YYModelPropertyMeta : NSObject {
    @package
    NSString *_name;             ///属性名称
    YYEncodingType _type;        ///属性的类型
    YYEncodingNSType _nsType;    ///属性对应的Foundation类型
    BOOL _isCNumber;             ///是否是C语言的Number类型
    Class _cls;                  ///属性的类或者为nil
    Class _genericCls;           ///容器的通用类，或者为nil
    SEL _getter;                 ///getter方法
    SEL _setter;                 ///setter方法
    BOOL _isKVCCompatible;       ///YES允许KVC访问
    BOOL _isStructAvailableForKeyedArchiver; ///YES允许归档和解档
    BOOL _hasCustomClassFromDictionary; ///< class/generic class implements +modelCustomClassForDictionary:
    
    /*
     property->key:       _mappedToKey:key     _mappedToKeyPath:nil            _mappedToKeyArray:nil
     property->keyPath:   _mappedToKey:keyPath _mappedToKeyPath:keyPath(array) _mappedToKeyArray:nil
     property->keys:      _mappedToKey:keys[0] _mappedToKeyPath:nil/keyPath    _mappedToKeyArray:keys(array)
     */
    NSString *_mappedToKey;      ///键
    NSArray *_mappedToKeyPath;   ///键路径
    NSArray *_mappedToKeyArray;  ///< the key(NSString) or keyPath(NSArray) array (nil if not mapped to multiple keys)
    YYClassPropertyInfo *_info;  ///属性信息
    _YYModelPropertyMeta *_next; ///下一个元数据，如果有多个属性映射到同一个Key值时。
}
@end

@implementation _YYModelPropertyMeta
+ (instancetype)metaWithClassInfo:(YYClassInfo *)classInfo propertyInfo:(YYClassPropertyInfo *)propertyInfo generic:(Class)generic {
    
    // support pseudo generic class with protocol name
    if (!generic && propertyInfo.protocols) {
        for (NSString *protocol in propertyInfo.protocols) {
            Class cls = objc_getClass(protocol.UTF8String);
            if (cls) {
                generic = cls;
                break;
            }
        }
    }
    
    _YYModelPropertyMeta *meta = [self new];
    meta->_name = propertyInfo.name;
    meta->_type = propertyInfo.type;
    meta->_info = propertyInfo;
    meta->_genericCls = generic;
    
    if ((meta->_type & YYEncodingTypeMask) == YYEncodingTypeObject) {
        meta->_nsType = YYClassGetNSType(propertyInfo.cls);
    } else {
        meta->_isCNumber = YYEncodingTypeIsCNumber(meta->_type);
    }
    if ((meta->_type & YYEncodingTypeMask) == YYEncodingTypeStruct) {
        /*
         It seems that NSKeyedUnarchiver cannot decode NSValue except these structs:
         */
        static NSSet *types = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            NSMutableSet *set = [NSMutableSet new];
            // 32 bit
            [set addObject:@"{CGSize=ff}"];
            [set addObject:@"{CGPoint=ff}"];
            [set addObject:@"{CGRect={CGPoint=ff}{CGSize=ff}}"];
            [set addObject:@"{CGAffineTransform=ffffff}"];
            [set addObject:@"{UIEdgeInsets=ffff}"];
            [set addObject:@"{UIOffset=ff}"];
            // 64 bit
            [set addObject:@"{CGSize=dd}"];
            [set addObject:@"{CGPoint=dd}"];
            [set addObject:@"{CGRect={CGPoint=dd}{CGSize=dd}}"];
            [set addObject:@"{CGAffineTransform=dddddd}"];
            [set addObject:@"{UIEdgeInsets=dddd}"];
            [set addObject:@"{UIOffset=dd}"];
            types = set;
        });
        if ([types containsObject:propertyInfo.typeEncoding]) {
            meta->_isStructAvailableForKeyedArchiver = YES;
        }
    }
    meta->_cls = propertyInfo.cls;
    
    if (generic) {
        meta->_hasCustomClassFromDictionary = [generic respondsToSelector:@selector(modelCustomClassForDictionary:)];
    } else if (meta->_cls && meta->_nsType == YYEncodingTypeNSUnknown) {
        meta->_hasCustomClassFromDictionary = [meta->_cls respondsToSelector:@selector(modelCustomClassForDictionary:)];
    }
    
    if (propertyInfo.getter) {
        if ([classInfo.cls instancesRespondToSelector:propertyInfo.getter]) {
            meta->_getter = propertyInfo.getter;
        }
    }
    if (propertyInfo.setter) {
        if ([classInfo.cls instancesRespondToSelector:propertyInfo.setter]) {
            meta->_setter = propertyInfo.setter;
        }
    }
    
    if (meta->_getter && meta->_setter) {
        /*
         KVC invalid type:
         long double
         pointer (such as SEL/CoreFoundation object)
         */
        switch (meta->_type & YYEncodingTypeMask) {
            case YYEncodingTypeBool:
            case YYEncodingTypeInt8:
            case YYEncodingTypeUInt8:
            case YYEncodingTypeInt16:
            case YYEncodingTypeUInt16:
            case YYEncodingTypeInt32:
            case YYEncodingTypeUInt32:
            case YYEncodingTypeInt64:
            case YYEncodingTypeUInt64:
            case YYEncodingTypeFloat:
            case YYEncodingTypeDouble:
            case YYEncodingTypeObject:
            case YYEncodingTypeClass:
            case YYEncodingTypeBlock:
            case YYEncodingTypeStruct:
            case YYEncodingTypeUnion: {
                meta->_isKVCCompatible = YES;
            } break;
            default: break;
        }
    }
    
    return meta;
}
@end

/// A class info in object model.
@interface _YYModelMeta : NSObject {
    @package
    YYClassInfo *_classInfo;
    /// Key:mapped key and key path, Value:_YYModelPropertyMeta.
    /// 值为：_YYModelPropertyMeta
    NSDictionary *_mapper;
    /// Array<_YYModelPropertyMeta>, 该Model中所有的属性
    NSArray *_allPropertyMetas;
    /// Array<_YYModelPropertyMeta>,属性元映射一个Key上
    NSArray *_keyPathPropertyMetas;
    /// Array<_YYModelPropertyMeta>,属性元映射到多个Key值。
    NSArray *_multiKeysPropertyMetas;
    /// key的个数，与mapper.count相等
    NSUInteger _keyMappedCount;
    /// model类类型
    YYEncodingNSType _nsType;
    
    BOOL _hasCustomWillTransformFromDictionary;
    BOOL _hasCustomTransformFromDictionary;
    BOOL _hasCustomTransformToDictionary;
    BOOL _hasCustomClassFromDictionary;
}
@end

@implementation _YYModelMeta

// 创建YYModelMeta实例
- (instancetype)initWithClass:(Class)cls {
    // 对所有属性进行初始化
    
    // 1. 创建ClassInfo
    YYClassInfo *classInfo = [YYClassInfo classInfoWithClass:cls];
    if (!classInfo) return nil;
    self = [super init];
    
    // Get black list
    // 2. 读取黑名单
    NSSet *blacklist = nil;
    if ([cls respondsToSelector:@selector(modelPropertyBlacklist)]) {
        NSArray *properties = [(id<YYModel>)cls modelPropertyBlacklist];
        if (properties) {
            blacklist = [NSSet setWithArray:properties];
        }
    }
    
    // Get white list
    // 3. 读取白名单
    NSSet *whitelist = nil;
    if ([cls respondsToSelector:@selector(modelPropertyWhitelist)]) {
        NSArray *properties = [(id<YYModel>)cls modelPropertyWhitelist];
        if (properties) {
            whitelist = [NSSet setWithArray:properties];
        }
    }
    
    // Get container property's generic class
    // 4. 获取
    NSDictionary *genericMapper = nil;
    if ([cls respondsToSelector:@selector(modelContainerPropertyGenericClass)]) {
        genericMapper = [(id<YYModel>)cls modelContainerPropertyGenericClass];
        if (genericMapper) {
            NSMutableDictionary *tmp = [NSMutableDictionary new];
            [genericMapper enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                if (![key isKindOfClass:[NSString class]]) return;
                Class meta = object_getClass(obj);
                if (!meta) return;
                if (class_isMetaClass(meta)) {
                    tmp[key] = obj;
                } else if ([obj isKindOfClass:[NSString class]]) {
                    Class cls = NSClassFromString(obj);
                    if (cls) {
                        tmp[key] = cls;
                    }
                }
            }];
            genericMapper = tmp;
        }
    }
    
    // Create all property metas.
    // 5. 获取所有属性meta
    NSMutableDictionary *allPropertyMetas = [NSMutableDictionary new];
    YYClassInfo *curClassInfo = classInfo;
    // 5.1 循环遍历父类，忽略根类NSObject/NSProxy, 获取所有的属性
    while (curClassInfo && curClassInfo.superCls != nil) { // recursive parse super class, but ignore root class (NSObject/NSProxy)
        // 5.2 遍历所有的属性
        for (YYClassPropertyInfo *propertyInfo in curClassInfo.propertyInfos.allValues) {
            if (!propertyInfo.name) continue;
            // 黑白名单过滤，符合黑名单的过滤掉，不符合白名单的过滤掉
            if (blacklist && [blacklist containsObject:propertyInfo.name]) continue;
            if (whitelist && ![whitelist containsObject:propertyInfo.name]) continue;
            
            //
            _YYModelPropertyMeta *meta = [_YYModelPropertyMeta metaWithClassInfo:classInfo
                                                                    propertyInfo:propertyInfo
                                                                         generic:genericMapper[propertyInfo.name]];
            if (!meta || !meta->_name) continue;
            if (!meta->_getter || !meta->_setter) continue;
            if (allPropertyMetas[meta->_name]) continue;
            allPropertyMetas[meta->_name] = meta;
        }
        // 遍历父类
        curClassInfo = curClassInfo.superClassInfo;
    }
    
    
    if (allPropertyMetas.count) _allPropertyMetas = allPropertyMetas.allValues.copy;
    
    // create mapper
    NSMutableDictionary *mapper = [NSMutableDictionary new];
    NSMutableArray *keyPathPropertyMetas = [NSMutableArray new];
    NSMutableArray *multiKeysPropertyMetas = [NSMutableArray new];
    
    // 6. 处理属性映射
    if ([cls respondsToSelector:@selector(modelCustomPropertyMapper)]) {
        NSDictionary *customMapper = [(id <YYModel>)cls modelCustomPropertyMapper];
        
        // 6.1 遍历映射字典
        //mappedToKey: 对应的类型,是指@[@"id",@"ID",@"book_id"]
        [customMapper enumerateKeysAndObjectsUsingBlock:^(NSString *propertyName, id mappedToKey, BOOL *stop) {
            
            // 6.2 获取的属性元
            _YYModelPropertyMeta *propertyMeta = allPropertyMetas[propertyName];
            if (!propertyMeta) return;
            // 获取后移除
            [allPropertyMetas removeObjectForKey:propertyName];
            
            // mappedToKey是字符串事
            /**
             @{@"name" : @"n",
             @"page" : @"p",
             @"desc" : @"ext.desc",
             @"bookID" : @[@"id",@"ID",@"book_id"]};
             */
            if ([mappedToKey isKindOfClass:[NSString class]]) {
                if (((NSString *)mappedToKey).length == 0) return;
                
                propertyMeta->_mappedToKey = mappedToKey;
                // 处理这种情况      @"desc" : @"ext.desc",
                NSArray *keyPath = [mappedToKey componentsSeparatedByString:@"."];
                for (NSString *onePath in keyPath) {
                    if (onePath.length == 0) {
                        NSMutableArray *tmp = keyPath.mutableCopy;
                        [tmp removeObject:@""];
                        keyPath = tmp;
                        break;
                    }
                }
                if (keyPath.count > 1) {
                    propertyMeta->_mappedToKeyPath = keyPath;
                    [keyPathPropertyMetas addObject:propertyMeta];
                }
                propertyMeta->_next = mapper[mappedToKey] ?: nil;
                mapper[mappedToKey] = propertyMeta;
                
            } else if ([mappedToKey isKindOfClass:[NSArray class]]) {
                // 处理 @[@"id",@"ID",@"book_id"]}; 情况
                NSMutableArray *mappedToKeyArray = [NSMutableArray new];
                for (NSString *oneKey in ((NSArray *)mappedToKey)) {
                    if (![oneKey isKindOfClass:[NSString class]]) continue;
                    if (oneKey.length == 0) continue;
                    
                    NSArray *keyPath = [oneKey componentsSeparatedByString:@"."];
                    if (keyPath.count > 1) {
                        [mappedToKeyArray addObject:keyPath];
                    } else {
                        [mappedToKeyArray addObject:oneKey];
                    }
                    
                    if (!propertyMeta->_mappedToKey) {
                        propertyMeta->_mappedToKey = oneKey;
                        propertyMeta->_mappedToKeyPath = keyPath.count > 1 ? keyPath : nil;
                    }
                }
                if (!propertyMeta->_mappedToKey) return;
                
                propertyMeta->_mappedToKeyArray = mappedToKeyArray;
                [multiKeysPropertyMetas addObject:propertyMeta];
                
                propertyMeta->_next = mapper[mappedToKey] ?: nil;
                mapper[mappedToKey] = propertyMeta;
            }
        }];
    }
    
    [allPropertyMetas enumerateKeysAndObjectsUsingBlock:^(NSString *name, _YYModelPropertyMeta *propertyMeta, BOOL *stop) {
        propertyMeta->_mappedToKey = name;
        propertyMeta->_next = mapper[name] ?: nil;
        mapper[name] = propertyMeta;
    }];
    
    if (mapper.count) _mapper = mapper;
    if (keyPathPropertyMetas) _keyPathPropertyMetas = keyPathPropertyMetas;
    if (multiKeysPropertyMetas) _multiKeysPropertyMetas = multiKeysPropertyMetas;
    
    _classInfo = classInfo;
    _keyMappedCount = _allPropertyMetas.count;
    _nsType = YYClassGetNSType(cls);
    _hasCustomWillTransformFromDictionary = ([cls instancesRespondToSelector:@selector(modelCustomWillTransformFromDictionary:)]);
    _hasCustomTransformFromDictionary = ([cls instancesRespondToSelector:@selector(modelCustomTransformFromDictionary:)]);
    _hasCustomTransformToDictionary = ([cls instancesRespondToSelector:@selector(modelCustomTransformToDictionary:)]);
    _hasCustomClassFromDictionary = ([cls respondsToSelector:@selector(modelCustomClassForDictionary:)]);
    
    return self;
}

/// Returns the cached model class meta
/// 这里使用了GCD中信号量的知识
/**
    使用信号量来控制最大并发线程数
    create创建（信号量值）；wait等待降低信号量（信号量，等待时间）；signal：提高信号量（信号量）。
    当信号量为1时，只能一个执行完才进行下一个。
 */
+ (instancetype)metaWithClass:(Class)cls {
    if (!cls) return nil;
    
    // 单例
    static CFMutableDictionaryRef cache;
    static dispatch_once_t onceToken;
    static dispatch_semaphore_t lock;
    dispatch_once(&onceToken, ^{
        
        // 参数
        // 1. 分配器用于为新字典分配内存以及为键值对分配内存。传递NULL或kCFAllocatorDefault以使用当前的默认分配器
        // 2. 指定字典最大容量，0表示不受限制。
        // 3. 一个指针，该结构用于retain, release, describe和compare字典中键的回调。
        // 4. 同上，字典中值的回调
        cache = CFDictionaryCreateMutable(CFAllocatorGetDefault(), 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
        lock = dispatch_semaphore_create(1);
    });
    dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
    // 读取cls作为键值时的缓存
    _YYModelMeta *meta = CFDictionaryGetValue(cache, (__bridge const void *)(cls));
    dispatch_semaphore_signal(lock);
    // 未读取到或者需要更新，则需重新创建
    if (!meta || meta->_classInfo.needUpdate) {
        meta = [[_YYModelMeta alloc] initWithClass:cls];
        if (meta) {
            dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
            // 添加到缓存中
            CFDictionarySetValue(cache, (__bridge const void *)(cls), (__bridge const void *)(meta));
            dispatch_semaphore_signal(lock);
        }
    }
    return meta;
}

@end


/**
 Get number from property.
 @discussion Caller should hold strong reference to the parameters before this function returns.
 @param model Should not be nil.
 @param meta  Should not be nil, meta.isCNumber should be YES, meta.getter should not be nil.
 @return A number object, or nil if failed.
 */
static force_inline NSNumber *ModelCreateNumberFromProperty(__unsafe_unretained id model,
                                                            __unsafe_unretained _YYModelPropertyMeta *meta) {
    switch (meta->_type & YYEncodingTypeMask) {
        case YYEncodingTypeBool: {
            return @(((bool (*)(id, SEL))(void *) objc_msgSend)((id)model, meta->_getter));
        }
        case YYEncodingTypeInt8: {
            return @(((int8_t (*)(id, SEL))(void *) objc_msgSend)((id)model, meta->_getter));
        }
        case YYEncodingTypeUInt8: {
            return @(((uint8_t (*)(id, SEL))(void *) objc_msgSend)((id)model, meta->_getter));
        }
        case YYEncodingTypeInt16: {
            return @(((int16_t (*)(id, SEL))(void *) objc_msgSend)((id)model, meta->_getter));
        }
        case YYEncodingTypeUInt16: {
            return @(((uint16_t (*)(id, SEL))(void *) objc_msgSend)((id)model, meta->_getter));
        }
        case YYEncodingTypeInt32: {
            return @(((int32_t (*)(id, SEL))(void *) objc_msgSend)((id)model, meta->_getter));
        }
        case YYEncodingTypeUInt32: {
            return @(((uint32_t (*)(id, SEL))(void *) objc_msgSend)((id)model, meta->_getter));
        }
        case YYEncodingTypeInt64: {
            return @(((int64_t (*)(id, SEL))(void *) objc_msgSend)((id)model, meta->_getter));
        }
        case YYEncodingTypeUInt64: {
            return @(((uint64_t (*)(id, SEL))(void *) objc_msgSend)((id)model, meta->_getter));
        }
        case YYEncodingTypeFloat: {
            float num = ((float (*)(id, SEL))(void *) objc_msgSend)((id)model, meta->_getter);
            if (isnan(num) || isinf(num)) return nil;
            return @(num);
        }
        case YYEncodingTypeDouble: {
            double num = ((double (*)(id, SEL))(void *) objc_msgSend)((id)model, meta->_getter);
            if (isnan(num) || isinf(num)) return nil;
            return @(num);
        }
        case YYEncodingTypeLongDouble: {
            double num = ((long double (*)(id, SEL))(void *) objc_msgSend)((id)model, meta->_getter);
            if (isnan(num) || isinf(num)) return nil;
            return @(num);
        }
        default: return nil;
    }
}

/**
 Set number to property.
 @discussion Caller should hold strong reference to the parameters before this function returns.
 @param model Should not be nil.
 @param num   Can be nil.
 @param meta  Should not be nil, meta.isCNumber should be YES, meta.setter should not be nil.
 */
static force_inline void ModelSetNumberToProperty(__unsafe_unretained id model,
                                                  __unsafe_unretained NSNumber *num,
                                                  __unsafe_unretained _YYModelPropertyMeta *meta) {
    
    switch (meta->_type & YYEncodingTypeMask) {
        
        // Bool类型，
        case YYEncodingTypeBool: {
            // objc_msgSend: 对model,调用setter方法，将num赋值
            ((void (*)(id, SEL, bool))(void *) objc_msgSend)((id)model, meta->_setter, num.boolValue);
        } break;
        case YYEncodingTypeInt8: {
            ((void (*)(id, SEL, int8_t))(void *) objc_msgSend)((id)model, meta->_setter, (int8_t)num.charValue);
        } break;
        case YYEncodingTypeUInt8: {
            ((void (*)(id, SEL, uint8_t))(void *) objc_msgSend)((id)model, meta->_setter, (uint8_t)num.unsignedCharValue);
        } break;
        case YYEncodingTypeInt16: {
            ((void (*)(id, SEL, int16_t))(void *) objc_msgSend)((id)model, meta->_setter, (int16_t)num.shortValue);
        } break;
        case YYEncodingTypeUInt16: {
            ((void (*)(id, SEL, uint16_t))(void *) objc_msgSend)((id)model, meta->_setter, (uint16_t)num.unsignedShortValue);
        } break;
        case YYEncodingTypeInt32: {
            ((void (*)(id, SEL, int32_t))(void *) objc_msgSend)((id)model, meta->_setter, (int32_t)num.intValue);
        }
        case YYEncodingTypeUInt32: {
            ((void (*)(id, SEL, uint32_t))(void *) objc_msgSend)((id)model, meta->_setter, (uint32_t)num.unsignedIntValue);
        } break;
        case YYEncodingTypeInt64: {
            if ([num isKindOfClass:[NSDecimalNumber class]]) {
                ((void (*)(id, SEL, int64_t))(void *) objc_msgSend)((id)model, meta->_setter, (int64_t)num.stringValue.longLongValue);
            } else {
                ((void (*)(id, SEL, uint64_t))(void *) objc_msgSend)((id)model, meta->_setter, (uint64_t)num.longLongValue);
            }
        } break;
        case YYEncodingTypeUInt64: {
            if ([num isKindOfClass:[NSDecimalNumber class]]) {
                ((void (*)(id, SEL, int64_t))(void *) objc_msgSend)((id)model, meta->_setter, (int64_t)num.stringValue.longLongValue);
            } else {
                ((void (*)(id, SEL, uint64_t))(void *) objc_msgSend)((id)model, meta->_setter, (uint64_t)num.unsignedLongLongValue);
            }
        } break;
        case YYEncodingTypeFloat: {
            float f = num.floatValue;
            if (isnan(f) || isinf(f)) f = 0;
            ((void (*)(id, SEL, float))(void *) objc_msgSend)((id)model, meta->_setter, f);
        } break;
        case YYEncodingTypeDouble: {
            double d = num.doubleValue;
            if (isnan(d) || isinf(d)) d = 0;
            ((void (*)(id, SEL, double))(void *) objc_msgSend)((id)model, meta->_setter, d);
        } break;
        case YYEncodingTypeLongDouble: {
            long double d = num.doubleValue;
            if (isnan(d) || isinf(d)) d = 0;
            ((void (*)(id, SEL, long double))(void *) objc_msgSend)((id)model, meta->_setter, (long double)d);
        } // break; commented for code coverage in next line
        default: break;
    }
}

/**
 Set value to model with a property meta.
 
 @discussion Caller should hold strong reference to the parameters before this function returns.
 
 @param model Should not be nil.
 @param value Should not be nil, but can be NSNull.
 @param meta  Should not be nil, and meta->_setter should not be nil.
 */
static void ModelSetValueForProperty(__unsafe_unretained id model,
                                     __unsafe_unretained id value,
                                     __unsafe_unretained _YYModelPropertyMeta *meta) {
    // 判断是否是C语言Number类型。此类型对应YYEncodingTypeIsCNumber中的类型
    if (meta->_isCNumber) {
        // 根据类型将值转为NSNumber类型。
        NSNumber *num = YYNSNumberCreateFromID(value);
        ModelSetNumberToProperty(model, num, meta);
        if (num) [num class]; // hold the number
        
    } else if (meta->_nsType) {
        if (value == (id)kCFNull) {
            ((void (*)(id, SEL, id))(void *) objc_msgSend)((id)model, meta->_setter, (id)nil);
        } else {
            switch (meta->_nsType) {
                case YYEncodingTypeNSString:
                case YYEncodingTypeNSMutableString: {
                    if ([value isKindOfClass:[NSString class]]) {
                        if (meta->_nsType == YYEncodingTypeNSString) {
                            ((void (*)(id, SEL, id))(void *) objc_msgSend)((id)model, meta->_setter, value);
                        } else {
                            ((void (*)(id, SEL, id))(void *) objc_msgSend)((id)model, meta->_setter, ((NSString *)value).mutableCopy);
                        }
                    } else if ([value isKindOfClass:[NSNumber class]]) {
                        ((void (*)(id, SEL, id))(void *) objc_msgSend)((id)model,
                                                                       meta->_setter,
                                                                       (meta->_nsType == YYEncodingTypeNSString) ?
                                                                       ((NSNumber *)value).stringValue :
                                                                       ((NSNumber *)value).stringValue.mutableCopy);
                    } else if ([value isKindOfClass:[NSData class]]) {
                        NSMutableString *string = [[NSMutableString alloc] initWithData:value encoding:NSUTF8StringEncoding];
                        ((void (*)(id, SEL, id))(void *) objc_msgSend)((id)model, meta->_setter, string);
                    } else if ([value isKindOfClass:[NSURL class]]) {
                        ((void (*)(id, SEL, id))(void *) objc_msgSend)((id)model,
                                                                       meta->_setter,
                                                                       (meta->_nsType == YYEncodingTypeNSString) ?
                                                                       ((NSURL *)value).absoluteString :
                                                                       ((NSURL *)value).absoluteString.mutableCopy);
                    } else if ([value isKindOfClass:[NSAttributedString class]]) {
                        ((void (*)(id, SEL, id))(void *) objc_msgSend)((id)model,
                                                                       meta->_setter,
                                                                       (meta->_nsType == YYEncodingTypeNSString) ?
                                                                       ((NSAttributedString *)value).string :
                                                                       ((NSAttributedString *)value).string.mutableCopy);
                    }
                } break;
                    
                case YYEncodingTypeNSValue:
                case YYEncodingTypeNSNumber:
                case YYEncodingTypeNSDecimalNumber: {
                    if (meta->_nsType == YYEncodingTypeNSNumber) {
                        ((void (*)(id, SEL, id))(void *) objc_msgSend)((id)model, meta->_setter, YYNSNumberCreateFromID(value));
                    } else if (meta->_nsType == YYEncodingTypeNSDecimalNumber) {
                        if ([value isKindOfClass:[NSDecimalNumber class]]) {
                            ((void (*)(id, SEL, id))(void *) objc_msgSend)((id)model, meta->_setter, value);
                        } else if ([value isKindOfClass:[NSNumber class]]) {
                            NSDecimalNumber *decNum = [NSDecimalNumber decimalNumberWithDecimal:[((NSNumber *)value) decimalValue]];
                            ((void (*)(id, SEL, id))(void *) objc_msgSend)((id)model, meta->_setter, decNum);
                        } else if ([value isKindOfClass:[NSString class]]) {
                            NSDecimalNumber *decNum = [NSDecimalNumber decimalNumberWithString:value];
                            NSDecimal dec = decNum.decimalValue;
                            if (dec._length == 0 && dec._isNegative) {
                                decNum = nil; // NaN
                            }
                            ((void (*)(id, SEL, id))(void *) objc_msgSend)((id)model, meta->_setter, decNum);
                        }
                    } else { // YYEncodingTypeNSValue
                        if ([value isKindOfClass:[NSValue class]]) {
                            ((void (*)(id, SEL, id))(void *) objc_msgSend)((id)model, meta->_setter, value);
                        }
                    }
                } break;
                    
                case YYEncodingTypeNSData:
                case YYEncodingTypeNSMutableData: {
                    if ([value isKindOfClass:[NSData class]]) {
                        if (meta->_nsType == YYEncodingTypeNSData) {
                            ((void (*)(id, SEL, id))(void *) objc_msgSend)((id)model, meta->_setter, value);
                        } else {
                            NSMutableData *data = ((NSData *)value).mutableCopy;
                            ((void (*)(id, SEL, id))(void *) objc_msgSend)((id)model, meta->_setter, data);
                        }
                    } else if ([value isKindOfClass:[NSString class]]) {
                        NSData *data = [(NSString *)value dataUsingEncoding:NSUTF8StringEncoding];
                        if (meta->_nsType == YYEncodingTypeNSMutableData) {
                            data = ((NSData *)data).mutableCopy;
                        }
                        ((void (*)(id, SEL, id))(void *) objc_msgSend)((id)model, meta->_setter, data);
                    }
                } break;
                    
                case YYEncodingTypeNSDate: {
                    if ([value isKindOfClass:[NSDate class]]) {
                        ((void (*)(id, SEL, id))(void *) objc_msgSend)((id)model, meta->_setter, value);
                    } else if ([value isKindOfClass:[NSString class]]) {
                        ((void (*)(id, SEL, id))(void *) objc_msgSend)((id)model, meta->_setter, YYNSDateFromString(value));
                    }
                } break;
                    
                case YYEncodingTypeNSURL: {
                    if ([value isKindOfClass:[NSURL class]]) {
                        ((void (*)(id, SEL, id))(void *) objc_msgSend)((id)model, meta->_setter, value);
                    } else if ([value isKindOfClass:[NSString class]]) {
                        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
                        NSString *str = [value stringByTrimmingCharactersInSet:set];
                        if (str.length == 0) {
                            ((void (*)(id, SEL, id))(void *) objc_msgSend)((id)model, meta->_setter, nil);
                        } else {
                            ((void (*)(id, SEL, id))(void *) objc_msgSend)((id)model, meta->_setter, [[NSURL alloc] initWithString:str]);
                        }
                    }
                } break;
                    
                case YYEncodingTypeNSArray:
                case YYEncodingTypeNSMutableArray: {
                    if (meta->_genericCls) {
                        NSArray *valueArr = nil;
                        if ([value isKindOfClass:[NSArray class]]) valueArr = value;
                        else if ([value isKindOfClass:[NSSet class]]) valueArr = ((NSSet *)value).allObjects;
                        if (valueArr) {
                            NSMutableArray *objectArr = [NSMutableArray new];
                            for (id one in valueArr) {
                                if ([one isKindOfClass:meta->_genericCls]) {
                                    [objectArr addObject:one];
                                } else if ([one isKindOfClass:[NSDictionary class]]) {
                                    Class cls = meta->_genericCls;
                                    if (meta->_hasCustomClassFromDictionary) {
                                        cls = [cls modelCustomClassForDictionary:one];
                                        if (!cls) cls = meta->_genericCls; // for xcode code coverage
                                    }
                                    NSObject *newOne = [cls new];
                                    [newOne yy_modelSetWithDictionary:one];
                                    if (newOne) [objectArr addObject:newOne];
                                }
                            }
                            ((void (*)(id, SEL, id))(void *) objc_msgSend)((id)model, meta->_setter, objectArr);
                        }
                    } else {
                        if ([value isKindOfClass:[NSArray class]]) {
                            if (meta->_nsType == YYEncodingTypeNSArray) {
                                ((void (*)(id, SEL, id))(void *) objc_msgSend)((id)model, meta->_setter, value);
                            } else {
                                ((void (*)(id, SEL, id))(void *) objc_msgSend)((id)model,
                                                                               meta->_setter,
                                                                               ((NSArray *)value).mutableCopy);
                            }
                        } else if ([value isKindOfClass:[NSSet class]]) {
                            if (meta->_nsType == YYEncodingTypeNSArray) {
                                ((void (*)(id, SEL, id))(void *) objc_msgSend)((id)model, meta->_setter, ((NSSet *)value).allObjects);
                            } else {
                                ((void (*)(id, SEL, id))(void *) objc_msgSend)((id)model,
                                                                               meta->_setter,
                                                                               ((NSSet *)value).allObjects.mutableCopy);
                            }
                        }
                    }
                } break;
                    
                case YYEncodingTypeNSDictionary:
                case YYEncodingTypeNSMutableDictionary: {
                    if ([value isKindOfClass:[NSDictionary class]]) {
                        if (meta->_genericCls) {
                            NSMutableDictionary *dic = [NSMutableDictionary new];
                            [((NSDictionary *)value) enumerateKeysAndObjectsUsingBlock:^(NSString *oneKey, id oneValue, BOOL *stop) {
                                if ([oneValue isKindOfClass:[NSDictionary class]]) {
                                    Class cls = meta->_genericCls;
                                    if (meta->_hasCustomClassFromDictionary) {
                                        cls = [cls modelCustomClassForDictionary:oneValue];
                                        if (!cls) cls = meta->_genericCls; // for xcode code coverage
                                    }
                                    NSObject *newOne = [cls new];
                                    [newOne yy_modelSetWithDictionary:(id)oneValue];
                                    if (newOne) dic[oneKey] = newOne;
                                }
                            }];
                            ((void (*)(id, SEL, id))(void *) objc_msgSend)((id)model, meta->_setter, dic);
                        } else {
                            if (meta->_nsType == YYEncodingTypeNSDictionary) {
                                ((void (*)(id, SEL, id))(void *) objc_msgSend)((id)model, meta->_setter, value);
                            } else {
                                ((void (*)(id, SEL, id))(void *) objc_msgSend)((id)model,
                                                                               meta->_setter,
                                                                               ((NSDictionary *)value).mutableCopy);
                            }
                        }
                    }
                } break;
                    
                case YYEncodingTypeNSSet:
                case YYEncodingTypeNSMutableSet: {
                    NSSet *valueSet = nil;
                    if ([value isKindOfClass:[NSArray class]]) valueSet = [NSMutableSet setWithArray:value];
                    else if ([value isKindOfClass:[NSSet class]]) valueSet = ((NSSet *)value);
                    
                    if (meta->_genericCls) {
                        NSMutableSet *set = [NSMutableSet new];
                        for (id one in valueSet) {
                            if ([one isKindOfClass:meta->_genericCls]) {
                                [set addObject:one];
                            } else if ([one isKindOfClass:[NSDictionary class]]) {
                                Class cls = meta->_genericCls;
                                if (meta->_hasCustomClassFromDictionary) {
                                    cls = [cls modelCustomClassForDictionary:one];
                                    if (!cls) cls = meta->_genericCls; // for xcode code coverage
                                }
                                NSObject *newOne = [cls new];
                                [newOne yy_modelSetWithDictionary:one];
                                if (newOne) [set addObject:newOne];
                            }
                        }
                        ((void (*)(id, SEL, id))(void *) objc_msgSend)((id)model, meta->_setter, set);
                    } else {
                        if (meta->_nsType == YYEncodingTypeNSSet) {
                            ((void (*)(id, SEL, id))(void *) objc_msgSend)((id)model, meta->_setter, valueSet);
                        } else {
                            ((void (*)(id, SEL, id))(void *) objc_msgSend)((id)model,
                                                                           meta->_setter,
                                                                           ((NSSet *)valueSet).mutableCopy);
                        }
                    }
                } // break; commented for code coverage in next line
                    
                default: break;
            }
        }
    } else {
        BOOL isNull = (value == (id)kCFNull);
        switch (meta->_type & YYEncodingTypeMask) {
            case YYEncodingTypeObject: {
                if (isNull) {
                    ((void (*)(id, SEL, id))(void *) objc_msgSend)((id)model, meta->_setter, (id)nil);
                } else if ([value isKindOfClass:meta->_cls] || !meta->_cls) {
                    ((void (*)(id, SEL, id))(void *) objc_msgSend)((id)model, meta->_setter, (id)value);
                } else if ([value isKindOfClass:[NSDictionary class]]) {
                    NSObject *one = nil;
                    if (meta->_getter) {
                        one = ((id (*)(id, SEL))(void *) objc_msgSend)((id)model, meta->_getter);
                    }
                    if (one) {
                        [one yy_modelSetWithDictionary:value];
                    } else {
                        Class cls = meta->_cls;
                        if (meta->_hasCustomClassFromDictionary) {
                            cls = [cls modelCustomClassForDictionary:value];
                            if (!cls) cls = meta->_genericCls; // for xcode code coverage
                        }
                        one = [cls new];
                        [one yy_modelSetWithDictionary:value];
                        ((void (*)(id, SEL, id))(void *) objc_msgSend)((id)model, meta->_setter, (id)one);
                    }
                }
            } break;
                
            case YYEncodingTypeClass: {
                if (isNull) {
                    ((void (*)(id, SEL, Class))(void *) objc_msgSend)((id)model, meta->_setter, (Class)NULL);
                } else {
                    Class cls = nil;
                    if ([value isKindOfClass:[NSString class]]) {
                        cls = NSClassFromString(value);
                        if (cls) {
                            ((void (*)(id, SEL, Class))(void *) objc_msgSend)((id)model, meta->_setter, (Class)cls);
                        }
                    } else {
                        cls = object_getClass(value);
                        if (cls) {
                            if (class_isMetaClass(cls)) {
                                ((void (*)(id, SEL, Class))(void *) objc_msgSend)((id)model, meta->_setter, (Class)value);
                            }
                        }
                    }
                }
            } break;
                
            case  YYEncodingTypeSEL: {
                if (isNull) {
                    ((void (*)(id, SEL, SEL))(void *) objc_msgSend)((id)model, meta->_setter, (SEL)NULL);
                } else if ([value isKindOfClass:[NSString class]]) {
                    SEL sel = NSSelectorFromString(value);
                    if (sel) ((void (*)(id, SEL, SEL))(void *) objc_msgSend)((id)model, meta->_setter, (SEL)sel);
                }
            } break;
                
            case YYEncodingTypeBlock: {
                if (isNull) {
                    ((void (*)(id, SEL, void (^)()))(void *) objc_msgSend)((id)model, meta->_setter, (void (^)())NULL);
                } else if ([value isKindOfClass:YYNSBlockClass()]) {
                    ((void (*)(id, SEL, void (^)()))(void *) objc_msgSend)((id)model, meta->_setter, (void (^)())value);
                }
            } break;
                
            case YYEncodingTypeStruct:
            case YYEncodingTypeUnion:
            case YYEncodingTypeCArray: {
                if ([value isKindOfClass:[NSValue class]]) {
                    const char *valueType = ((NSValue *)value).objCType;
                    const char *metaType = meta->_info.typeEncoding.UTF8String;
                    if (valueType && metaType && strcmp(valueType, metaType) == 0) {
                        [model setValue:value forKey:meta->_name];
                    }
                }
            } break;
                
            case YYEncodingTypePointer:
            case YYEncodingTypeCString: {
                if (isNull) {
                    ((void (*)(id, SEL, void *))(void *) objc_msgSend)((id)model, meta->_setter, (void *)NULL);
                } else if ([value isKindOfClass:[NSValue class]]) {
                    NSValue *nsValue = value;
                    if (nsValue.objCType && strcmp(nsValue.objCType, "^v") == 0) {
                        ((void (*)(id, SEL, void *))(void *) objc_msgSend)((id)model, meta->_setter, nsValue.pointerValue);
                    }
                }
            } // break; commented for code coverage in next line
                
            default: break;
        }
    }
}


typedef struct {
    void *modelMeta;  ///< _YYModelMeta
    void *model;      ///< id (self)
    void *dictionary; ///< NSDictionary (json)
} ModelSetContext;

/**
 Apply function for dictionary, to set the key-value pair to model.
 
 @param _key     should not be nil, NSString.
 @param _value   should not be nil.
 @param _context _context.modelMeta and _context.model should not be nil.
 */

static void ModelSetWithDictionaryFunction(const void *_key, const void *_value, void *_context) {
    // 上下文，包含模型元，模型实例，字典
    ModelSetContext *context = _context;
    //模型元
    __unsafe_unretained _YYModelMeta *meta = (__bridge _YYModelMeta *)(context->modelMeta);
    //在模型元属性字典中查找键值为key的属性
    __unsafe_unretained _YYModelPropertyMeta *propertyMeta = [meta->_mapper objectForKey:(__bridge id)(_key)];
    // 模型实例
    __unsafe_unretained id model = (__bridge id)(context->model);
    
    while (propertyMeta) {
        if (propertyMeta->_setter) {
            // 核心内容
            ModelSetValueForProperty(model, (__bridge __unsafe_unretained id)_value, propertyMeta);
        }
        propertyMeta = propertyMeta->_next;
    };
}

/**
 Apply function for model property meta, to set dictionary to model.
 
 @param _propertyMeta should not be nil, _YYModelPropertyMeta.
 @param _context      _context.model and _context.dictionary should not be nil.
 */
static void ModelSetWithPropertyMetaArrayFunction(const void *_propertyMeta, void *_context) {
    ModelSetContext *context = _context;
    __unsafe_unretained NSDictionary *dictionary = (__bridge NSDictionary *)(context->dictionary);
    __unsafe_unretained _YYModelPropertyMeta *propertyMeta = (__bridge _YYModelPropertyMeta *)(_propertyMeta);
    if (!propertyMeta->_setter) return;
    id value = nil;
    
    if (propertyMeta->_mappedToKeyArray) {
        value = YYValueForMultiKeys(dictionary, propertyMeta->_mappedToKeyArray);
    } else if (propertyMeta->_mappedToKeyPath) {
        value = YYValueForKeyPath(dictionary, propertyMeta->_mappedToKeyPath);
    } else {
        value = [dictionary objectForKey:propertyMeta->_mappedToKey];
    }
    
    if (value) {
        __unsafe_unretained id model = (__bridge id)(context->model);
        ModelSetValueForProperty(model, value, propertyMeta);
    }
}

/**
 Returns a valid JSON object (NSArray/NSDictionary/NSString/NSNumber/NSNull), 
 or nil if an error occurs.
 
 @param model Model, can be nil.
 @return JSON object, nil if an error occurs.
 */
static id ModelToJSONObjectRecursive(NSObject *model) {
    // 验证参数
    if (!model || model == (id)kCFNull) return model;
    // NSString和NSNumber直接返回
    if ([model isKindOfClass:[NSString class]]) return model;
    if ([model isKindOfClass:[NSNumber class]]) return model;
    // 字典
    if ([model isKindOfClass:[NSDictionary class]]) {
        // 验证，有效的JSON对象，直接返回
        if ([NSJSONSerialization isValidJSONObject:model]) return model;
        // 临时可变字典
        NSMutableDictionary *newDic = [NSMutableDictionary new];
        // 遍历字典所有值
        [((NSDictionary *)model) enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
            // 获取Key值
            NSString *stringKey = [key isKindOfClass:[NSString class]] ? key : key.description;
            if (!stringKey) return;
            // 递归调用本方法
            id jsonObj = ModelToJSONObjectRecursive(obj);
            if (!jsonObj) jsonObj = (id)kCFNull;
            // 存放到临时字典中
            newDic[stringKey] = jsonObj;
        }];
        return newDic;
    }
    // 集合
    if ([model isKindOfClass:[NSSet class]]) {
        // 获取所有值，存放到临时数组中。
        NSArray *array = ((NSSet *)model).allObjects;
        // isValidJSONObject直接返回
        if ([NSJSONSerialization isValidJSONObject:array]) return array;
        // 临时数组
        NSMutableArray *newArray = [NSMutableArray new];
        // 对数组元素处理
        for (id obj in array) {
            if ([obj isKindOfClass:[NSString class]] || [obj isKindOfClass:[NSNumber class]]) {
                [newArray addObject:obj];
            } else {
                id jsonObj = ModelToJSONObjectRecursive(obj);
                if (jsonObj && jsonObj != (id)kCFNull) [newArray addObject:jsonObj];
            }
        }
        return newArray;
    }
    if ([model isKindOfClass:[NSArray class]]) {
        if ([NSJSONSerialization isValidJSONObject:model]) return model;
        NSMutableArray *newArray = [NSMutableArray new];
        for (id obj in (NSArray *)model) {
            if ([obj isKindOfClass:[NSString class]] || [obj isKindOfClass:[NSNumber class]]) {
                [newArray addObject:obj];
            } else {
                id jsonObj = ModelToJSONObjectRecursive(obj);
                if (jsonObj && jsonObj != (id)kCFNull) [newArray addObject:jsonObj];
            }
        }
        return newArray;
    }
    // NSURL, NSAttributedString,NSDate, NSData处理
    if ([model isKindOfClass:[NSURL class]]) return ((NSURL *)model).absoluteString;
    if ([model isKindOfClass:[NSAttributedString class]]) return ((NSAttributedString *)model).string;
    if ([model isKindOfClass:[NSDate class]]) return [YYISODateFormatter() stringFromDate:(id)model];
    if ([model isKindOfClass:[NSData class]]) return nil;
    
    
    _YYModelMeta *modelMeta = [_YYModelMeta metaWithClass:[model class]];
    if (!modelMeta || modelMeta->_keyMappedCount == 0) return nil;
    NSMutableDictionary *result = [[NSMutableDictionary alloc] initWithCapacity:64];
    __unsafe_unretained NSMutableDictionary *dic = result; // avoid retain and release in block
    [modelMeta->_mapper enumerateKeysAndObjectsUsingBlock:^(NSString *propertyMappedKey, _YYModelPropertyMeta *propertyMeta, BOOL *stop) {
        if (!propertyMeta->_getter) return;
        
        id value = nil;
        if (propertyMeta->_isCNumber) {
            value = ModelCreateNumberFromProperty(model, propertyMeta);
        } else if (propertyMeta->_nsType) {
            id v = ((id (*)(id, SEL))(void *) objc_msgSend)((id)model, propertyMeta->_getter);
            value = ModelToJSONObjectRecursive(v);
        } else {
            switch (propertyMeta->_type & YYEncodingTypeMask) {
                case YYEncodingTypeObject: {
                    id v = ((id (*)(id, SEL))(void *) objc_msgSend)((id)model, propertyMeta->_getter);
                    value = ModelToJSONObjectRecursive(v);
                    if (value == (id)kCFNull) value = nil;
                } break;
                case YYEncodingTypeClass: {
                    Class v = ((Class (*)(id, SEL))(void *) objc_msgSend)((id)model, propertyMeta->_getter);
                    value = v ? NSStringFromClass(v) : nil;
                } break;
                case YYEncodingTypeSEL: {
                    SEL v = ((SEL (*)(id, SEL))(void *) objc_msgSend)((id)model, propertyMeta->_getter);
                    value = v ? NSStringFromSelector(v) : nil;
                } break;
                default: break;
            }
        }
        if (!value) return;
        
        if (propertyMeta->_mappedToKeyPath) {
            NSMutableDictionary *superDic = dic;
            NSMutableDictionary *subDic = nil;
            for (NSUInteger i = 0, max = propertyMeta->_mappedToKeyPath.count; i < max; i++) {
                NSString *key = propertyMeta->_mappedToKeyPath[i];
                if (i + 1 == max) { // end
                    if (!superDic[key]) superDic[key] = value;
                    break;
                }
                
                subDic = superDic[key];
                if (subDic) {
                    if ([subDic isKindOfClass:[NSDictionary class]]) {
                        subDic = subDic.mutableCopy;
                        superDic[key] = subDic;
                    } else {
                        break;
                    }
                } else {
                    subDic = [NSMutableDictionary new];
                    superDic[key] = subDic;
                }
                superDic = subDic;
                subDic = nil;
            }
        } else {
            if (!dic[propertyMeta->_mappedToKey]) {
                dic[propertyMeta->_mappedToKey] = value;
            }
        }
    }];
    
    if (modelMeta->_hasCustomTransformToDictionary) {
        BOOL suc = [((id<YYModel>)model) modelCustomTransformToDictionary:dic];
        if (!suc) return nil;
    }
    return result;
}

/// Add indent to string (exclude first line)
static NSMutableString *ModelDescriptionAddIndent(NSMutableString *desc, NSUInteger indent) {
    for (NSUInteger i = 0, max = desc.length; i < max; i++) {
        unichar c = [desc characterAtIndex:i];
        if (c == '\n') {
            for (NSUInteger j = 0; j < indent; j++) {
                [desc insertString:@"    " atIndex:i + 1];
            }
            i += indent * 4;
            max += indent * 4;
        }
    }
    return desc;
}

/// Generaate a description string
static NSString *ModelDescription(NSObject *model) {
    static const int kDescMaxLength = 100;
    if (!model) return @"<nil>";
    if (model == (id)kCFNull) return @"<null>";
    if (![model isKindOfClass:[NSObject class]]) return [NSString stringWithFormat:@"%@",model];
    
    
    _YYModelMeta *modelMeta = [_YYModelMeta metaWithClass:model.class];
    switch (modelMeta->_nsType) {
        case YYEncodingTypeNSString: case YYEncodingTypeNSMutableString: {
            return [NSString stringWithFormat:@"\"%@\"",model];
        }
        
        case YYEncodingTypeNSValue:
        case YYEncodingTypeNSData: case YYEncodingTypeNSMutableData: {
            NSString *tmp = model.description;
            if (tmp.length > kDescMaxLength) {
                tmp = [tmp substringToIndex:kDescMaxLength];
                tmp = [tmp stringByAppendingString:@"..."];
            }
            return tmp;
        }
            
        case YYEncodingTypeNSNumber:
        case YYEncodingTypeNSDecimalNumber:
        case YYEncodingTypeNSDate:
        case YYEncodingTypeNSURL: {
            return [NSString stringWithFormat:@"%@",model];
        }
            
        case YYEncodingTypeNSSet: case YYEncodingTypeNSMutableSet: {
            model = ((NSSet *)model).allObjects;
        } // no break
            
        case YYEncodingTypeNSArray: case YYEncodingTypeNSMutableArray: {
            NSArray *array = (id)model;
            NSMutableString *desc = [NSMutableString new];
            if (array.count == 0) {
                return [desc stringByAppendingString:@"[]"];
            } else {
                [desc appendFormat:@"[\n"];
                for (NSUInteger i = 0, max = array.count; i < max; i++) {
                    NSObject *obj = array[i];
                    [desc appendString:@"    "];
                    [desc appendString:ModelDescriptionAddIndent(ModelDescription(obj).mutableCopy, 1)];
                    [desc appendString:(i + 1 == max) ? @"\n" : @";\n"];
                }
                [desc appendString:@"]"];
                return desc;
            }
        }
        case YYEncodingTypeNSDictionary: case YYEncodingTypeNSMutableDictionary: {
            NSDictionary *dic = (id)model;
            NSMutableString *desc = [NSMutableString new];
            if (dic.count == 0) {
                return [desc stringByAppendingString:@"{}"];
            } else {
                NSArray *keys = dic.allKeys;
                
                [desc appendFormat:@"{\n"];
                for (NSUInteger i = 0, max = keys.count; i < max; i++) {
                    NSString *key = keys[i];
                    NSObject *value = dic[key];
                    [desc appendString:@"    "];
                    [desc appendFormat:@"%@ = %@",key, ModelDescriptionAddIndent(ModelDescription(value).mutableCopy, 1)];
                    [desc appendString:(i + 1 == max) ? @"\n" : @";\n"];
                }
                [desc appendString:@"}"];
            }
            return desc;
        }
        
        default: {
            NSMutableString *desc = [NSMutableString new];
            [desc appendFormat:@"<%@: %p>", model.class, model];
            if (modelMeta->_allPropertyMetas.count == 0) return desc;
            
            // sort property names
            NSArray *properties = [modelMeta->_allPropertyMetas
                                   sortedArrayUsingComparator:^NSComparisonResult(_YYModelPropertyMeta *p1, _YYModelPropertyMeta *p2) {
                                       return [p1->_name compare:p2->_name];
                                   }];
            
            [desc appendFormat:@" {\n"];
            for (NSUInteger i = 0, max = properties.count; i < max; i++) {
                _YYModelPropertyMeta *property = properties[i];
                NSString *propertyDesc;
                if (property->_isCNumber) {
                    NSNumber *num = ModelCreateNumberFromProperty(model, property);
                    propertyDesc = num.stringValue;
                } else {
                    switch (property->_type & YYEncodingTypeMask) {
                        case YYEncodingTypeObject: {
                            id v = ((id (*)(id, SEL))(void *) objc_msgSend)((id)model, property->_getter);
                            propertyDesc = ModelDescription(v);
                            if (!propertyDesc) propertyDesc = @"<nil>";
                        } break;
                        case YYEncodingTypeClass: {
                            id v = ((id (*)(id, SEL))(void *) objc_msgSend)((id)model, property->_getter);
                            propertyDesc = ((NSObject *)v).description;
                            if (!propertyDesc) propertyDesc = @"<nil>";
                        } break;
                        case YYEncodingTypeSEL: {
                            SEL sel = ((SEL (*)(id, SEL))(void *) objc_msgSend)((id)model, property->_getter);
                            if (sel) propertyDesc = NSStringFromSelector(sel);
                            else propertyDesc = @"<NULL>";
                        } break;
                        case YYEncodingTypeBlock: {
                            id block = ((id (*)(id, SEL))(void *) objc_msgSend)((id)model, property->_getter);
                            propertyDesc = block ? ((NSObject *)block).description : @"<nil>";
                        } break;
                        case YYEncodingTypeCArray: case YYEncodingTypeCString: case YYEncodingTypePointer: {
                            void *pointer = ((void* (*)(id, SEL))(void *) objc_msgSend)((id)model, property->_getter);
                            propertyDesc = [NSString stringWithFormat:@"%p",pointer];
                        } break;
                        case YYEncodingTypeStruct: case YYEncodingTypeUnion: {
                            NSValue *value = [model valueForKey:property->_name];
                            propertyDesc = value ? value.description : @"{unknown}";
                        } break;
                        default: propertyDesc = @"<unknown>";
                    }
                }
                
                propertyDesc = ModelDescriptionAddIndent(propertyDesc.mutableCopy, 1);
                [desc appendFormat:@"    %@ = %@",property->_name, propertyDesc];
                [desc appendString:(i + 1 == max) ? @"\n" : @";\n"];
            }
            [desc appendFormat:@"}"];
            return desc;
        }
    }
}


/**
  NSObject + YYModel
 */
@implementation NSObject (YYModel)


/**
 JSON -> Dictionary

 @param json NSDictionary，Data，NSString
 @return 字典
 */
+ (NSDictionary *)_yy_dictionaryWithJSON:(id)json {
    // 首先验证json是否为nil,和是否为空。 kCFNull 是NSNULL的单例
    if (!json || json == (id)kCFNull) return nil;
    
    // 定义两个临时变量
    NSDictionary *dic = nil;
    NSData *jsonData = nil;
    
    // 根据类型将json转为Data
    if ([json isKindOfClass:[NSDictionary class]]) {
        dic = json;
    } else if ([json isKindOfClass:[NSString class]]) {
        jsonData = [(NSString *)json dataUsingEncoding : NSUTF8StringEncoding];
    } else if ([json isKindOfClass:[NSData class]]) {
        jsonData = json;
    }
    // 将Data数据转为字典
    if (jsonData) {
        dic = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:NULL];
        // 注意是否转换成功，可能为nil
        if (![dic isKindOfClass:[NSDictionary class]]) dic = nil;
    }
    return dic;
}


#pragma mark -  json -> model
+ (instancetype)yy_modelWithJSON:(id)json {
    NSDictionary *dic = [self _yy_dictionaryWithJSON:json];
    return [self yy_modelWithDictionary:dic];
}

/**
 字典转model

 @param dictionary 字典
 @return 返回Model对象
 */
+ (instancetype)yy_modelWithDictionary:(NSDictionary *)dictionary {
    // 1. 验证，空值，nil和是否是字典
    if (!dictionary || dictionary == (id)kCFNull) return nil;
    if (![dictionary isKindOfClass:[NSDictionary class]]) return nil;
    
    Class cls = [self class];
    // 2. 创建一个YYModelMeta对象
    _YYModelMeta *modelMeta = [_YYModelMeta metaWithClass:cls];
    // 是否实现modelCustomClassForDictionary协议方法
    if (modelMeta->_hasCustomClassFromDictionary) {
        cls = [cls modelCustomClassForDictionary:dictionary] ?: cls;
    }
    // 3. 创建model对象
    NSObject *one = [cls new];
    
    if ([one yy_modelSetWithDictionary:dictionary])
        return one;
    
    return nil;
}

#pragma mark -
- (BOOL)yy_modelSetWithJSON:(id)json {
    NSDictionary *dic = [NSObject _yy_dictionaryWithJSON:json];
    return [self yy_modelSetWithDictionary:dic];
}

- (BOOL)yy_modelSetWithDictionary:(NSDictionary *)dic {
    // 1. 值和类型验证
    if (!dic || dic == (id)kCFNull) return NO;
    if (![dic isKindOfClass:[NSDictionary class]]) return NO;
    
    // 2. 创建Modelmeta对象
    _YYModelMeta *modelMeta = [_YYModelMeta metaWithClass:object_getClass(self)];
    // 属性个数，如为零返回。创建失败
    if (modelMeta->_keyMappedCount == 0) return NO;
    // YYModel协议，暂且忽略
    if (modelMeta->_hasCustomWillTransformFromDictionary) {
        dic = [((id<YYModel>)self) modelCustomWillTransformFromDictionary:dic];
        if (![dic isKindOfClass:[NSDictionary class]]) return NO;
    }
    // 3. 创建结构体
    ModelSetContext context = {0};
    context.modelMeta = (__bridge void *)(modelMeta);
    context.model = (__bridge void *)(self);
    context.dictionary = (__bridge void *)(dic);
    
    // 模型元值数量和字典数量关系
    // 1. 通常情况是两者相等，
    // 2. 模型元键值少于字典个数
    if (modelMeta->_keyMappedCount >= CFDictionaryGetCount((CFDictionaryRef)dic)) {
        
        // 调用ModelSetWithDictionaryFunction方法，这是核心方法。
        // 参数：
        // 1. 要操作的字典
        // 2. 为每个键值对调用一次的回调函数
        // 3. 指针大小的程序定义的值，作为第三个参数传递给应用程序函数，但此函数未使用该值. 与参数2适应
        CFDictionaryApplyFunction((CFDictionaryRef)dic, ModelSetWithDictionaryFunction, &context);
        
        // 是否存在映射keyPath属性元
        if (modelMeta->_keyPathPropertyMetas) {
            // 每个keypath都执行ModelSetWithPropertyMetaArrayFunction
            CFArrayApplyFunction((CFArrayRef)modelMeta->_keyPathPropertyMetas,
                                 CFRangeMake(0, CFArrayGetCount((CFArrayRef)modelMeta->_keyPathPropertyMetas)),
                                 ModelSetWithPropertyMetaArrayFunction,
                                 &context);
        }
        // 是否存在映射多个key的属性元
        if (modelMeta->_multiKeysPropertyMetas) {
            // 每个keypath都执行ModelSetWithPropertyMetaArrayFunction
            CFArrayApplyFunction((CFArrayRef)modelMeta->_multiKeysPropertyMetas,
                                 CFRangeMake(0, CFArrayGetCount((CFArrayRef)modelMeta->_multiKeysPropertyMetas)),
                                 ModelSetWithPropertyMetaArrayFunction,
                                 &context);
        }
        
    } else {
        // 每个keypath都执行ModelSetWithPropertyMetaArrayFunction
        CFArrayApplyFunction((CFArrayRef)modelMeta->_allPropertyMetas,
                             CFRangeMake(0, modelMeta->_keyMappedCount),
                             ModelSetWithPropertyMetaArrayFunction,
                             &context);
    }
    // 忽略
    if (modelMeta->_hasCustomTransformFromDictionary) {
        return [((id<YYModel>)self) modelCustomTransformFromDictionary:dic];
    }
    return YES;
}




- (id)yy_modelToJSONObject {
    /*
     Apple said:
     The top level object is an NSArray or NSDictionary.
     All objects are instances of NSString, NSNumber, NSArray, NSDictionary, or NSNull.
     All dictionary keys are instances of NSString.
     Numbers are not NaN or infinity.
     */
    id jsonObject = ModelToJSONObjectRecursive(self);
    if ([jsonObject isKindOfClass:[NSArray class]]) return jsonObject;
    if ([jsonObject isKindOfClass:[NSDictionary class]]) return jsonObject;
    return nil;
}

- (NSData *)yy_modelToJSONData {
    id jsonObject = [self yy_modelToJSONObject];
    if (!jsonObject) return nil;
    return [NSJSONSerialization dataWithJSONObject:jsonObject options:0 error:NULL];
}

- (NSString *)yy_modelToJSONString {
    NSData *jsonData = [self yy_modelToJSONData];
    if (jsonData.length == 0) return nil;
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}


#pragma mark - 其他一些信息，复制，归档，哈希值等
- (id)yy_modelCopy{
    if (self == (id)kCFNull) return self;
    _YYModelMeta *modelMeta = [_YYModelMeta metaWithClass:self.class];
    if (modelMeta->_nsType) return [self copy];
    
    NSObject *one = [self.class new];
    for (_YYModelPropertyMeta *propertyMeta in modelMeta->_allPropertyMetas) {
        if (!propertyMeta->_getter || !propertyMeta->_setter) continue;
        
        if (propertyMeta->_isCNumber) {
            switch (propertyMeta->_type & YYEncodingTypeMask) {
                case YYEncodingTypeBool: {
                    bool num = ((bool (*)(id, SEL))(void *) objc_msgSend)((id)self, propertyMeta->_getter);
                    ((void (*)(id, SEL, bool))(void *) objc_msgSend)((id)one, propertyMeta->_setter, num);
                } break;
                case YYEncodingTypeInt8:
                case YYEncodingTypeUInt8: {
                    uint8_t num = ((bool (*)(id, SEL))(void *) objc_msgSend)((id)self, propertyMeta->_getter);
                    ((void (*)(id, SEL, uint8_t))(void *) objc_msgSend)((id)one, propertyMeta->_setter, num);
                } break;
                case YYEncodingTypeInt16:
                case YYEncodingTypeUInt16: {
                    uint16_t num = ((uint16_t (*)(id, SEL))(void *) objc_msgSend)((id)self, propertyMeta->_getter);
                    ((void (*)(id, SEL, uint16_t))(void *) objc_msgSend)((id)one, propertyMeta->_setter, num);
                } break;
                case YYEncodingTypeInt32:
                case YYEncodingTypeUInt32: {
                    uint32_t num = ((uint32_t (*)(id, SEL))(void *) objc_msgSend)((id)self, propertyMeta->_getter);
                    ((void (*)(id, SEL, uint32_t))(void *) objc_msgSend)((id)one, propertyMeta->_setter, num);
                } break;
                case YYEncodingTypeInt64:
                case YYEncodingTypeUInt64: {
                    uint64_t num = ((uint64_t (*)(id, SEL))(void *) objc_msgSend)((id)self, propertyMeta->_getter);
                    ((void (*)(id, SEL, uint64_t))(void *) objc_msgSend)((id)one, propertyMeta->_setter, num);
                } break;
                case YYEncodingTypeFloat: {
                    float num = ((float (*)(id, SEL))(void *) objc_msgSend)((id)self, propertyMeta->_getter);
                    ((void (*)(id, SEL, float))(void *) objc_msgSend)((id)one, propertyMeta->_setter, num);
                } break;
                case YYEncodingTypeDouble: {
                    double num = ((double (*)(id, SEL))(void *) objc_msgSend)((id)self, propertyMeta->_getter);
                    ((void (*)(id, SEL, double))(void *) objc_msgSend)((id)one, propertyMeta->_setter, num);
                } break;
                case YYEncodingTypeLongDouble: {
                    long double num = ((long double (*)(id, SEL))(void *) objc_msgSend)((id)self, propertyMeta->_getter);
                    ((void (*)(id, SEL, long double))(void *) objc_msgSend)((id)one, propertyMeta->_setter, num);
                } // break; commented for code coverage in next line
                default: break;
            }
        } else {
            switch (propertyMeta->_type & YYEncodingTypeMask) {
                case YYEncodingTypeObject:
                case YYEncodingTypeClass:
                case YYEncodingTypeBlock: {
                    id value = ((id (*)(id, SEL))(void *) objc_msgSend)((id)self, propertyMeta->_getter);
                    ((void (*)(id, SEL, id))(void *) objc_msgSend)((id)one, propertyMeta->_setter, value);
                } break;
                case YYEncodingTypeSEL:
                case YYEncodingTypePointer:
                case YYEncodingTypeCString: {
                    size_t value = ((size_t (*)(id, SEL))(void *) objc_msgSend)((id)self, propertyMeta->_getter);
                    ((void (*)(id, SEL, size_t))(void *) objc_msgSend)((id)one, propertyMeta->_setter, value);
                } break;
                case YYEncodingTypeStruct:
                case YYEncodingTypeUnion: {
                    @try {
                        NSValue *value = [self valueForKey:NSStringFromSelector(propertyMeta->_getter)];
                        if (value) {
                            [one setValue:value forKey:propertyMeta->_name];
                        }
                    } @catch (NSException *exception) {}
                } // break; commented for code coverage in next line
                default: break;
            }
        }
    }
    return one;
}

- (void)yy_modelEncodeWithCoder:(NSCoder *)aCoder {
    if (!aCoder) return;
    if (self == (id)kCFNull) {
        [((id<NSCoding>)self)encodeWithCoder:aCoder];
        return;
    }
    
    _YYModelMeta *modelMeta = [_YYModelMeta metaWithClass:self.class];
    if (modelMeta->_nsType) {
        [((id<NSCoding>)self)encodeWithCoder:aCoder];
        return;
    }
    
    for (_YYModelPropertyMeta *propertyMeta in modelMeta->_allPropertyMetas) {
        if (!propertyMeta->_getter) return;
        
        if (propertyMeta->_isCNumber) {
            NSNumber *value = ModelCreateNumberFromProperty(self, propertyMeta);
            if (value) [aCoder encodeObject:value forKey:propertyMeta->_name];
        } else {
            switch (propertyMeta->_type & YYEncodingTypeMask) {
                case YYEncodingTypeObject: {
                    id value = ((id (*)(id, SEL))(void *)objc_msgSend)((id)self, propertyMeta->_getter);
                    if (value && (propertyMeta->_nsType || [value respondsToSelector:@selector(encodeWithCoder:)])) {
                        if ([value isKindOfClass:[NSValue class]]) {
                            if ([value isKindOfClass:[NSNumber class]]) {
                                [aCoder encodeObject:value forKey:propertyMeta->_name];
                            }
                        } else {
                            [aCoder encodeObject:value forKey:propertyMeta->_name];
                        }
                    }
                } break;
                case YYEncodingTypeSEL: {
                    SEL value = ((SEL (*)(id, SEL))(void *)objc_msgSend)((id)self, propertyMeta->_getter);
                    if (value) {
                        NSString *str = NSStringFromSelector(value);
                        [aCoder encodeObject:str forKey:propertyMeta->_name];
                    }
                } break;
                case YYEncodingTypeStruct:
                case YYEncodingTypeUnion: {
                    if (propertyMeta->_isKVCCompatible && propertyMeta->_isStructAvailableForKeyedArchiver) {
                        @try {
                            NSValue *value = [self valueForKey:NSStringFromSelector(propertyMeta->_getter)];
                            [aCoder encodeObject:value forKey:propertyMeta->_name];
                        } @catch (NSException *exception) {}
                    }
                } break;
                    
                default:
                    break;
            }
        }
    }
}

- (id)yy_modelInitWithCoder:(NSCoder *)aDecoder {
    if (!aDecoder) return self;
    if (self == (id)kCFNull) return self;    
    _YYModelMeta *modelMeta = [_YYModelMeta metaWithClass:self.class];
    if (modelMeta->_nsType) return self;
    
    for (_YYModelPropertyMeta *propertyMeta in modelMeta->_allPropertyMetas) {
        if (!propertyMeta->_setter) continue;
        
        if (propertyMeta->_isCNumber) {
            NSNumber *value = [aDecoder decodeObjectForKey:propertyMeta->_name];
            if ([value isKindOfClass:[NSNumber class]]) {
                ModelSetNumberToProperty(self, value, propertyMeta);
                [value class];
            }
        } else {
            YYEncodingType type = propertyMeta->_type & YYEncodingTypeMask;
            switch (type) {
                case YYEncodingTypeObject: {
                    id value = [aDecoder decodeObjectForKey:propertyMeta->_name];
                    ((void (*)(id, SEL, id))(void *) objc_msgSend)((id)self, propertyMeta->_setter, value);
                } break;
                case YYEncodingTypeSEL: {
                    NSString *str = [aDecoder decodeObjectForKey:propertyMeta->_name];
                    if ([str isKindOfClass:[NSString class]]) {
                        SEL sel = NSSelectorFromString(str);
                        ((void (*)(id, SEL, SEL))(void *) objc_msgSend)((id)self, propertyMeta->_setter, sel);
                    }
                } break;
                case YYEncodingTypeStruct:
                case YYEncodingTypeUnion: {
                    if (propertyMeta->_isKVCCompatible) {
                        @try {
                            NSValue *value = [aDecoder decodeObjectForKey:propertyMeta->_name];
                            if (value) [self setValue:value forKey:propertyMeta->_name];
                        } @catch (NSException *exception) {}
                    }
                } break;
                    
                default:
                    break;
            }
        }
    }
    return self;
}

- (NSUInteger)yy_modelHash {
    if (self == (id)kCFNull) return [self hash];
    _YYModelMeta *modelMeta = [_YYModelMeta metaWithClass:self.class];
    if (modelMeta->_nsType) return [self hash];
    
    NSUInteger value = 0;
    NSUInteger count = 0;
    for (_YYModelPropertyMeta *propertyMeta in modelMeta->_allPropertyMetas) {
        if (!propertyMeta->_isKVCCompatible) continue;
        value ^= [[self valueForKey:NSStringFromSelector(propertyMeta->_getter)] hash];
        count++;
    }
    if (count == 0) value = (long)((__bridge void *)self);
    return value;
}

- (BOOL)yy_modelIsEqual:(id)model {
    if (self == model) return YES;
    if (![model isMemberOfClass:self.class]) return NO;
    _YYModelMeta *modelMeta = [_YYModelMeta metaWithClass:self.class];
    if (modelMeta->_nsType) return [self isEqual:model];
    if ([self hash] != [model hash]) return NO;
    
    for (_YYModelPropertyMeta *propertyMeta in modelMeta->_allPropertyMetas) {
        if (!propertyMeta->_isKVCCompatible) continue;
        id this = [self valueForKey:NSStringFromSelector(propertyMeta->_getter)];
        id that = [model valueForKey:NSStringFromSelector(propertyMeta->_getter)];
        if (this == that) continue;
        if (this == nil || that == nil) return NO;
        if (![this isEqual:that]) return NO;
    }
    return YES;
}

- (NSString *)yy_modelDescription {
    return ModelDescription(self);
}

@end



@implementation NSArray (YYModel)

+ (NSArray *)yy_modelArrayWithClass:(Class)cls json:(id)json {
    if (!json) return nil;
    NSArray *arr = nil;
    NSData *jsonData = nil;
    if ([json isKindOfClass:[NSArray class]]) {
        arr = json;
    } else if ([json isKindOfClass:[NSString class]]) {
        jsonData = [(NSString *)json dataUsingEncoding : NSUTF8StringEncoding];
    } else if ([json isKindOfClass:[NSData class]]) {
        jsonData = json;
    }
    if (jsonData) {
        arr = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:NULL];
        if (![arr isKindOfClass:[NSArray class]]) arr = nil;
    }
    return [self yy_modelArrayWithClass:cls array:arr];
}

+ (NSArray *)yy_modelArrayWithClass:(Class)cls array:(NSArray *)arr {
    if (!cls || !arr) return nil;
    NSMutableArray *result = [NSMutableArray new];
    for (NSDictionary *dic in arr) {
        if (![dic isKindOfClass:[NSDictionary class]]) continue;
        NSObject *obj = [cls yy_modelWithDictionary:dic];
        if (obj) [result addObject:obj];
    }
    return result;
}

@end


@implementation NSDictionary (YYModel)

+ (NSDictionary *)yy_modelDictionaryWithClass:(Class)cls json:(id)json {
    if (!json) return nil;
    NSDictionary *dic = nil;
    NSData *jsonData = nil;
    if ([json isKindOfClass:[NSDictionary class]]) {
        dic = json;
    } else if ([json isKindOfClass:[NSString class]]) {
        jsonData = [(NSString *)json dataUsingEncoding : NSUTF8StringEncoding];
    } else if ([json isKindOfClass:[NSData class]]) {
        jsonData = json;
    }
    if (jsonData) {
        dic = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:NULL];
        if (![dic isKindOfClass:[NSDictionary class]]) dic = nil;
    }
    return [self yy_modelDictionaryWithClass:cls dictionary:dic];
}

+ (NSDictionary *)yy_modelDictionaryWithClass:(Class)cls dictionary:(NSDictionary *)dic {
    if (!cls || !dic) return nil;
    NSMutableDictionary *result = [NSMutableDictionary new];
    for (NSString *key in dic.allKeys) {
        if (![key isKindOfClass:[NSString class]]) continue;
        NSObject *obj = [cls yy_modelWithDictionary:dic[key]];
        if (obj) result[key] = obj;
    }
    return result;
}

@end
