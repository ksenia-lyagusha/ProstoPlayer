//
//  PPMusicViewController.m
//  ProstoPleerApp
//
//  Created by Оксана on 25.11.15.
//  Copyright © 2015 CHI Software. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "PPMusicViewController.h"

#import "SessionManager.h"

#import "MusicView.h"

@interface PPMusicViewController () <PPMusicViewDelegate>

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) UISlider      *currentTimeSlider;

@end

@implementation PPMusicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor grayColor];
    self.parentViewController.tabBarController.title = @"Music player";
    
    self.currentTimeSlider = [[UISlider alloc] init];
    self.currentTimeSlider.minimumValue = 0.0f;
    self.currentTimeSlider.maximumValue = self.audioPlayer.duration;
    self.currentTimeSlider.translatesAutoresizingMaskIntoConstraints = NO;
    
    MusicView *view = [[MusicView alloc] init];
    [view addSubview:self.currentTimeSlider];
    view.delegate = self;
    view.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:view];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(view);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[view]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
}

- (void)playAction:(UIView *)view
{
    NSDictionary *value = [self.topList objectAtIndex:self.index];
    NSString *trackID = [value objectForKey:@"id"];
    
    [self trackDownloadAction:trackID];
  
}

- (void)nextTrackAction:(UIView *)view
{
    NSDictionary *value = [self.topList objectAtIndex:self.index + 1];
    NSString *trackID = [value objectForKey:@"id"];
    
    [self trackDownloadAction:trackID];
    
}

- (void)previousTrackAction:(UIView *)view
{
    NSDictionary *value = [self.topList objectAtIndex:self.index - 1];
    NSString *trackID = [value objectForKey:@"id"];
    
    [self trackDownloadAction:trackID];
}

- (void)pauseAction:(UIView *)view
{
    [self.audioPlayer pause];
}

- (void)screenLocksAction
{
    NSError *setCategoryErr = nil;
    NSError *activationErr  = nil;
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&setCategoryErr];
    [[AVAudioSession sharedInstance] setActive:YES error:&activationErr];
}

- (void)timerFired:(NSTimer*)timer
{

}

- (void)trackDownloadAction:(NSString *)trackID
{
    __weak typeof(self) weakSelf = self;
    [[SessionManager sharedInstance] tracksDownloadLinkWithTrackID:trackID withComplitionHandler:^(NSString *link, NSError *error) {
        
        NSString *path = [[NSBundle mainBundle] pathForResource:link ofType:@"mp3"];
        weakSelf.audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:link error:NULL];
        [weakSelf.audioPlayer play];
    }];
}

@end