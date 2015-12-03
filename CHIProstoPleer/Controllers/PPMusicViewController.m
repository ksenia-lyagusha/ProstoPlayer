//
//  PPMusicViewController.m
//  ProstoPleerApp
//
//  Created by Оксана on 25.11.15.
//  Copyright © 2015 CHI Software. All rights reserved.
//

#import "PPMusicViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "SessionManager.h"

@interface PPMusicViewController ()

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) UISlider      *currentTimeSlider;

@end

@implementation PPMusicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor grayColor];
    self.navigationItem.title = @"Music player";
    
    UIButton *playButton = [[UIButton alloc] init];
    [playButton setImage:[UIImage imageNamed:@"play"]  forState:UIControlStateNormal];
    [playButton addTarget:self action:@selector(playAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *nextTrack = [[UIButton alloc] init];
    [nextTrack setImage:[UIImage imageNamed:@"next"] forState:UIControlStateNormal];
    [playButton addTarget:self action:@selector(nextTrackAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *previousTrack = [[UIButton alloc] init];
    [previousTrack setImage:[UIImage imageNamed:@"previous"] forState:UIControlStateNormal];
    [playButton addTarget:self action:@selector(previousTrackAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *pauseButton = [[UIButton alloc] init];
    [pauseButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    [playButton addTarget:self action:@selector(pauseAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *elapsedTimeLabel = [[UILabel alloc] init];
    elapsedTimeLabel.text = @"00.00";
    
    UILabel *remainingTimeLabel = [[UILabel alloc] init];
    remainingTimeLabel.text = @"00.00";
    
    self.currentTimeSlider = [[UISlider alloc] init];
    self.currentTimeSlider.minimumValue = 0.0f;
    self.currentTimeSlider.maximumValue = self.audioPlayer.duration;
    
    [self.view addSubview:playButton];
    [self.view addSubview:nextTrack];
    [self.view addSubview:previousTrack];
    [self.view addSubview:pauseButton];
    [self.view addSubview:self.currentTimeSlider];
    [self.view addSubview:elapsedTimeLabel];
    [self.view addSubview:remainingTimeLabel];
    
    
    NSDictionary *views = NSDictionaryOfVariableBindings(playButton, nextTrack, previousTrack, pauseButton, _currentTimeSlider, elapsedTimeLabel, remainingTimeLabel);
    NSDictionary *metrics = @{@"sideSpacing" : @364.0, @"verticalSpacing" : @40.0};
    
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-sideSpacing-[elapsedTimeLabel]-verticalSpacing-[playButton]|"
//                                                                      options:0
//                                                                      metrics:metrics
//                                                                        views:views]];
//    
//    
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-20-[elapsedTimeLabel]-10-[_currentTimeSlider]-10-[remainingTimeLabel]|"
//                                                                      options:0
//                                                                      metrics:metrics
//                                                                        views:views]];
//    
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-20-[playButton]-10-[previousTrack]-40-[nextTrack]-10-[pauseButton]|"
//                                                                      options:0
//                                                                      metrics:metrics
//                                                                        views:views]];
}

- (void)playAction:(UIButton *)sender
{
    NSDictionary *value = [self.topList objectAtIndex:self.index];
    NSString *trackID = [value objectForKey:@"id"];
    
    [self trackDownloadAction:trackID];
  
}

- (void)nextTrackAction:(UIButton *)sender
{
    NSDictionary *value = [self.topList objectAtIndex:self.index + 1];
    NSString *trackID = [value objectForKey:@"id"];
    
    [self trackDownloadAction:trackID];
    
}

- (void)previousTrackAction:(UIButton *)sender
{
    NSDictionary *value = [self.topList objectAtIndex:self.index - 1];
    NSString *trackID = [value objectForKey:@"id"];
    
    [self trackDownloadAction:trackID];
}

- (void)pauseAction:(UIButton *)sender
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
        weakSelf.audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL: [NSURL fileURLWithPath:path] error:NULL];
        [weakSelf.audioPlayer play];
    }];
}

@end
