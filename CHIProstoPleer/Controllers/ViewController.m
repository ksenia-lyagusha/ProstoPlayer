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

@interface ViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (strong, nonatomic) NSDictionary *dict;
@property (weak, nonatomic) IBOutlet UITextView *searchResult;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)sendAction:(id)sender
{
    [[SessionManager sharedInstance] sendRequestForToken];
    
}

- (IBAction)searchTextField:(id)sender
{
    
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField.text isEqualToString:@""])
    {
        return NO;
    }
    [[SessionManager sharedInstance] tracksDownloadLink];
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)searchButton:(id)sender
{
    [[SessionManager sharedInstance] searchInfo];
}

- (IBAction)downloadButton:(id)sender
{
    [[SessionManager sharedInstance] topSongsList];
}


@end
