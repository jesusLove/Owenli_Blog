//
//  YYModelCodeTests.m
//  YYModelCodeTests
//
//  Created by lqq on 2017/12/20.
//  Copyright © 2017年 Elink. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "YYModel.h"
#import "User.h"
#import "Book.h"
#import <objc/NSObjCRuntime.h>
@interface YYModelCodeTests : XCTestCase

@end

@implementation YYModelCodeTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


/**
 基本使用方法
 */
- (void)testExample {

    NSString *dataPath = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"];

    NSData *data = [NSData dataWithContentsOfFile:dataPath];
    NSJSONSerialization *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];

    User *user = [User yy_modelWithJSON:json];
    NSLog(@"%llu", user.uid);
    
//    NSString *str = NULL;
//    NSString *str1 = nil;
//    NSString *str2 = Nil;
//    NSLog(@"%@, %@, %@", str, str1, str2);

//    NSLog(@"nil is %p", nil);
//    NSLog(@"Nil is %p", Nil);
//    NSLog(@"NULL is %p", NULL);
//    NSLog(@"NSNull is %p", kCFNull);
    
}


- (void)testBook {
//    NSString *dataPath = [[NSBundle mainBundle] pathForResource:@"book" ofType:@"json"];
//
//    NSData *data = [NSData dataWithContentsOfFile:dataPath];
//    NSJSONSerialization *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//    Book *book = [Book yy_modelWithJSON:json];
//    NSLog(@"%@", book.name);

}




@end
