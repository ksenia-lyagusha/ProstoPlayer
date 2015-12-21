//
//  Track.m
//  
//
//  Created by Оксана on 21.12.15.
//
//

#import "Track.h"

@implementation Track

// Insert code here to add functionality to your managed object subclass

- (Track *)trackWithTitle:(NSString *)title withArtist:(NSString *)artist withTrackID:(NSString *)trackID withDuration:(NSNumber *)duration withTextID:(NSString *)text_id
{
    
    self.title = title;
    self.artist = artist;
    self.track_id = trackID;
    self.duration = [[NSNumberFormatter alloc] numberFromString:(NSString *)duration];
    self.text_id = ([text_id isKindOfClass:[NSNull class]]) ?  @"" : text_id;
    
    return self;
}

@end
