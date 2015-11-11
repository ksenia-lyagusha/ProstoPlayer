//
//  APIManager.m
//  ProstoPleerApp
//
//  Created by CHI Software on 11/11/15.
//  Copyright © 2015 CHI Software. All rights reserved.
//

#import "APIManager.h"

NSString * const URL = @"http://api.pleer.com/resource.php";

@interface APIManager ()

@property (nonatomic, strong) NSMutableURLRequest *dataRequest;
@property (nonatomic, strong) NSString *token;
@end

@implementation APIManager

+ (instancetype)sharedInstance
{
    static APIManager *sharedInstance;
    static dispatch_once_t once_t;
    dispatch_once(&once_t, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.dataRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:URL]];
    }
    return self;
}

- (NSURLRequest *)accessToken
{
    NSString *myRequest = [NSString stringWithFormat:@"login=ksenya-15&password=rewert-321&http://api.pleer.com/token.php&grant_type=client_credentials"];
    [self.dataRequest setHTTPBody:[myRequest dataUsingEncoding:NSUTF8StringEncoding]];
    
    return self.dataRequest;
}

- (NSURLRequest *)refreshToken
{
    return self.dataRequest;
}

- (NSURLRequest *)login
{
    NSString *myRequest = [NSString stringWithFormat:@"login=ksenya-15&password=rewert-321&client_id=eYBMRN4iOdy8KYyoNCpY&grant_type=client_credentials"];
    [self.dataRequest setHTTPBody:[myRequest dataUsingEncoding:NSUTF8StringEncoding]];
    
    return self.dataRequest;
}

- (NSURLRequest *)searchInfo
{
//    query (string, обязательный) — строка поиска. Поддерживает синтаксис ПростоПлеера (artist: track: и т. п.)
//    page (int, необязательный, по умолчанию 1) — номер страницы
//    result_on_page (int, необязательный, по умолчанию 10) - число результатов на странице
//    quality (string, необязательный) - качество, по умолчанию all , возможны варианты all, bad, good, best
    
//    http://api.pleer.com/index.php -d 'access_token=82a9e6125a57199475be066f9f229633296322c8&method=tracks_search&query=aha'
    
    NSString *myRequest = [NSString stringWithFormat:@"URL access_token=&method=tracks_search&query=One Republic"];
    [self.dataRequest setHTTPBody:[myRequest dataUsingEncoding:NSUTF8StringEncoding]];
    return self.dataRequest;
}

- (NSURLRequest *)trackInfo
{
//    track_id (string, обязательный) идентификатор трека
    NSString *myRequest = [NSString stringWithFormat:@"query="];
    [self.dataRequest setHTTPBody:[myRequest dataUsingEncoding:NSUTF8StringEncoding]];
    
    return self.dataRequest;
}

- (NSURLRequest *)trackLyrics
{
//    track_id (string, обязательный) идентификатор трека
    NSString *myRequest = [NSString stringWithFormat:@"query="];
    [self.dataRequest setHTTPBody:[myRequest dataUsingEncoding:NSUTF8StringEncoding]];
    
    return self.dataRequest;
}
- (NSURLRequest *)topSongsList
{
//    list_type (int, обязательный) тип списка, 1- неделя, 2 - месяц, 3 - 3 месяца, 4 - полгода, 5 - год
//    page (int) — текущая страница.
//    language (string) — тип топа en - иностранный, ru - русский.
    NSString *myRequest = [NSString stringWithFormat:@"query="];
    [self.dataRequest setHTTPBody:[myRequest dataUsingEncoding:NSUTF8StringEncoding]];
    
    return self.dataRequest;
}

- (NSURLRequest *)tracksDownloadLink
{
//    track_id (string, обязательный) идентификатор трека
//    reason (string, обязательный) цель обращения. Должна быть равна listen (загрузка для прослушивания) или save (загрузка для сохранения)
    
    NSString *myRequest = [NSString stringWithFormat:@"query="];
    [self.dataRequest setHTTPBody:[myRequest dataUsingEncoding:NSUTF8StringEncoding]];
   
    return self.dataRequest;
}

@end
