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

    
    commandCenter.playCommand.enabled = YES;
 
    
    commandCenter.pauseCommand.enabled = YES;
  
    
    commandCenter.nextTrackCommand.enabled = YES;
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    
    [self playAction:view.playButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:nil];
}

- (void)viewWillAppear {
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Action methods

- (void)playAction:(UIButton *)sender
{
    if (!self.audioPlayer)
    {
        NSString *trackID = [self.trackInfo objectForKey:@"id"];
        [self updateTrackTitle:self.trackInfo];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
        
        [self trackDownloadAction:trackID];
        return;
    }
    
    if (sender.selected)
    {
        sender.selected = NO;
        [self.audioPlayer pause];
    }
    else
    {
        sender.selected = YES;
        [self.audioPlayer play];
    }
}

- (void)nextTrackAction
{
    NSDictionary *song = [self.delegate topSongsList:1];
    [self updateTrackTitle:song];
    NSString *trackID = [song objectForKey:@"id"];
    
    [self trackDownloadAction:trackID];
}

- (void)previousTrackAction
{
    NSDictionary *song = [self.delegate topSongsList:2];
    [self updateTrackTitle:song];
    NSString *trackID = [song objectForKey:@"id"];
    
    [self trackDownloadAction:trackID];
}

- (void)trackDownloadAction:(NSString *)trackID
{
    __weak typeof(self) weakSelf = self;
    [[SessionManager sharedInstance] tracksDownloadLinkWithTrackID:trackID withComplitionHandler:^(NSString *link, NSError *error) {
 
        NSURL *url = [NSURL URLWithString:link];
        [weakSelf createPlayerWithURL:url];
        
    }];
}

- (void)updateTime
{
//    Access Current Time
    NSTimeInterval aCurrentTime = CMTimeGetSeconds(self.audioPlayer.currentTime);
    
//    update UI with currentTime;
    self.playedTime.text = [NSString stringWithFormat:@"%02li:%02li", (long)aCurrentTime/60, (long)aCurrentTime %60];
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

- (void)createPlayerWithURL:(NSURL *)url
{
    AVPlayerItem *avPlayerItem =[[AVPlayerItem alloc] initWithURL:url];
    self.audioPlayer = [[AVPlayer alloc] initWithPlayerItem:avPlayerItem];
    [self.audioPlayer play];
    
    __weak typeof(self) weakSelf = self;
    void (^observerBlock)(CMTime time) = ^(CMTime time) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf updateTime];
        });
    };
    
    self.timeObserver = [self.audioPlayer addPeriodicTimeObserverForInterval:CMTimeMake(1, 1)
                                                                       queue:dispatch_queue_create("CHI.ProstoPleerApp.avplayer", NULL)
                                                                  usingBlock:observerBlock];
}

#pragma mark - MPRemoteCommandCenter

- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    switch (event.subtype) {
    
        case UIEventSubtypeRemoteControlPlay:
            [self.audioPlayer play];
            break;
        case UIEventSubtypeRemoteControlPause:
            [self.audioPlayer pause];
            break;
        case UIEventSubtypeRemoteControlNextTrack:
            break;
        case UIEventSubtypeRemoteControlPreviousTrack:
            break;
        default:
            break;
    }
}

- (void)playerItemDidReachEnd:(NSNotification *)notification
{
    [self nextTrackAction];
}

@end