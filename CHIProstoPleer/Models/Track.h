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

- (instancetype)trackWithTitle:(NSString *)title
                    withArtist:(NSString *)artist
                   withTrackID:(NSString *)trackID
                  withDuration:(NSNumber *)duration
                    withTextID:(NSString *)text_id;

- (instancetype)createTrackWithTrackInfoObject:(TrackInfo *)trackInfo;

+ (instancetype)objectWithTrackID:(NSString *)trackID;

- (void)saveTrackInExternalFile:(NSData *)recievedData;

@end

NS_ASSUME_NONNULL_END

#import "Track+CoreDataProperties.h"
