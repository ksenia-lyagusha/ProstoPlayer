//
//  CoreDataManager.h
//  ProstoPleerApp
//
//  Created by CHI Software on 12/21/15.
//  Copyright © 2015 CHI Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "Track.h"

@interface CoreDataManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext       *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel         *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
+ (instancetype)sharedInstanceCoreData;
- (NSArray *)fetchTrackObjects;
- (NSArray *)fetchObjectsForUserWithLogin:(NSString *)login;
- (void)saveWithLocation:(NSString *)location andTrackInfo:(id <PPTrackInfoProtocol>)info;

- (NSString *)currentUserLogin;
- (void)setCurrentUserLogin:(NSString *)login;

@end
