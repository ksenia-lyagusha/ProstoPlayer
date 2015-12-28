//
//  TrackInfo.h
//  ProstoPleerApp
//
//  Created by CHI Software on 12/23/15.
//  Copyright © 2015 CHI Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProstoPleerProtocols.h"

@interface TrackInfo : NSObject <PPTrackInfoProtocol>

@property (nullable, nonatomic) NSString *artist;
@property (nullable, nonatomic) NSNumber *duration;
@property (nullable, nonatomic) NSString *text_id;
@property (nullable, nonatomic) NSString *title;
@property (nullable, nonatomic) NSString *track_id;

+ ( NSArray * _Nonnull )trackDescription:( NSDictionary * _Nonnull )trackInfo;

@end
