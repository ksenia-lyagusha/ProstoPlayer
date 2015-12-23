//
//  Track.h
//  
//
//  Created by Оксана on 21.12.15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface Track : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

- (instancetype)trackWithTitle:(NSString *)title
                    withArtist:(NSString *)artist
                   withTrackID:(NSString *)trackID
                  withDuration:(NSNumber *)duration
                    withTextID:(NSString *)text_id;

+ (instancetype)objectWithTrackID:(NSString *)trackID;

@end

NS_ASSUME_NONNULL_END

#import "Track+CoreDataProperties.h"
