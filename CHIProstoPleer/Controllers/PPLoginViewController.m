//
//  PPLoginViewController.m
//  ProstoPleerApp
//
//  Created by Оксана on 15.11.15.
//  Copyright © 2015 CHI Software. All rights reserved.
//

#import "PPLoginViewController.h"
#import "MainViewController.h"
#import "PPTopSongsListViewController.h"
#import "FavoriteViewController.h"
#import "LoginView.h"

#import "SessionManager.h"
#import "UIAlertController+Category.h"

@interface PPLoginViewController () <PPLoginViewDelegate>

@end

@implementation PPLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"CHIProstoPleer";
    self.view.backgroundColor = [UIColor colorWithRed:166/255.0 green:239/255.0 blue:42/255.0 alpha:1];
    
    LoginView *view = [[LoginView alloc] init];
    [self.view addSubview:view];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    view.delegate = self;
    
    NSDictionary *views = NSDictionaryOfVariableBindings(view);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-0-[view]-0-|"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[view]-320-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
}

#pragma mark - PPLoginViewDelegate

- (void)signInAction:(LoginView *)view
{
    if ([view.loginTextField.text isEqualToString:@""] || [view.passwordTextField.text isEqualToString:@""])
    {
        UIAlertController *alert = [UIAlertController createAlertWithMessage:NSLocalizedString(@"IncorrectInput", nil)];
        [self presentViewController:alert animated:YES completion:nil];
        
        return;
    }
    __weak typeof(self) weakSelf = self;
    [[SessionManager sharedInstance] sendRequestForTokenWithLogin:view.loginTextField.text andPassword:view.passwordTextField.text withComplitionHandler:^(NSString *token, NSError *error) {
        
        if (token) {

            UITabBarController *tabController = [[UITabBarController alloc] init];
            
            PPTopSongsListViewController *topSongsListVC = [[PPTopSongsListViewController alloc] init];
            FavoriteViewController *favoriteVC = [[FavoriteViewController alloc] init];
        
            NSArray *controllers = [NSArray arrayWithObjects:topSongsListVC, favoriteVC, nil];
            tabController.viewControllers = controllers;
            
            [weakSelf.navigationController pushViewController:tabController animated:YES];
        }
        else
        {
            UIAlertController *alert = [UIAlertController createAlertWithMessage:NSLocalizedString(@"InvalidData", nil)];
            
            [weakSelf presentViewController:alert animated:YES completion:nil];
        }
        
    }];    
}

@end
