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

@property (nonatomic, strong) AVPlayer *audioPlayer;
@property (nonatomic, strong) UISlider *currentTimeSlider;
@property (nonatomic, strong) NSTimer  *timer;
@property (nonatomic, strong) UILabel  *playedTime;
@property (nonatomic, strong) UILabel  *trackTitle;

@end

@implementation PPMusicViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    self.view.contentMode = UIViewContentModeScaleAspectFit;
//    self.audioPlayer.delegate = self;

    self.tabBarController.title = @"Music player";
    
    self.currentTimeSlider = [[UISlider alloc] init];
    self.currentTimeSlider.minimumValue = 0.0f;

    self.currentTimeSlider.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.playedTime = [[UILabel alloc] init];
    self.playedTime.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.trackTitle = [[UILabel alloc] init];
    self.trackTitle.translatesAutoresizingMaskIntoConstraints = NO;
    
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
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-150-[_trackTitle(50)]"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-sideSpacing-[_trackTitle]|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
    [self playAction:nil];
    
    
}

- (void)viewDidUnload
{
    [self setCurrentTimeSlider:nil];
}

#pragma mark - Action methods

- (void)playAction:(UIView *)view
{
    NSString *trackID = [self.trackInfo objectForKey:@"id"];
    [self updateTrackTitle];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
    
    [self trackDownloadAction:trackID];
}

- (void)nextTrackAction:(UIView *)view
{
    [self updateTrackTitle];
    NSString *trackID = [self.trackInfo objectForKey:@"id"];
    
    [self trackDownloadAction:trackID];
}

- (void)previousTrackAction:(UIView *)view
{
    [self updateTrackTitle];
    NSString *trackID = [self.trackInfo objectForKey:@"id"];
    
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
        
        AVPlayerItem *avPlayerItem =[[AVPlayerItem alloc]initWithURL:url];
        weakSelf.audioPlayer = [[AVPlayer alloc]initWithPlayerItem:avPlayerItem];
        [weakSelf.audioPlayer pause];
        [weakSelf.audioPlayer play];

        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        [[AVAudioSession sharedInstance] setActive: YES error: nil];
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    }];
}

- (void)updateTime
{
//    CMTime currentTime = [self.audioPlayer currentTime];
    
//    NSInteger minutes = floor(currentTime.timescale/60);
//    NSInteger seconds = trunc(currentTime.timescale - minutes * 60);

    // Access Current Time
    NSTimeInterval aCurrentTime = CMTimeGetSeconds(self.audioPlayer.currentTime);
    
    // Access Duration
//    NSTimeInterval aDuration = CMTimeGetSeconds(self.audioPlayer.currentItem.asset.duration);
    
//    update your UI with currentTime;
    self.playedTime.text = [NSString stringWithFormat:@"%li:%li", (long)aCurrentTime/60, (long)aCurrentTime %60];
}

- (void)stopTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)updateTrackTitle
{
    NSString *artist = [self.trackInfo objectForKey:@"artist"];
    NSString *track = [self.trackInfo objectForKey:@"track"];
    self.trackTitle.text = [NSString stringWithFormat:@"%@ - %@", artist, track];
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