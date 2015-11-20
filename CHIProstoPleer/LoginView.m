//
//  LoginView.m
//  ProstoPleerApp
//
//  Created by Оксана on 18.11.15.
//  Copyright © 2015 CHI Software. All rights reserved.
//

#import "LoginView.h"

@interface LoginView () <UITextFieldDelegate>
@property (nonatomic, strong, readwrite) UITextField *loginTextField;
@property (nonatomic, strong, readwrite) UITextField *passwordTextField;

@end

@implementation LoginView

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        UIButton *signInButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
        [signInButton setTitle:@"Sign in" forState:UIControlStateNormal];
        signInButton.translatesAutoresizingMaskIntoConstraints = NO;
        [signInButton setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
        [signInButton addTarget:self action:@selector(signInAction:) forControlEvents:UIControlEventTouchUpInside];
        
        self.loginTextField = [[UITextField alloc] init];
        self.loginTextField.placeholder = @"Login";
        self.loginTextField.translatesAutoresizingMaskIntoConstraints = NO;
        self.loginTextField.borderStyle = UITextBorderStyleRoundedRect;
        self.loginTextField.delegate = self;
        
        self.passwordTextField = [[UITextField alloc] init];
        self.passwordTextField.placeholder = @"Password";
        self.passwordTextField.secureTextEntry = YES;
        self.passwordTextField.translatesAutoresizingMaskIntoConstraints = NO;
        self.passwordTextField.borderStyle = UITextBorderStyleRoundedRect;
        self.passwordTextField.delegate = self;
        
        [self addSubview:self.loginTextField];
        [self addSubview:self.passwordTextField];
        [self addSubview:signInButton];
        
        
        NSDictionary *views = NSDictionaryOfVariableBindings(signInButton, _loginTextField, _passwordTextField);
        NSDictionary *metrics = @{@"sideSpacing" : @30.0, @"verticalSpacing" : @20.0};
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-sideSpacing-[_loginTextField]-sideSpacing-|"
                                                                          options:0
                                                                          metrics:metrics
                                                                            views:views]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-sideSpacing-[_passwordTextField]-sideSpacing-|"
                                                                          options:0
                                                                          metrics:metrics
                                                                            views:views]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-sideSpacing-[signInButton]-sideSpacing-|"
                                                                          options:0
                                                                          metrics:metrics
                                                                            views:views]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-110.0-[_loginTextField]-verticalSpacing-[_passwordTextField]-verticalSpacing-[signInButton]"
                                                                          options:0
                                                                          metrics:metrics
                                                                            views:views]];
        
    }
    return self;
}

- (IBAction)signInAction:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(signInAction:)])
    {
        [self.delegate signInAction:self];
    }
}

#pragma mark - UITextFieldDelegate

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
