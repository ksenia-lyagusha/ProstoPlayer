//
//  ProstoPleerProtocols.h
//  ProstoPleerApp
//
//  Created by CHI Software on 12/24/15.
//  Copyright © 2015 CHI Software. All rights reserved.
//

#ifndef ProstoPleerProtocols_h
#define ProstoPleerProtocols_h


@protocol PPTrackInfoProtocol <NSObject>

@property (nullable, nonatomic) NSString *artist;
@property (nullable, nonatomic) NSNumber *duration;
@property (nullable, nonatomic) NSString *text_id;
@property (nullable, nonatomic) NSString *title;
@property (nullable, nonatomic) NSString *track_id;

@end

@protocol PPTopSongsListViewControllerDelegate  <NSObject>

typedef NS_ENUM (NSUInteger, PPTrackDirection) {
    PPTrackDirectionFastForward,
    PPTrackDirectionFastRewind
};
- (_Nonnull id <PPTrackInfoProtocol>) topSongsList:(PPTrackDirection)direction;

@end

#endif /* ProstoPleerProtocols_h */
