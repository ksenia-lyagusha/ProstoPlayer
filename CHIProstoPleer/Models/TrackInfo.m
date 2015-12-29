//
//  TrackInfo.m
//  ProstoPleerApp
//
//  Created by CHI Software on 12/23/15.
//  Copyright © 2015 CHI Software. All rights reserved.
//

#import "TrackInfo.h"

@implementation TrackInfo

@synthesize artist = _artist;
@synthesize duration = _duration;
@synthesize text_id = _text_id;
@synthesize title = _title;
@synthesize track_id = _track_id;

+ (NSArray *)trackDescription:(NSDictionary *)trackDict
{
    NSMutableArray *tracksObj = [NSMutableArray array];
        
    for (NSDictionary *trackInfo in [trackDict allValues]) {
        TrackInfo *track = [[TrackInfo alloc] init];
        track.title    = [trackInfo objectForKey:@"track"];
        track.artist   = [trackInfo objectForKey:@"artist"];
        track.track_id = [trackInfo objectForKey:@"id"];
        track.text_id  = [trackInfo objectForKey:@"text_id"];
        track.duration = [trackInfo objectForKey:@"bitrate"];
        
        [tracksObj addObject:track];
    }
   
    return tracksObj;
}

@end
