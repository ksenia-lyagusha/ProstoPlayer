//
//  SessionManager.h
//  ProstoPleerApp
//
//  Created by CHI Software on 11/11/15.
//  Copyright © 2015 CHI Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SessionManager : NSObject <NSURLSessionDataDelegate, NSURLSessionDelegate>

+ (instancetype)sharedInstance;
+ (NSString *)userToken;

- (void)sendRequestForTokenWithLogin:(NSString *)login andPassword:(NSString *)password withComplitionHandler:(void(^)(NSString *token, NSError *error))completion;

- (void)searchInfoWithText:(NSString *)text withComplitionHandler:(void(^)(NSArray *searchInfo, NSError *error))completion;

- (void)topSongsList:(void(^)(NSDictionary *topList, NSError *error))completion;

- (void)trackLyricsWithTrackID:(NSString *)trackID withComplitionHandler:(void(^)(NSString *title, NSError *error))completion;

- (void)tracksDownloadLinkWithTrackID:(NSString *)trackID withComplitionHandler:(void(^)(NSString *, NSError *))completion;

@end
