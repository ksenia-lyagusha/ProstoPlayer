//
//  Tests.m
//  Tests
//
//  Created by CHI Software on 11/11/15.
//  Copyright © 2015 CHI Software. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "SessionManager.h"

@interface Tests : XCTestCase

@end

@implementation Tests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    SessionManager *manager = [[SessionManager alloc] init];
    NSAssert(manager, @"Manager always should create");
}

- (void)testFalseTest {
    
    SessionManager *manager = [[SessionManager alloc] init];
    NSAssert(!manager, @"This is bullshit");
}
//- (void)testPerformanceExample {
//    // This is an example of a performance test case.
//    [self measureBlock:^{
//        // Put the code you want to measure the time of here.
//    }];
//}

@end
