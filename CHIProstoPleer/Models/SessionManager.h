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
- (void)sendRequestForToken;
- (NSString *)searchInfo;
@end
