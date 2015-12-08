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
    self.parentViewController.tabBarController.title = @"Music player";

    
    UIButton *playButton = [[UIButton alloc] init];
    [playButton setImage:[UIImage imageNamed:@"play"]  forState:UIControlStateNormal];
    [playButton addTarget:self action:@selector(playAction:) forControlEvents:UIControlEventTouchUpInside];
    playButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIButton *nextTrack = [[UIButton alloc] init];
    [nextTrack setImage:[UIImage imageNamed:@"next"] forState:UIControlStateNormal];
    [nextTrack addTarget:self action:@selector(nextTrackAction:) forControlEvents:UIControlEventTouchUpInside];
    nextTrack.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIButton *previousTrack = [[UIButton alloc] init];
    [previousTrack setImage:[UIImage imageNamed:@"previous"] forState:UIControlStateNormal];
    [previousTrack addTarget:self action:@selector(previousTrackAction:) forControlEvents:UIControlEventTouchUpInside];
    previousTrack.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIButton *pauseButton = [[UIButton alloc] init];
    [pauseButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    [pauseButton addTarget:self action:@selector(pauseAction:) forControlEvents:UIControlEventTouchUpInside];
    pauseButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    UILabel *elapsedTimeLabel = [[UILabel alloc] init];
    elapsedTimeLabel.text = @"00.00";
    elapsedTimeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    UILabel *remainingTimeLabel = [[UILabel alloc] init];
    remainingTimeLabel.text = @"00.00";
    remainingTimeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.currentTimeSlider = [[UISlider alloc] init];
    self.currentTimeSlider.minimumValue = 0.0f;
    self.currentTimeSlider.maximumValue = self.audioPlayer.duration;
    self.currentTimeSlider.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:playButton];
    [self.view addSubview:nextTrack];
    [self.view addSubview:previousTrack];
    [self.view addSubview:pauseButton];
    [self.view addSubview:self.currentTimeSlider];
    [self.view addSubview:elapsedTimeLabel];
    [self.view addSubview:remainingTimeLabel];
    
    
    NSDictionary *views = NSDictionaryOfVariableBindings(playButton, nextTrack, previousTrack, pauseButton, _currentTimeSlider, elapsedTimeLabel, remainingTimeLabel);
    NSDictionary *metrics = @{@"sideSpacing" : @364.0, @"verticalSpacing" : @40.0};
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-150-[nextTrack]|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-150-[nextTrack]|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-150-[nextTrack]|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-150-[playButton]|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-150-[nextTrack]|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-150-[previousTrack]|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-150-[nextTrack]|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
    
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-150-[pauseButton]|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
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
