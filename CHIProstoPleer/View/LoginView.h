//
//  LoginView.h
//  ProstoPleerApp
//
//  Created by Оксана on 18.11.15.
//  Copyright © 2015 CHI Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LoginView;

@protocol PPLoginViewDelegate <NSObject>

- (void)signInAction:(LoginView *)view;

@end

@interface LoginView : UIView

@property (weak, nonatomic) id <PPLoginViewDelegate>delegate;

@property (nonatomic, strong, readonly) UITextField *loginTextField;
@property (nonatomic, strong, readonly) UITextField *passwordTextField;

@end
