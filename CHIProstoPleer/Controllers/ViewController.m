//
//  ViewController.m
//  ProstoPleerApp
//
//  Created by CHI Software on 11/10/15.
//  Copyright © 2015 CHI Software. All rights reserved.
//

#import "ViewController.h"
#import "SessionManager.h"
#import "APIManager.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (strong, nonatomic) NSDictionary *dict;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)sendAction:(id)sender
{
//    __weak typeof(self) weakSelf = self;
    SessionManager *sessionManager = [[SessionManager alloc] init];
    [sessionManager sendRequest];
}

@end
