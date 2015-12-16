//
//  PPMusicViewController.m
//  ProstoPleerApp
//
//  Created by Оксана on 25.11.15.
//  Copyright © 2015 CHI Software. All rights reserved.
//

#import "PPMusicViewController.h"

#import "SessionManager.h"

#import "MusicView.h"

@interface PPMusicViewController () <PPMusicViewDelegate>

@property (nonatomic, strong) UISlider *currentTimeSlider;
@property (nonatomic, strong) UILabel  *playedTime;
@property (nonatomic, strong) UILabel  *trackTitle;
@property (nonatomic, strong) NSArray  *topList;
@property (nonatomic, strong) id        timeObserver;

@end

@implementation PPMusicViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

//    self.view.contentMode = UIViewContentModeScaleAspectFit;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.title = @"Music player";
    
    self.currentTimeSlider = [[UISlider alloc] init];
    [self.currentTimeSlider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
    self.currentTimeSlider.continuous = YES; 
    self.currentTimeSlider.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.playedTime = [[UILabel alloc] init];
    self.playedTime.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.trackTitle = [[UILabel alloc] init];
    self.trackTitle.lineBreakMode = NSLineBreakByWordWrapping;
    self.trackTitle.numberOfLines = 0;
    self.trackTitle.textAlignment = NSTextAlignmentCenter;
    self.trackTitle.translatesAutoresizingMaskIntoConstraints = NO;
    
    
//    UIToolbar *toolBar = [self addToolbar];
    
    MusicView *view = [[MusicView alloc] init];
    [self.view addSubview:imageView];
    [view addSubview:self.currentTimeSlider];
    [view addSubview:self.playedTime];
    [view addSubview:self.trackTitle];
    
//    [view addSubview:toolBar];
    
    view.delegate = self;
    view.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:view];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(view, _currentTimeSlider, _playedTime, _trackTitle);
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[view]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
    
    NSLayoutConstraint *horizontalConstraintForSlider = [NSLayoutConstraint constraintWithItem:self.currentTimeSlider
                                                                                   attribute:NSLayoutAttributeCenterY
                                                                                   relatedBy:NSLayoutRelationEqual
                                                                                      toItem:self.view
                                                                                   attribute:NSLayoutAttributeBottom
                                                                                  multiplier:0.6
                                                                                    constant:0];
    [self.view addConstraint:horizontalConstraintForSlider];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-30-[_currentTimeSlider]-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_trackTitle(50)]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_trackTitle]-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];

    NSLayoutConstraint *verticalConstraintForTime = [NSLayoutConstraint constraintWithItem:self.playedTime
                                                                         attribute:NSLayoutAttributeCenterX
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.view
                                                                         attribute:NSLayoutAttributeCenterX
                                                                        multiplier:1
                                                                          constant:0];
    [self.view addConstraint:verticalConstraintForTime];
    
    NSLayoutConstraint *horizontalConstraintForTime = [NSLayoutConstraint constraintWithItem:self.playedTime
                                                                                 attribute:NSLayoutAttributeCenterY
                                                                                 relatedBy:NSLayoutRelationEqual
                                                                                    toItem:self.view
                                                                                 attribute:NSLayoutAttributeBottom
                                                                                multiplier:0.65
                                                                                  constant:0];
    [self.view addConstraint:horizontalConstraintForTime];
    
    NSLayoutConstraint *yCenterConstraintForTitle = [NSLayoutConstraint constraintWithItem:self.trackTitle
                                                                                attribute:NSLayoutAttributeCenterY
                                                                                relatedBy:NSLayoutRelationEqual
                                                                                   toItem:self.view
                                                                                attribute:NSLayoutAttributeCenterY
                                                                               multiplier:1.0
                                                                                 constant:0];
    [self.view addConstraint:yCenterConstraintForTitle];
    
    NSLayoutConstraint *xCenterConstraintForTitle = [NSLayoutConstraint constraintWithItem:self.trackTitle
                                                                                 attribute:NSLayoutAttributeCenterX
                                                                                 relatedBy:NSLayoutRelationEqual
                                                                                    toItem:self.view
                                                                                 attribute:NSLayoutAttributeCenterX
                                                                                multiplier:1.0
                                                                                  constant:0];
    [self.view addConstraint:xCenterConstraintForTitle];
    
    MPRemoteCommandCenter *commandCenter = [MPRemoteCommandCenter sharedCommandCenter];
    
    commandCenter.previousTrackCommand.enabled = YES;
    [commandCenter.previousTrackCommand addTarget:self action:@selector(previousTrackAction)];
    
    commandCenter.playCommand.enabled = NO;
    [commandCenter.playCommand addTarget:self action:@selector(playControlCenterAction:)];
    
    commandCenter.pauseCommand.enabled = YES;
    [commandCenter.pauseCommand addTarget:self action:@selector(playControlCenterAction:)];
    
    commandCenter.nextTrackCommand.enabled = YES;
    [commandCenter.nextTrackCommand addTarget:self action:@selector(nextTrackAction)];
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    
    [self playAction:view.playButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:nil];
    
}

