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

- (void)testSendRequestForToken {
 
    [[SessionManager sharedInstance] sendRequestForToken:^(NSString *token, NSError *error) {
        XCTAssert(token, @"Should always receive token");
    }];
}

- (void)testTopSongsList
{
    [[SessionManager sharedInstance] topSongsList:^(NSString *searchResult, NSError *error) {
        XCTAssert(searchResult, @"Should always receive token");
    }];
    
}

- (void)testSearchInfo
{
    [[SessionManager sharedInstance] searchInfo:^(NSString *searchResult, NSError *error) {
        XCTAssert(searchResult, @"Should always receive token");
    }];
}

- (void)testTrackLyrics
{
    [[SessionManager sharedInstance] trackLyrics:^(NSString *text, NSError *error) {
        XCTAssert(text, @"Should receive lyric");
    }];

}

- (void)testTracksDownloadLink
{
    [[SessionManager sharedInstance] tracksDownloadLink:^(NSString *link, NSError *error) {
        XCTAssert(link, @"Should receive link");
    }];
    
}

@end
