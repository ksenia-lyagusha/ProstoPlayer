//
//  User.h
//  ProstoPleerApp
//
//  Created by CHI Software on 12/29/15.
//  Copyright © 2015 CHI Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Track;

NS_ASSUME_NONNULL_BEGIN

@interface User : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

+ (instancetype)objectWithLogin:(NSString *)login withMOC:(NSManagedObjectContext *)moc;
+ (User *)addNewUser;

@end

NS_ASSUME_NONNULL_END

#import "User+CoreDataProperties.h"
