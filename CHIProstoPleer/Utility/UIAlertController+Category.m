//
//  UIAlertController+Category.m
//  ProstoPleerApp
//
//  Created by Оксана on 18.11.15.
//  Copyright © 2015 CHI Software. All rights reserved.
//

#import "UIAlertController+Category.h"

@implementation UIAlertController (Category)

+ (instancetype)createAlertWithMessage:(NSString *)message
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"CHIPleer", nil) message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:okAction];
    
    return alert;
}

//- (instancetype)createAlertWithMessage:(NSString *)message withComplitionHandler:(void (^ __nullable)(UIAlertAction *action))handler
//{
//    [self cre]
//}

@end
