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

NSString * const SessionManagerURL         = @"http://api.pleer.com/resource.php";
NSString * const SessionManagerTokenURL    = @"http://api.pleer.com/token.php";
NSString * const SessionManagerAccessToken = @"username=ksenya-15&password=rewert-321&grant_type=client_credentials&client_id=eYBMRN4iOdy8KYyoNCpY";

@interface SessionManager ()


@property (nonatomic, strong) NSURLSession *sessionURL;
@property (nonatomic, strong) NSString *trackID;
@property (nonatomic, strong) NSMutableURLRequest *request;

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

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.sessionURL = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                                 delegate:nil
                                                            delegateQueue:[[NSOperationQueue alloc] init]];
        self.request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:SessionManagerURL]];
        
        [self.request setHTTPMethod:@"POST"];
    }
    return self;
}

#pragma mark - ProstoPleer API

- (void)sendRequestForToken
{
    [self sendRequestForToken:nil];
}

- (void)sendRequestForToken:(void(^)(NSString *token, NSError *error))completion
{
    NSMutableURLRequest *tokenRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:SessionManagerTokenURL]];
    
    [tokenRequest setHTTPMethod:@"POST"];
    [tokenRequest setHTTPBody:[SessionManagerAccessToken dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *checkStr = [tokenRequest cURLCommandString];
    NSLog(@"%@",checkStr);
    
    __block NSString *blockToken;
    NSURLSessionDataTask *dataTask = [self.sessionURL dataTaskWithRequest:tokenRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSString *dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"response %@", dataStr);
        
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
        blockToken = [result objectForKey:@"access_token"];
        [[NSUserDefaults standardUserDefaults] setObject:blockToken forKey:@"TOKEN"];
        
        if (completion) {
            completion(blockToken, error);
        }
    }];
    
    [dataTask resume];
}

- (void)searchInfo
{
    [self searchInfo:nil];
}

- (void)searchInfo:(void(^)(NSString *trackID, NSError *error))completion
{
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"TOKEN"];
    NSString *requestText = [NSString stringWithFormat:@"access_token=%@&method=tracks_search&query=Republic", token];
  
    [self.request setHTTPBody:[requestText dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *checkStr = [self.request cURLCommandString];
    NSLog(@"%@", checkStr);
    
    NSURLSessionDataTask *dataTask = [self.sessionURL dataTaskWithRequest:self.request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        NSString *dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"response %@, error %@", dataStr, error);
        self.trackID = [result objectForKey:@"id"];
        
        if (completion) {
            completion(self.trackID, error);
        }
    }];
    
    [dataTask resume];
}

- (void)topSongsList
{
    [self topSongsList:nil];
}

- (void)topSongsList:(void(^)(NSString *title, NSError *error))completion
{
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"TOKEN"];
 
    NSString *requestText = [NSString stringWithFormat:@"access_token=%@&method=get_top_list&list_type=1&language=en&page=1", token];

    [self.request setHTTPBody:[requestText dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *checkStr = [self.request cURLCommandString];
    NSLog(@"%@", checkStr);
    
    __block NSString *searchResult;

    NSURLSessionDataTask *dataTask = [self.sessionURL dataTaskWithRequest:self.request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        NSString *dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"response %@, error %@", dataStr, error);
        NSDictionary *tracks = [result objectForKey:@"tracks"];
        NSDictionary *values = [tracks objectForKey:@"data"];
        NSDictionary *datas = [values objectForKey:@"13361656"];
        self.trackID = [datas objectForKey:@"id"];
//        self.trackID = [value4 objectForKey:@"id"];
        
        if (completion) {
            completion(searchResult, error);
        }
    }];
    
    [dataTask resume];
}

- (void)trackLyrics
{
    [self trackLyrics:nil];
}

- (void)trackLyrics:(void(^)(NSString *title, NSError *error))completion
{
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"TOKEN"];
    NSString *requestText = [NSString stringWithFormat:@"access_token=%@&method=tracks_get_lyrics&track_id=%@", token, self.trackID];
    
    [self.request setHTTPBody:[requestText dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *checkStr = [self.request cURLCommandString];
    NSLog(@"%@", checkStr);
    
    __block NSString *searchResult;
    
    NSURLSessionDataTask *dataTask = [self.sessionURL dataTaskWithRequest:self.request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        NSString *dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"response %@, error %@", dataStr, error);
        searchResult = [result objectForKey:@"plain text"];
        
        if (completion) {
            completion(searchResult, error);
        }
    }];
    
    [dataTask resume];
}

- (void)tracksDownloadLink
{
    [self tracksDownloadLink:nil];
}

- (void)tracksDownloadLink:(void(^)(NSString *token, NSError *error))completion
{
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"TOKEN"];
    NSString *requestText = [NSString stringWithFormat:@"access_token=%@&method=tracks_get_download_link&track_id=%@&reason=save", token, self.trackID];
    
    [self.request setHTTPBody:[requestText dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionDataTask *dataTask = [self dataTaskWithRequest:@"URL"];
        
//        if (completion) {
//            completion(searchResult, error);
//        }
    
    [dataTask resume];
}

- (NSURLSessionDataTask *)dataTaskWithRequest:(NSString *)key
{
    NSString *checkStr = [self.request cURLCommandString];
    NSLog(@"%@", checkStr);
    
    __block NSString *searchResult;
    NSURLSessionDataTask *dataTask = [self.sessionURL dataTaskWithRequest:self.request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        NSString *dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"response %@, error %@", dataStr, error);
        searchResult = [result objectForKey:key];
        
//        if (completion) {
//            completion(searchResult, error);
//        }
    }];
    
    return dataTask;
}

@end
