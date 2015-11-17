//
//  PPLoginViewController.m
//  ProstoPleerApp
//
//  Created by Оксана on 15.11.15.
//  Copyright © 2015 CHI Software. All rights reserved.
//

#import "PPLoginViewController.h"
#import "SessionManager.h"

@interface PPLoginViewController ()

@end

@implementation PPLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (IBAction)signInButton:(id)sender
{
     [[SessionManager sharedInstance] sendRequestForTokenWithLogin:@"ksenya-15" andPassword:@"rewert-321" withComplitionHandler:^(NSString *token, NSError *error) {
         
         
     }];
    
}

@end
