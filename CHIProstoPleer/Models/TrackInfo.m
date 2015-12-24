//
//  TrackInfo.m
//  ProstoPleerApp
//
//  Created by CHI Software on 12/23/15.
//  Copyright © 2015 CHI Software. All rights reserved.
//

#import "TrackInfo.h"

@interface TrackInfo () <PPTrackInfoProtocol>

@end

@implementation TrackInfo

+ (NSArray *)trackDescription:(NSDictionary *)trackDict
{
    NSMutableArray *tracksObj = [NSMutableArray array];
    TrackInfo *track = [[TrackInfo alloc] init];

    for (NSDictionary *trackInfo in trackDict) {
        track.trackTitle    = [trackInfo objectForKey:@"track"];
        track.trackArtist   = [trackInfo objectForKey:@"artist"];
        track.ID            = [trackInfo objectForKey:@"id"];
        track.textID        = [trackInfo objectForKey:@"text_id"];
        track.trackDuration = [trackInfo objectForKey:@"bitrate"];
        
        [tracksObj addObject:track];
    }
   
    return tracksObj;
}

@end
