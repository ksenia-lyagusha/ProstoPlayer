//
//  User+CoreDataProperties.h
//  ProstoPleerApp
//
//  Created by CHI Software on 12/30/15.
//  Copyright © 2015 CHI Software. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface User (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *login;
@property (nullable, nonatomic, retain) NSSet<Track *> *tracks;

@end

@interface User (CoreDataGeneratedAccessors)

- (void)addTracksObject:(Track *)value;
- (void)removeTracksObject:(Track *)value;
- (void)addTracks:(NSSet<Track *> *)values;
- (void)removeTracks:(NSSet<Track *> *)values;

@end

NS_ASSUME_NONNULL_END
