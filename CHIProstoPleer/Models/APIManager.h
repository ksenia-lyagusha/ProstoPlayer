//
//  APIManager.h
//  ProstoPleerApp
//
//  Created by CHI Software on 11/11/15.
//  Copyright © 2015 CHI Software. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const URL;

@interface APIManager : NSObject

+ (instancetype)sharedInstance;

- (NSURLRequest *)accessToken;
- (NSURLRequest *)refreshToken;

- (NSURLRequest *)login;
- (NSURLRequest *)searchInfo;
- (NSURLRequest *)trackInfo;
- (NSURLRequest *)trackLyrics;
- (NSURLRequest *)topSongsList;
- (NSURLRequest *)tracksDownloadLink;

@end
