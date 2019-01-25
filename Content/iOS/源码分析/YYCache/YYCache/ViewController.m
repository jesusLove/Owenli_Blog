//
//  ViewController.m
//  YYCache
//
//  Created by LQQ on 2019/1/14.
//  Copyright © 2019 Elink. All rights reserved.
//

#import "ViewController.h"
#import "YYCache.h"

@interface Person : NSObject <NSCoding>
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) UIImage *image;
- (instancetype)initWithName:(NSString *)name address:(NSString *)address;
@end
@implementation Person
- (instancetype)initWithName:(NSString *)name address:(NSString *)address {
    self = [super init];
    if (self) {
        self.name = name;
        self.address = address;
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.address forKey:@"address"];
}
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.address = [aDecoder decodeObjectForKey:@"address"];
    }
    return self;
}
- (NSString *)description {
    return [NSString stringWithFormat:@"%@ - %@", self.name, self.address];
}

@end


@interface ViewController ()

@property (nonatomic, strong) YYCache *cache;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@", self.cache.diskCache.path);
    [self saveData];
    [self fetchData];
}
- (void)saveData {
    // 字符串
    [self.cache setObject:@"哈哈" forKey:@"name"];
    // 对象
    Person *p = [[Person alloc] initWithName:@"owenli" address:@"山东青岛"];
    [self.cache setObject:p forKey:@"person"];

}
- (void)fetchData {
    // 读取字符串
    NSLog(@"%@", [self.cache objectForKey:@"name"]);
    // 读取自定义对象
    Person *p = (Person *)[self.cache objectForKey:@"person"];
    NSLog(@"%@", p);
}

#pragma mark - lazy method
- (YYCache *)cache {
    if (!_cache) {
        _cache = [YYCache cacheWithName:@"test"];
    }
    return _cache;
}

@end
