//
//  SessionManager.h
//  ProstoPleerApp
//
//  Created by CHI Software on 11/11/15.
//  Copyright © 2015 CHI Software. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const SessionManagerAccessToken;
extern NSString * const SessionManagerURL;
extern NSString * const SessionManagerTokenURL;

@interface SessionManager : NSObject <NSURLSessionDataDelegate, NSURLSessionDelegate>

+ (instancetype)sharedInstance;

- (void)sendRequestForToken;
- (void)sendRequestForToken:(void(^)(NSString *token, NSError *error))completion;

- (void)searchInfo;
- (void)searchInfo:(void(^)(NSString *token, NSError *error))completion;

- (void)topSongsList;
- (void)topSongsList:(void(^)(NSString *title, NSError *error))completion;

- (void)trackLyrics;
- (void)trackLyrics:(void(^)(NSString *title, NSError *error))completion;

- (void)tracksDownloadLink;
- (void)tracksDownloadLink:(void(^)(NSString *title, NSError *error))completion;

@end
