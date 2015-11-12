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

@property (nonatomic, strong) NSString *token;

@end

@implementation SessionManager

+ (instancetype)sharedInstance
{
    static SessionManager *sharedInstance;
    static dispatch_once_t once_t;
    dispatch_once(&once_t, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)sendRequestForToken
{
    NSURLSession *sessionURL = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                      delegate:self
                                                 delegateQueue:[NSOperationQueue currentQueue]];
    
    NSURLSessionDataTask *dataTask = [sessionURL dataTaskWithURL:[NSURL URLWithString:TokenURL]];
    
    NSString *token = [NSString stringWithFormat:@"username=ksenya-15&password=rewert-321&grant_type=client_credentials&client_id=eYBMRN4iOdy8KYyoNCpY"];
    NSMutableURLRequest *tokenRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:TokenURL]];
    
    [tokenRequest setHTTPMethod:@"POST"];
    [tokenRequest setHTTPBody:[token dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *checkStr = [tokenRequest cURLCommandString];
    NSLog(@"%@",checkStr);
    
    dataTask = [sessionURL dataTaskWithRequest:tokenRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSString *dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"response %@", dataStr);
        
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
        self.token = [result objectForKey:@"access_token"];
    }];
    
    [dataTask resume];
}

- (NSString *)searchInfo
{
    NSURLSession *sessionURL = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                             delegate:self
                                                        delegateQueue:[NSOperationQueue currentQueue]];
    NSURLSessionDataTask *dataTask = [sessionURL dataTaskWithURL:[NSURL URLWithString:URL]];
    
    NSString *requestText = [NSString stringWithFormat:@"access_token=%@&method=tracks_search&query=One Republic", self.token];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:URL]];

    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[requestText dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *checkStr = [request cURLCommandString];
    NSLog(@"%@", checkStr);
    
    __block NSString *searchResult;
    dataTask = [sessionURL dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        NSString *dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"response %@", dataStr);
        searchResult = [result objectForKey:@""];
    }];
    
    [dataTask resume];
    return searchResult;
}

@end
