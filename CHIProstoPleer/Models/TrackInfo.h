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

+ ( NSArray * _Nonnull )trackDescription:( NSDictionary * _Nonnull )trackInfo;

@end
