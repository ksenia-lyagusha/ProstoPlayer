//
//  Track+CoreDataProperties.h
//  
//
//  Created by CHI Software on 12/28/15.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Track.h"

NS_ASSUME_NONNULL_BEGIN

@interface Track (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *artist;
@property (nullable, nonatomic, retain) NSNumber *duration;
@property (nullable, nonatomic, retain) NSString *text_id;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *track_id;
@property (nullable, nonatomic, retain) NSData   *download;

@end

NS_ASSUME_NONNULL_END
