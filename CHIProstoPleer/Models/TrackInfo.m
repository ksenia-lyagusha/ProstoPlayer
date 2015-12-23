//
//  TrackInfo.m
//  ProstoPleerApp
//
//  Created by CHI Software on 12/23/15.
//  Copyright © 2015 CHI Software. All rights reserved.
//

#import "TrackInfo.h"

@interface TrackInfo ()

@property (nonatomic, strong) NSString *trackTitle;
@property (nonatomic, strong) NSString *trackArtist;
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *textID;
@property (nonatomic, strong)NSNumber *trackDuratio;

@end

@implementation TrackInfo

- (instancetype)trackWithTitle:(NSString *)title withArtist:(NSString *)artist withTrackID:(NSString *)trackID withDuration:(NSNumber *)duration withTextID:(NSString *)text_id
{
    TrackInfo *trackInfo = [[TrackInfo alloc] init];
    
    self.trackTitle = title;
    self.trackArtist = artist;
    self.ID = trackID;
    self.textID = text_id;
    self.trackDuratio = duration;
    
    return trackInfo;
}

@end
