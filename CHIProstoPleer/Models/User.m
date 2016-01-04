//
//  User.m
//  ProstoPleerApp
//
//  Created by CHI Software on 12/29/15.
//  Copyright © 2015 CHI Software. All rights reserved.
//

#import "User.h"
#import "Track.h"
#import "CoreDataManager.h"

@implementation User

// Insert code here to add functionality to your managed object subclass

+ (instancetype)objectWithLogin:(NSString *)login
{
    User *user;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"User"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"login == %@", login];
    [fetchRequest setPredicate:predicate];

    NSArray *filtered = [[[CoreDataManager sharedInstanceCoreData] managedObjectContext] executeFetchRequest:fetchRequest error:nil];
    
    if (filtered.count > 0) {
        user = [filtered firstObject];
    }
    
    return user;
}
@end
