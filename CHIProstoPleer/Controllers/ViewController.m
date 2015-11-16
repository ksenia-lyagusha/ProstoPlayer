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

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)getTopSongsAction:(id)sender
{
    [[SessionManager sharedInstance] topSongsList:nil];
    
}

- (IBAction)downloadButton:(id)sender
{
    [[SessionManager sharedInstance] tracksDownloadLink:nil];
}

- (IBAction)getLyricsAction:(id)sender
{
     [[SessionManager sharedInstance] trackLyrics:nil];
    
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
    
    [[SessionManager sharedInstance] searchInfo:nil];
    [textField resignFirstResponder];
    return YES;
}

@end
