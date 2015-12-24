//
//  TrackInfo.h
//  ProstoPleerApp
//
//  Created by CHI Software on 12/23/15.
//  Copyright © 2015 CHI Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProstoPleerProtocols.h"

@interface TrackInfo : NSObject 

@property (nonatomic, strong) NSString *trackTitle;
@property (nonatomic, strong) NSString *trackArtist;
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *textID;
@property (nonatomic, strong) NSNumber *trackDuration;

+ (NSArray *)trackDescription:(NSDictionary *)trackInfo;

@end
