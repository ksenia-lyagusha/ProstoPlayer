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

- (instancetype)addUserWithLogin:(NSString *)login
{
    self.login = login;
    return self;
}

@end
