//
//  SessionManager.m
//  ProstoPleerApp
//
//  Created by CHI Software on 11/11/15.
//  Copyright © 2015 CHI Software. All rights reserved.
//

#import "SessionManager.h"

#import "NSURLRequest+cURL.h"

NSString * const SessionManagerURL         = @"http://api.pleer.com/resource.php";
NSString * const SessionManagerTokenURL    = @"http://api.pleer.com/token.php";
NSString * const SessionManagerAccessTokenDefaultsKey = @"SessionManagerAccessTokenDefaultsKey";
NSString * const SessionManagerExpiredDatedefaultsKey = @"SessionManagerExpiredDatedefaultsKey";

@interface SessionManager ()

@property (nonatomic, strong) NSURLSession *sessionURL;
@property (nonatomic, strong) NSDate       *expiredDate;
@property (nonatomic, strong) NSString     *token;

@end

@implementation SessionManager

@synthesize token = _token;

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
                                                   delegateQueue:[NSOperationQueue mainQueue]];
    }
    return self;
}

+ (NSString *)userToken
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:SessionManagerAccessTokenDefaultsKey];
}

#pragma mark - ProstoPleer API

- (void)sendRequestForTokenWithLogin:(NSString *)login andPassword:(NSString *)password withComplitionHandler:(void(^)(NSString *token, NSError *error))completion
{
    NSMutableURLRequest *tokenRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:SessionManagerTokenURL]];
    
    NSString *requestText = [NSString stringWithFormat:@"username=%@&password=%@&grant_type=client_credentials&client_id=eYBMRN4iOdy8KYyoNCpY", login, password];
    [tokenRequest setHTTPMethod:@"POST"];
    [tokenRequest setHTTPBody:[requestText dataUsingEncoding:NSUTF8StringEncoding]];
    
    [self dataTaskWithRequest:tokenRequest complitionHandler:^(NSDictionary *resultInfo, NSError *error) {
        
        self.token = [resultInfo objectForKey:@"access_token"];
        
        [[NSUserDefaults standardUserDefaults] setObject:self.token forKey:SessionManagerAccessTokenDefaultsKey];
        
        NSDate *date = [NSDate date];
        self.expiredDate = [NSDate dateWithTimeInterval:3600 sinceDate:date];
        [[NSUserDefaults standardUserDefaults] setObject:self.expiredDate forKey:SessionManagerExpiredDatedefaultsKey];
        
        if (completion)
        {
            completion(self.token, error);
        }
    }];
}

- (void)searchInfoWithText:(NSString *)text withComplitionHandler:(void(^)(NSArray *searchInfo, NSError *error))completion
{
    [self checkTokenWithComplitionHandler:^{
        
        NSString *requestText = [NSString stringWithFormat:@"access_token=%@&method=tracks_search&query=%@", self.token, text];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http:api.pleer.com/index.php"]];
        [request setHTTPBody:[requestText dataUsingEncoding:NSUTF8StringEncoding]];
        [request setHTTPMethod:@"POST"];
        
        [self dataTaskWithRequest:request complitionHandler:^(NSDictionary *resultInfo, NSError *error) {
            
            if (error)
            {
                return ;
            }
            
            NSArray *searchInfo = [resultInfo allValues];
            
            if (completion)
            {
                completion(searchInfo, error);
            }
        }];
    }];
    
}

- (void)topSongsListForPage:(NSInteger )page withComplitionHandler:(void(^)(NSDictionary *topList, NSError *error))completion
{
    [self checkTokenWithComplitionHandler:^{
        
        NSString *requestText = [NSString stringWithFormat:@"access_token=%@&method=get_top_list&list_type=1&language=en&page=%li", self.token, page];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:SessionManagerURL]];
        [request setHTTPBody:[requestText dataUsingEncoding:NSUTF8StringEncoding]];
        [request setHTTPMethod:@"POST"];

        [self dataTaskWithRequest:request complitionHandler:^(NSDictionary *resultInfo, NSError *error) {
            
            NSDictionary *tracks = [resultInfo objectForKey:@"tracks"];
           
            if (completion)
            {
                completion(tracks, error);
            }
        }];
    }];
}

