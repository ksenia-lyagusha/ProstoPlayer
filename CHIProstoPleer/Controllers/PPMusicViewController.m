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

@interface PPMusicViewController () <PPMusicViewDelegate, AVAudioPlayerDelegate>

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) UISlider      *currentTimeSlider;
@property (nonatomic, strong) NSTimer       *timer;
@property (nonatomic, strong) UILabel       *playedTime;
@property (nonatomic, strong) UILabel       *trackTitle;

@end

@implementation PPMusicViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor grayColor];
    self.parentViewController.tabBarController.title = @"Music player";
    self.audioPlayer.delegate = self;
    
    self.currentTimeSlider = [[UISlider alloc] init];
    self.currentTimeSlider.minimumValue = 0.0f;
    self.currentTimeSlider.maximumValue = self.audioPlayer.duration;
    self.currentTimeSlider.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.playedTime = [[UILabel alloc] init];
    self.playedTime.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.trackTitle = [[UILabel alloc] init];
    self.trackTitle.translatesAutoresizingMaskIntoConstraints = NO;
//    self.trackTitle.text = [[self.topList objectAtIndex:self.index] stringValue];
    
    MusicView *view = [[MusicView alloc] init];
    [view addSubview:self.currentTimeSlider];
    [view addSubview:self.playedTime];
    [view addSubview:self.trackTitle];
    
    view.delegate = self;
    view.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:view];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(view, _currentTimeSlider, _playedTime, _trackTitle);
    NSDictionary *metrics = @{@"sideSpacing" : @20.0, @"verticalSpacing" : @320.0};
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[view]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-verticalSpacing-[_currentTimeSlider]"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-sideSpacing-[_currentTimeSlider]-100-[_playedTime]"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-verticalSpacing-[_playedTime]"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-250-[_trackTitle(50)]"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-sideSpacing-[_trackTitle]|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
    
    [self.audioPlayer prepareToPlay];
    
}

- (void)viewDidUnload
{
    [self setCurrentTimeSlider:nil];
}

#pragma mark - Action methods

- (void)playAction:(UIView *)view
{
    NSDictionary *value = [self.topList objectAtIndex:self.index];
    NSString *trackID = [value objectForKey:@"id"];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];

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
    [self stopTimer];
    [self updateTime];
}

- (void)trackDownloadAction:(NSString *)trackID
{
    __weak typeof(self) weakSelf = self;
    [[SessionManager sharedInstance] tracksDownloadLinkWithTrackID:trackID withComplitionHandler:^(NSString *link, NSError *error) {
        
        NSURL *url = [NSURL URLWithString:link];
        weakSelf.audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
        
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        [[AVAudioSession sharedInstance] setActive: YES error: nil];
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
        
        [weakSelf.audioPlayer prepareToPlay];
        [weakSelf.audioPlayer play];
    }];
}

- (void)updateTime
{
    NSTimeInterval currentTime = self.audioPlayer.currentTime;
    
    NSInteger minutes = floor(currentTime/60);
    NSInteger seconds = trunc(currentTime - minutes * 60);
    
    // update your UI with currentTime;
    self.playedTime.text = [NSString stringWithFormat:@"%ld:%02ld", (long)minutes, (long)seconds];
    self.currentTimeSlider.value = self.audioPlayer.currentTime;
}

- (void)stopTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark - AVAudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    NSLog(@"%s successfully=%@", __PRETTY_FUNCTION__, flag ? @"YES"  : @"NO");
    [self stopTimer];
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    NSLog(@"%s error=%@", __PRETTY_FUNCTION__, error);
    [self stopTimer];
}


@end