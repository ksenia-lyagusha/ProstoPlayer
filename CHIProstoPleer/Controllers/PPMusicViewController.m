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

@end

@implementation PPMusicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor grayColor];
    self.navigationItem.title = @"Music player";
    
    UIButton *playButton = [[UIButton alloc] initWithFrame:CGRectMake(50, 100, 320, 100)];
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
    
    [self.view addSubview:playButton];
    [self.view addSubview:nextTrack];
    [self.view addSubview:previousTrack];
    [self.view addSubview:pauseButton];
    
}

- (void)playAction:(UIButton *)sender
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"audioTest" ofType:@"mp3"];
    AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL: [NSURL fileURLWithPath:path] error:NULL];
    
    [audioPlayer play];
}

- (void)nextTrackAction:(UIButton *)sender
{
    
}

- (void)previousTrackAction:(UIButton *)sender
{
    
}

- (void)pauseAction:(UIButton *)sender
{
    
}

- (void)screenLocksAction
{
    NSError *setCategoryErr = nil;
    NSError *activationErr  = nil;
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&setCategoryErr];
    [[AVAudioSession sharedInstance] setActive:YES error:&activationErr];
}

@end