- (void)trackLyricsWithTrackID:(NSString *)trackID withComplitionHandler:(void(^)(NSString *title, NSError *error))completion
{
    [self checkTokenWithComplitionHandler:^{

        NSString *requestText = [NSString stringWithFormat:@"access_token=%@&method=tracks_get_lyrics&track_id=%@", self.token, trackID];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:SessionManagerURL]];
        [request setHTTPBody:[requestText dataUsingEncoding:NSUTF8StringEncoding]];
        [request setHTTPMethod:@"POST"];
        
        [self dataTaskWithRequest:request complitionHandler:^(NSDictionary *resultInfo, NSError *error) {
            
           NSString *trackLyrics = [resultInfo objectForKey:@"text"];
            
            if (completion) {
                completion(trackLyrics, error);
            }
        }];
    }];
}

- (void)tracksDownloadLinkWithTrackID:(NSString *)trackID withComplitionHandler:(void(^)(NSString *, NSError *))completion
{
    [self checkTokenWithComplitionHandler:^{

        NSString *requestText = [NSString stringWithFormat:@"access_token=%@&method=tracks_get_download_link&track_id=%@&reason=save", self.token, trackID];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:SessionManagerURL]];
        [request setHTTPBody:[requestText dataUsingEncoding:NSUTF8StringEncoding]];
        [request setHTTPMethod:@"POST"];
        
        [self dataTaskWithRequest:request complitionHandler:^(NSDictionary *resultInfo, NSError *error) {
            
            NSString *link = [resultInfo objectForKey:@"url"];
            if (completion) {
                completion(link, error);
            }
        }];
    }];
}

#pragma mark - Private methods

- (void)dataTaskWithRequest:(NSMutableURLRequest *)request complitionHandler:(void(^)(NSDictionary *, NSError *))completion
{
    NSURLSessionDataTask *dataTask = [self.sessionURL dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
        NSLog(@"response %@, error %@", result, error);
        if (completion) {
            completion(result, error);
        }
    }];
    
    [dataTask resume];
}


- (void)checkTokenWithComplitionHandler:(void(^)(void))completion
{
    BOOL isTokenValid = [self isTokenValid];
    
    if (isTokenValid)
    {
        if (completion)
        {
            completion();
        }
    }
    else
    {
        [self refreshTokenWithComplitionHandler:^(NSString *token, NSError *error) {
            
            [[NSUserDefaults standardUserDefaults] setObject:token forKey:SessionManagerAccessTokenDefaultsKey];
            
            NSDate *date = [NSDate date];
            self.expiredDate = [NSDate dateWithTimeInterval:3600 sinceDate:date];
            [[NSUserDefaults standardUserDefaults] setObject:self.expiredDate forKey:SessionManagerExpiredDatedefaultsKey];
            
            if (completion)
            {
                completion();
            }
        }];
    }
}

- (BOOL)isTokenValid
{
   return [self.expiredDate compare:[NSDate date]] == NSOrderedDescending;
}

- (void)refreshTokenWithComplitionHandler:(void(^)(NSString *token, NSError *error))completion
{
    NSMutableURLRequest *tokenRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:SessionManagerTokenURL]];
    
    NSString *requestText = [NSString stringWithFormat:@"refresh_token=%@&grant_type=client_credentials&client_id=eYBMRN4iOdy8KYyoNCpY", self.token];
    [tokenRequest setHTTPMethod:@"POST"];
    [tokenRequest setHTTPBody:[requestText dataUsingEncoding:NSUTF8StringEncoding]];
    
    [self dataTaskWithRequest:tokenRequest complitionHandler:^(NSDictionary *resultInfo, NSError *error) {
        
        self.token = [resultInfo objectForKey:@"access_token"];
        
        if (completion)
        {
            completion(self.token, error);
        }
    }];
}

#pragma mark - Getters and Setters

- (NSDate *)expiredDate
{
    if (_expiredDate)
    {
        return _expiredDate;
    }
    
    _expiredDate = [[NSUserDefaults standardUserDefaults] objectForKey:SessionManagerExpiredDatedefaultsKey];

    NSLog(@"expired date %@", _expiredDate);
    
    return _expiredDate;
}

-(NSString *)token
{
    if (_token) {
        return _token;
    }
    _token = [[NSUserDefaults standardUserDefaults] objectForKey:SessionManagerAccessTokenDefaultsKey];
    return _token;
}

@end