- (void)viewWillAppear
{
    [super viewWillAppear:YES];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    __weak typeof(self) weakSelf = self;
    [self.delegate stopPlayback:^(AVPlayer *playback) {
        
        [weakSelf.audioPlayer pause];
        weakSelf.audioPlayer = nil;
//        weakSelf.currentTimeSlider = nil;
    }];
    
    [self.audioPlayer removeTimeObserver:self.timeObserver];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
}

#pragma mark - Action methods

- (void)playAction:(UIButton *)sender
{
    if (!self.audioPlayer)
    {
        NSString *trackID = [self.trackInfo objectForKey:@"id"];
        [self updateTrackTitle:self.trackInfo];
        
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


- (void)sliderAction:(UIGestureRecognizer *)sender
{

}

- (void)updateTime
{
    self.currentTimeSlider.maximumValue = CMTimeGetSeconds(self.audioPlayer.currentItem.asset.duration);
    [self.currentTimeSlider setValue:CMTimeGetSeconds(self.audioPlayer.currentTime) animated:YES];
    
//    Access Current Time
    NSTimeInterval aCurrentTime = CMTimeGetSeconds(self.audioPlayer.currentTime);
    
//    update UI with currentTime;
    self.playedTime.text = [NSString stringWithFormat:@"%02li:%02li", (long)aCurrentTime/60, (long)aCurrentTime %60];
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

- (void)playControlCenterAction:(MPRemoteCommandCenter *)sender
{
 
//    if (sender.pauseCommand) {
//        [self.audioPlayer play];
//    }
//    else
//    {
        [self.audioPlayer play];

//    }
    

}

#pragma mark - MPRemoteCommandCenter

- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    NSLog(@"received event!");
    if (event.type == UIEventTypeRemoteControl) {
        switch (event.subtype) {
            case UIEventSubtypeRemoteControlTogglePlayPause: {
                if (self.audioPlayer.rate > 0.0) {
                    [self.audioPlayer pause];
                } else {
                    [self.audioPlayer play];
                }
                
                break;
            }
            case UIEventSubtypeRemoteControlPlay: {
                [self.audioPlayer play];
                break;
            }
            case UIEventSubtypeRemoteControlPause: {
                [self.audioPlayer pause];
                break;
            }
            default:
                break;
        }
    }
    
//    switch (event.subtype) {
//    
//        case UIEventSubtypeRemoteControlPlay:
//            [self.audioPlayer play];
//            break;
//        case UIEventSubtypeRemoteControlPause:
//            [self.audioPlayer pause];
//            break;
//        case UIEventSubtypeRemoteControlNextTrack:
//            break;
//        case UIEventSubtypeRemoteControlPreviousTrack:
//            break;
//        default:
//            break;
//    }
}

- (void)playerItemDidReachEnd:(NSNotification *)notification
{
    [self nextTrackAction];
}
#pragma mark - ToolBar

- (UIToolbar *)addToolbar
{
    UIBarButtonItem *customItem1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"previous"] style:UIBarButtonItemStylePlain target:self action:@selector(previousTrackAction)];
    UIBarButtonItem *customItem2 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"play"]  style:UIBarButtonItemStylePlain target:self action:@selector(playAction:)];
    UIBarButtonItem *customItem3 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"next"] style:UIBarButtonItemStylePlain target:self action:@selector(nextTrackAction)];
    
    NSArray *toolbarItems = [NSArray arrayWithObjects: customItem1, customItem2, customItem3, nil];
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    [toolbar setBarStyle:UIBarStyleDefault];
    [toolbar setItems:toolbarItems];
    
    return toolbar;
}

@end