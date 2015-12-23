//
//  TrackInfo.h
//  ProstoPleerApp
//
//  Created by CHI Software on 12/23/15.
//  Copyright © 2015 CHI Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TrackInfoProtocol <NSObject>

- (id <TrackInfoProtocol>)trackDescription;

@end
@interface TrackInfo : NSObject

- (instancetype)trackWithTitle:(NSString *)title withArtist:(NSString *)artist withTrackID:(NSString *)trackID withDuration:(NSNumber *)duration withTextID:(NSString *)text_id;

@end
