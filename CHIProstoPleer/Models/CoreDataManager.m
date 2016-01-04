//
//  CoreDataManager.m
//  ProstoPleerApp
//
//  Created by CHI Software on 12/21/15.
//  Copyright © 2015 CHI Software. All rights reserved.
//

#import "CoreDataManager.h"

NSString * const kCurrentUser = @"currentUser";

@implementation CoreDataManager

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

+ (instancetype)sharedInstanceCoreData
{
    static CoreDataManager *sharedInstance;
    static dispatch_once_t once_t;
    dispatch_once(&once_t, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "CHI.ProstoPleerApp" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"ProstoPleerApp" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"ProstoPleerApp.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (NSArray *)fetchTrackObjects
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Track" inManagedObjectContext:[[CoreDataManager sharedInstanceCoreData] managedObjectContext]];
    [fetchRequest setEntity:entity];
    NSError *error = nil;
    NSArray *result = [[[CoreDataManager sharedInstanceCoreData] managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    if (error)
    {
        NSLog(@"Unable to execute fetch request.");
        NSLog(@"%@, %@", error, error.localizedDescription);
        
    } else
    {
        NSLog(@"%@", result);
    }
    return result;
}

- (NSArray *)fetchObjectsForUserWithLogin:(NSString *)login
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"User"];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"login == %@", login];
    [fetchRequest setPredicate:predicate];

    NSError *error = nil;
    NSArray *result = [[[CoreDataManager sharedInstanceCoreData] managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    if (error)
    {
        NSLog(@"Unable to execute fetch request.");
        NSLog(@"%@, %@", error, error.localizedDescription);
        
    } else
    {
        NSLog(@"%@", result);
    }
    return result;
}

- (Track *)addNewTrack
{
    Track *track = [NSEntityDescription insertNewObjectForEntityForName:@"Track" inManagedObjectContext:[[CoreDataManager sharedInstanceCoreData] managedObjectContext]];
    
    return track;
}

- (User *)addNewUser
{
    User *user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:[[CoreDataManager sharedInstanceCoreData] managedObjectContext]];
    return user;
}

#pragma mark - Current user's login

- (NSString *)currentUserLogin
{
    NSString *login = [[NSUserDefaults standardUserDefaults] objectForKey:kCurrentUser];
    return login;
}

- (void)setCurrentUserLogin:(NSString *)login
{
    [[NSUserDefaults standardUserDefaults] setObject:login forKey:kCurrentUser];
}

@end
