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
    [[SessionManager sharedInstance] sendRequestForToken];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}
@end
