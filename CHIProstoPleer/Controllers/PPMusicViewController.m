//
//  PPMusicViewController.m
//  ProstoPleerApp
//
//  Created by Оксана on 25.11.15.
//  Copyright © 2015 CHI Software. All rights reserved.
//

#import "PPMusicViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface PPMusicViewController ()

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) UISlider      *currentTimeSlider;
@property (nonatomic, strong) NSTimer       *timer;
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
    
    
    NSDictionary *views = NSDictionaryOfVariableBindings(playButton, nextTrack, previousTrack, pauseButton, self.currentTimeSlider, elapsedTimeLabel, remainingTimeLabel);
    NSDictionary *metrics = @{@"sideSpacing" : @364.0, @"verticalSpacing" : @40.0};
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|V-sideSpacing-[elapsedTimeLabel-verticalSpacing-[playButton]|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
    
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-20-[elapsedTimeLabel]-10-[self.currentTimeSlider]-10-[remainingTimeLabel]|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-20-[playButton]-10-[previousTrack]-40-[nextTrack]-10-[pauseButton]|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
}

- (void)playAction:(UIButton *)sender
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"audioTest" ofType:@"mp3"];
    self.audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL: [NSURL fileURLWithPath:path] error:NULL];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
    
    [self.audioPlayer play];
}

- (void)nextTrackAction:(UIButton *)sender
{
    [self.topList objectAtIndex:self.index + 1];
    [self.audioPlayer play];
}

- (void)previousTrackAction:(UIButton *)sender
{
    [self.topList objectAtIndex:self.index - 1];
    [self.audioPlayer play];
}

- (void)pauseAction:(UIButton *)sender
{
    [self.audioPlayer stop];
    [self stopTimer];
}

- (void)screenLocksAction
{
    NSError *setCategoryErr = nil;
    NSError *activationErr  = nil;
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&setCategoryErr];
    [[AVAudioSession sharedInstance] setActive:YES error:&activationErr];
}

- (void)updateDisplay
{
    NSTimeInterval currentTime = self.audioPlayer.currentTime;
//    NSString* currentTimeString = [NSString stringWithFormat:@"%.02f", currentTime];
    
    self.currentTimeSlider.value = currentTime;
//    [self updateSliderLabels];

}

#pragma mark - Timer

- (void)timerFired:(NSTimer*)timer
{
    [self updateDisplay];
}

- (void)stopTimer
{
    [self.timer invalidate];
    self.timer = nil;
    [self updateDisplay];
}

@end
