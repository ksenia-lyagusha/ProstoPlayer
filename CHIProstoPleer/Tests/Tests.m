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

@property XCTestExpectation *expectation;
@end

@implementation Tests

- (void)setUp {
    [super setUp];
    self.expectation = [self expectationWithDescription:@"descripton"];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSendRequestForToken
{
    [[SessionManager sharedInstance] sendRequestForTokenWithLogin:@"ksenya-15" andPassword:@"rewert-321" withComplitionHandler:^(NSString *token, NSError *error) {
        XCTAssert(token, @"Should always receive token");
        
        [self.expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:30.0 handler:^(NSError * _Nullable error) {
        XCTAssertNil(error, "Error");
    }];
}

- (void)testTopSongsList
{
    [[SessionManager sharedInstance] topSongsListForPage:1 withComplitionHandler:^(NSDictionary *topList, NSError *error) {
        XCTAssert(topList, @"Should always receive top list");
        
        [self.expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:30.0 handler:^(NSError * _Nullable error) {
        XCTAssertNil(error, "Error");
    }];
}

- (void)testSearchInfo
{
    [[SessionManager sharedInstance] searchInfoWithText:@"One Republic" withComplitionHandler:^(NSArray *searchInfo, NSError *error) {
        XCTAssert(searchInfo, @"Should always receive searching info");
        
        
        [self.expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:30.0 handler:^(NSError * _Nullable error) {
        XCTAssertNil(error, "Error");
    }];
}

- (void)testTrackLyrics
{
    [[SessionManager sharedInstance] trackLyricsWithTrackID:@"44736143Ee9" withComplitionHandler:^(NSString *text, NSError *error) {
        XCTAssert(text, @"Should receive lyrics");
        
        [self.expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:30.0 handler:^(NSError * _Nullable error) {
        XCTAssertNil(error, "Error");
    }];
}

- (void)testTracksDownloadLink
{
    [[SessionManager sharedInstance] tracksDownloadLinkWithTrackID:@"44736143Ee9" withComplitionHandler:^(NSString *link, NSError *error) {
        XCTAssert(link, @"Should receive link");
    
        [self.expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:30.0 handler:^(NSError * _Nullable error) {
        XCTAssertNil(error, "Error");
    }];
}

@end
