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
NSString * const SessionManagerAccessTokenDefaultsKey = @"SessionManagerAccessTokenDefaultsKey";

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
    
    [self dataTaskWithRequest:tokenRequest complitionHandler:^(NSDictionary *resultInfo, NSError *error) {
        
         NSString *token = [resultInfo objectForKey:@"access_token"];
        [[NSUserDefaults standardUserDefaults] setObject:token forKey:SessionManagerAccessTokenDefaultsKey];
        
        if (completion) {
            completion(token, error);
        }
    }];
}

- (void)searchInfo
{
    [self searchInfo:nil];
}

- (void)searchInfo:(void(^)(NSArray *searchInfo, NSError *error))completion
{
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:SessionManagerAccessTokenDefaultsKey];
    NSString *requestText = [NSString stringWithFormat:@"access_token=%@&method=tracks_search&query=Republic", token];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http:api.pleer.com/index.php"]];
    [request setHTTPBody:[requestText dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    
    [self dataTaskWithRequest:request complitionHandler:^(NSDictionary *resultInfo, NSError *error) {
        
        if (error) {
            return ;
        }
        
        self.trackID = [resultInfo objectForKey:@"id"];
        NSArray *searchInfo = [resultInfo allValues];
        
        if (completion) {
            completion(searchInfo, error);
        }
    }];
}

- (void)topSongsList
{
    [self topSongsList:nil];
}

- (void)topSongsList:(void(^)(NSArray *topList, NSError *error))completion
{
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:SessionManagerAccessTokenDefaultsKey];
 
    NSString *requestText = [NSString stringWithFormat:@"access_token=%@&method=get_top_list&list_type=1&language=en&page=1", token];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:SessionManagerURL]];
    [request setHTTPBody:[requestText dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];

    [self dataTaskWithRequest:request complitionHandler:^(NSDictionary *resultInfo, NSError *error) {
        
        NSDictionary *tracks = [resultInfo objectForKey:@"tracks"];
        NSDictionary *values = [tracks objectForKey:@"data"];
        NSDictionary *datas = [values objectForKey:@"13361656"];
        self.trackID = [datas objectForKey:@"id"];
        
        NSArray *topList = [values allValues];
        if (completion) {
            completion(topList, error);
        }
    }];
}

- (void)trackLyrics
{
    [self trackLyrics:nil];
}

- (void)trackLyrics:(void(^)(NSString *title, NSError *error))completion
{
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:SessionManagerAccessTokenDefaultsKey];
    NSString *requestText = [NSString stringWithFormat:@"access_token=%@&method=tracks_get_lyrics&track_id=%@", token, self.trackID];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:SessionManagerURL]];
    [request setHTTPBody:[requestText dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    
    [self dataTaskWithRequest:request complitionHandler:^(NSDictionary *resultInfo, NSError *error) {
        
       NSString *trackLyrics = [resultInfo objectForKey:@"text"];
        
        if (completion) {
            completion(trackLyrics, error);
        }
    }];
}

- (void)tracksDownloadLink
{
    [self tracksDownloadLink:nil];
}

- (void)tracksDownloadLink:(void(^)(NSString *, NSError *))completion
{
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:SessionManagerAccessTokenDefaultsKey];
    NSString *requestText = [NSString stringWithFormat:@"access_token=%@&method=tracks_get_download_link&track_id=%@&reason=save", token, self.trackID];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:SessionManagerURL]];
    [request setHTTPBody:[requestText dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    
    [self dataTaskWithRequest:request complitionHandler:^(NSDictionary *resultInfo, NSError *error) {
        
        NSString *link = [resultInfo objectForKey:@"url"];
        if (completion) {
            completion(link, error);
        }
    }];
}

- (void)dataTaskWithRequest:(NSMutableURLRequest *)request complitionHandler:(void(^)(NSDictionary *, NSError *))completion
{
    NSString *checkStr = [self.request cURLCommandString];
    NSLog(@"%@", checkStr);
    
    NSURLSessionDataTask *dataTask = [self.sessionURL dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
        NSLog(@"response %@, error %@", result, error);
        if (completion) {
            completion(result, error);
        }
    }];
    
    [dataTask resume];
}

@end
