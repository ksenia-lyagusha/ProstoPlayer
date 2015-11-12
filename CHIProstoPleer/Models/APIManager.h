//
//  APIManager.h
//  ProstoPleerApp
//
//  Created by CHI Software on 11/11/15.
//  Copyright © 2015 CHI Software. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const URL;
extern NSString * const TokenURL;

@interface APIManager : NSObject

- (NSString *)accessToken;
- (NSMutableURLRequest *)refreshToken;

- (NSMutableURLRequest *)login;
- (NSMutableURLRequest *)searchInfo;
- (NSMutableURLRequest *)trackInfo;
- (NSMutableURLRequest *)trackLyrics;
- (NSMutableURLRequest *)topSongsList;
- (NSMutableURLRequest *)tracksDownloadLink;

@end
