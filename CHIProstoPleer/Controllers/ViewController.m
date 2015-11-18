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

@property (nonatomic, strong) NSDictionary *topList;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    
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

    [[SessionManager sharedInstance] searchInfoWithText:textField.text withComplitionHandler:nil];
    
    [textField resignFirstResponder];
    return YES;
}


- (IBAction)getTopSongs:(id)sender
{
    [[SessionManager sharedInstance] sendRequestForTokenWithLogin:@"ksenya-15" andPassword:@"rewert-321" withComplitionHandler:nil];
    
    [[SessionManager sharedInstance] topSongsList:^(NSDictionary *topList, NSError *error) {
        self.topList = topList;
    }];
    
}

- (IBAction)downloadButton:(id)sender
{
    [[SessionManager sharedInstance] tracksDownloadLinkWithTrackID:@"44736143Ee9" withComplitionHandler:nil];
}


- (IBAction)lyricsAction:(id)sender
{ 
    [[SessionManager sharedInstance] trackLyricsWithTrackID:@"44736143Ee9" withComplitionHandler:nil];
}

@end
