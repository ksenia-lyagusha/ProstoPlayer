//
//  PPLoginViewController.m
//  ProstoPleerApp
//
//  Created by Оксана on 15.11.15.
//  Copyright © 2015 CHI Software. All rights reserved.
//

#import "PPLoginViewController.h"
#import "PPTopSongsListViewController.h"
#import "FavoriteViewController.h"
#import "LoginView.h"

#import "SessionManager.h"
#import "UIAlertController+Category.h"
#import "CoreDataManager.h"
#import "User.h"

#import <MBProgressHUD.h>

@interface PPLoginViewController () <PPLoginViewDelegate>

@end

@implementation PPLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"CHIProstoPleer";
    self.view.backgroundColor = [UIColor colorWithRed:166/255.0 green:239/255.0 blue:42/255.0 alpha:1];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    
    LoginView *view = [[LoginView alloc] init];
    [self.view addSubview:view];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    view.delegate = self;
    
    NSDictionary *views = NSDictionaryOfVariableBindings(view);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[view]|"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
    if([[SessionManager sharedInstance] token])
    {
        [self goToMainMenuWithLogin:view.loginTextField.text];
    }
}

#pragma mark - PPLoginViewDelegate

- (void)signInAction:(LoginView *)view
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if ([view.loginTextField.text isEqualToString:@""] || [view.passwordTextField.text isEqualToString:@""])
    {
        UIAlertController *alert = [UIAlertController createAlertWithMessage:NSLocalizedString(@"IncorrectInput", nil)];
        [self presentViewController:alert animated:YES completion:nil];
        
        return;
    }
    __weak typeof(self) weakSelf = self;
    
    [[SessionManager sharedInstance] sendRequestForTokenWithLogin:view.loginTextField.text andPassword:view.passwordTextField.text withComplitionHandler:^(NSString *token, NSError *error) {
        
        if (token)
        {
            User *userObj = [[CoreDataManager sharedInstanceCoreData] addNewUser];
            userObj.login = view.loginTextField.text;
            [[CoreDataManager sharedInstanceCoreData] saveContext];
            
            [[CoreDataManager sharedInstanceCoreData] setCurrentUserLogin:view.loginTextField.text];
            
             [weakSelf goToMainMenuWithLogin:view.loginTextField.text];
        }
        else
        {
            UIAlertController *alert = [UIAlertController createAlertWithMessage:NSLocalizedString(@"InvalidData", nil)];
            
            [weakSelf presentViewController:alert animated:YES completion:nil];
        }
    }];    
}

- (void)goToMainMenuWithLogin:(NSString *)login
{
    UITabBarController *tabController = [[UITabBarController alloc] init];
    
    PPTopSongsListViewController *topSongsListVC = [[PPTopSongsListViewController alloc] init];
    FavoriteViewController *favoriteVC = [[FavoriteViewController alloc] init];
//    favoriteVC.userTracks = [[CoreDataManager sharedInstanceCoreData] fetchObjectsForUserWithLogin:login];
    NSArray *controllers = [NSArray arrayWithObjects:topSongsListVC, favoriteVC,nil];
    tabController.viewControllers = controllers;

    [self.navigationController pushViewController:tabController animated:YES];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

@end
