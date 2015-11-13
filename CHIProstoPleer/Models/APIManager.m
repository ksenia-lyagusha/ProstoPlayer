//
//  APIManager.m
//  ProstoPleerApp
//
//  Created by CHI Software on 11/11/15.
//  Copyright © 2015 CHI Software. All rights reserved.
//

#import "APIManager.h"

@interface APIManager ()

@property (nonatomic, strong) NSMutableURLRequest *dataRequest;
@property (nonatomic, strong) NSString *token;
@end

@implementation APIManager

- (NSMutableURLRequest *)refreshToken
{
    return self.dataRequest;
}

- (NSMutableURLRequest *)tracksDownloadLink
{
//    track_id (string, обязательный) идентификатор трека
//    reason (string, обязательный) цель обращения. Должна быть равна listen (загрузка для прослушивания) или save (загрузка для сохранения)
    
    NSString *myRequest = [NSString stringWithFormat:@"query="];
    [self.dataRequest setHTTPBody:[myRequest dataUsingEncoding:NSUTF8StringEncoding]];
   
    return self.dataRequest;
}

@end
