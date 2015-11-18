//
//  PPLoginViewController.m
//  ProstoPleerApp
//
//  Created by Оксана on 15.11.15.
//  Copyright © 2015 CHI Software. All rights reserved.
//

#import "PPLoginViewController.h"
#import "SessionManager.h"
#import "ViewController.h"

@interface PPLoginViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *loginTextField;
@property (nonatomic, strong) UITextField *passwordTextField;

@end

@implementation PPLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"CHIProstoPleer";
    self.view.backgroundColor = [UIColor colorWithRed:166/255.0 green:239/255.0 blue:42/255.0 alpha:1];
    
    UIButton *signInButton = [[UIButton alloc] init];
    [signInButton setTitle:@"Sign in" forState:UIControlStateNormal];
    signInButton.translatesAutoresizingMaskIntoConstraints = NO;
    [signInButton setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    [signInButton addTarget:self action:@selector(signInAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.loginTextField = [[UITextField alloc] init];
    self.loginTextField.placeholder = @"Login";
    self.loginTextField.translatesAutoresizingMaskIntoConstraints = NO;
    self.loginTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.loginTextField.delegate = self;
    self.loginTextField.tintColor = [UIColor blackColor];

    self.passwordTextField = [[UITextField alloc] init];
    self.passwordTextField.placeholder = @"Password";
    self.passwordTextField.secureTextEntry = YES;
    self.passwordTextField.translatesAutoresizingMaskIntoConstraints = NO;
    self.passwordTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.passwordTextField.delegate = self;
    self.passwordTextField.tintColor = [UIColor blackColor];
    
    [self.view addSubview:signInButton];
    [self.view addSubview:self.loginTextField];
    [self.view addSubview:self.passwordTextField];
    
    
    NSDictionary *views = NSDictionaryOfVariableBindings(signInButton, _loginTextField, _passwordTextField);
    NSDictionary *metrics = @{@"sideSpacing" : @30.0, @"verticalSpacing" : @20.0};
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-sideSpacing-[_loginTextField]-sideSpacing-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-sideSpacing-[_passwordTextField]-sideSpacing-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-sideSpacing-[signInButton]-sideSpacing-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-110.0-[_loginTextField]-verticalSpacing-[_passwordTextField]-verticalSpacing-[signInButton]"
                                                                     options:0
                                                                     metrics:metrics
                                                                       views:views]];


}

- (IBAction)signInAction:(id)sender
{
    if ([self.loginTextField.text isEqualToString:@""] || [self.passwordTextField.text isEqualToString:@""])
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"CHIPleer", nil) message:NSLocalizedString(@"IncorrectInput", nil) preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleCancel handler:nil];
        
        [alert addAction:okAction];
        
        [self presentViewController:alert animated:YES completion:nil];
        
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    [[SessionManager sharedInstance] sendRequestForTokenWithLogin:self.loginTextField.text andPassword:self.passwordTextField.text withComplitionHandler:^(NSString *token, NSError *error) {
        
        if (token) {
            ViewController *viewController = [[ViewController alloc] init];
            [weakSelf.navigationController pushViewController:viewController animated:YES];
        }
        else
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"CHIPleer", nil) message:NSLocalizedString(@"InvalidData", nil) preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleCancel handler:nil];
            
            [alert addAction:okAction];
            
            [weakSelf presentViewController:alert animated:YES completion:nil];
        }
        
    }];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isEqual:self.loginTextField]) {
        [self.passwordTextField becomeFirstResponder];
        return NO;
    }
    
    [textField resignFirstResponder];
    return YES;
}

@end
