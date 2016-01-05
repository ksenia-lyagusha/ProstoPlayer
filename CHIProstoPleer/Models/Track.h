//
//  Track.h
//  
//
//  Created by CHI Software on 12/28/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "TrackInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface Track : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

- (instancetype)createTrackWithTrackInfoObject:(TrackInfo *)trackInfo;

+ (instancetype)objectWithTrackID:(NSString *)trackID;

- (void)saveTrackInExternalFileWithLocation:(NSString *)location;

+ (Track *)addNewTrack;

@end

NS_ASSUME_NONNULL_END

#import "Track+CoreDataProperties.h"
