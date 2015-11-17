//
//  PPLoginViewController.m
//  ProstoPleerApp
//
//  Created by Оксана on 15.11.15.
//  Copyright © 2015 CHI Software. All rights reserved.
//

#import "PPLoginViewController.h"
#import "SessionManager.h"

@interface PPLoginViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *login;
@property (weak, nonatomic) IBOutlet UITextField *password;

@end

@implementation PPLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor colorWithRed:<#(CGFloat)#> green:<#(CGFloat)#> blue:<#(CGFloat)#> alpha:<#(CGFloat)#>];

}

- (IBAction)signInButton:(id)sender
{
     [[SessionManager sharedInstance] sendRequestForTokenWithLogin:@"ksenya-15" andPassword:@"rewert-321" withComplitionHandler:^(NSString *token, NSError *error) {
         
         
     }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
