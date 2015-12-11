//
//  PPMusicViewController.m
//  ProstoPleerApp
//
//  Created by Оксана on 25.11.15.
//  Copyright © 2015 CHI Software. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

#import "PPMusicViewController.h"

#import "SessionManager.h"

#import "MusicView.h"

@interface PPMusicViewController () <PPMusicViewDelegate>

@property (nonatomic, strong) AVPlayer *audioPlayer;
@property (nonatomic, strong) UISlider *currentTimeSlider;
@property (nonatomic, strong) NSTimer  *timer;
@property (nonatomic, strong) UILabel  *playedTime;
@property (nonatomic, strong) UILabel  *trackTitle;
@property (nonatomic, strong) NSArray  *topList;
@property (nonatomic, strong) id        timeObserver;

@end

@implementation PPMusicViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    self.view.contentMode = UIViewContentModeScaleAspectFit;
    
    self.title = @"Music player";
    
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


    MPRemoteCommandCenter *commandCenter = [MPRemoteCommandCenter sharedCommandCenter];
    
    commandCenter.previousTrackCommand.enabled = YES;
    [commandCenter.previousTrackCommand addTarget:self action:@selector(previousTapped:)];
    
    commandCenter.playCommand.enabled = YES;
    [commandCenter.playCommand addTarget:self action:@selector(playAudio:)];
    
    commandCenter.pauseCommand.enabled = YES;
    [commandCenter.pauseCommand addTarget:self action:@selector(pauseAudio:)];
    
    commandCenter.nextTrackCommand.enabled = YES;
    [commandCenter.nextTrackCommand addTarget:self action:@selector(nextTapped:)];
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    
    void (^observerBlock)(CMTime time) = ^(CMTime time) {
        NSString *timeString = [NSString stringWithFormat:@"%02.2f", (float)time.value / (float)time.timescale];
        if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive) {
            self.trackTitle.text = timeString;
        } else {
            NSLog(@"App is backgrounded. Time is: %@", timeString);
        }
    };
    
    self.timeObserver = [self.audioPlayer addPeriodicTimeObserverForInterval:CMTimeMake(10, 1000)
                                                                  queue:dispatch_get_main_queue()
                                                             usingBlock:observerBlock];
    
    [self playAction:nil];
    
    self.audioPlayer.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:[self.audioPlayer currentItem]];
}

- (void)viewWillAppear {
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
}

#pragma mark - Action methods

- (void)playAction:(UIView *)view
{
    if (self.audioPlayer) {
        [self.audioPlayer play];
    
        return;
    }
    NSString *trackID = [self.trackInfo objectForKey:@"id"];
    [self updateTrackTitle:self.trackInfo];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
    
    [self trackDownloadAction:trackID];
}

- (void)nextTrackAction:(UIView *)view
{
    NSDictionary *song = [self.delegate topSongsList:1];
    [self updateTrackTitle:song];
    NSString *trackID = [song objectForKey:@"id"];
    
    [self trackDownloadAction:trackID];
}

- (void)previousTrackAction:(UIView *)view
{
    NSDictionary *song = [self.delegate topSongsList:2];
    [self updateTrackTitle:song];
    NSString *trackID = [song objectForKey:@"id"];
    
    [self trackDownloadAction:trackID];
}

- (void)pauseAction:(UIView *)view
{
    [self.audioPlayer pause];
//    [self stopTimer];
    [self updateTime];
}

- (void)trackDownloadAction:(NSString *)trackID
{
    __weak typeof(self) weakSelf = self;
    [[SessionManager sharedInstance] tracksDownloadLinkWithTrackID:trackID withComplitionHandler:^(NSString *link, NSError *error) {
 
        NSURL *url = [NSURL URLWithString:link];
        
        AVPlayerItem *avPlayerItem =[[AVPlayerItem alloc]initWithURL:url];
        weakSelf.audioPlayer = [[AVPlayer alloc]initWithPlayerItem:avPlayerItem];
        [weakSelf.audioPlayer play];

    }];
}

- (void)updateTime
{
//    Access Current Time
    NSTimeInterval aCurrentTime = CMTimeGetSeconds(self.audioPlayer.currentTime);
    
//    update UI with currentTime;
    self.playedTime.text = [NSString stringWithFormat:@"%li:%li", (long)aCurrentTime/60, (long)aCurrentTime %60];
}

- (void)stopTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)updateTrackTitle:(NSDictionary *)song
{
    NSString *artist = [song objectForKey:@"artist"];
    NSString *track = [song objectForKey:@"track"];
    self.trackTitle.text = [NSString stringWithFormat:@"%@ - %@", artist, track];
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    switch (event.subtype) {
        case UIEventSubtypeRemoteControlPlay:
            [self.audioPlayer play];
            break;
        case UIEventSubtypeRemoteControlPause:
            [self.audioPlayer pause];
            break;
        default:
            break;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"currentItem"])
    {
        AVPlayerItem *item = ((AVPlayer *)object).currentItem;
        self.trackTitle.text = ((AVURLAsset*)item.asset).URL.pathComponents.lastObject;
        NSLog(@"New music name: %@", self.trackTitle.text);
    }
}

- (void)playerItemDidReachEnd:(NSNotification *)notification
{
    AVPlayerItem *playerItem = [notification object];
    [playerItem seekToTime:kCMTimeZero];
}
@end