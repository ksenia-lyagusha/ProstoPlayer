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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)getToken:(id)sender
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
    [[SessionManager sharedInstance] searchInfo];
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)getTopSongs:(id)sender
{
    [[SessionManager sharedInstance] topSongsList];
    
}

- (IBAction)downloadButton:(id)sender
{
    [[SessionManager sharedInstance] tracksDownloadLink];
}


- (IBAction)lyricsAction:(id)sender
{
    [[SessionManager sharedInstance] trackLyrics];
}
@end
