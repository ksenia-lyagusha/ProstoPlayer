//
//  SessionManager.m
//  ProstoPleerApp
//
//  Created by CHI Software on 11/11/15.
//  Copyright © 2015 CHI Software. All rights reserved.
//

#import "SessionManager.h"
#import "APIManager.h"
#import "NSURLRequest+cURL.h"

@interface SessionManager ()

//@property (copy) void (^blockProperty)(NSDictionary *);
@property (nonatomic, strong) NSMutableData *receivedData;
@end
@implementation SessionManager

- (void)sendRequest
{
    NSURLSession *sessionURL = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                      delegate:self
                                                 delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask *dataTask = [sessionURL dataTaskWithURL:[NSURL URLWithString:URL]];
    
    NSURLRequest *dataRequest = [[APIManager sharedInstance] accessToken];
    NSString *str = [dataRequest cURLCommandString];
    NSLog(@"%@",str);
    
    [sessionURL dataTaskWithRequest:dataRequest];
    [dataTask resume];
    
    self.receivedData = [NSMutableData data];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler
{
    NSLog(@"response from server is -- %@", response);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data
{
    [self.receivedData appendData:data];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)errorURLSession
{
    if (errorURLSession) {
        NSLog(@"%@", errorURLSession.description);
    }
}

@end
