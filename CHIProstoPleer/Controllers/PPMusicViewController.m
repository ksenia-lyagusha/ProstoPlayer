//
//  PPMusicViewController.m
//  ProstoPleerApp
//
//  Created by Оксана on 25.11.15.
//  Copyright © 2015 CHI Software. All rights reserved.
//

#import "PPMusicViewController.h"
#import "UIAlertController+Category.h"
#import <MBProgressHUD.h>

#import "SessionManager.h"

#import "MusicView.h"

#import "Track.h"
#import "CoreDataManager.h"

@interface PPMusicViewController () <PPMusicViewDelegate>

@property (nonatomic, strong) UISlider    *currentTimeSlider;
@property (nonatomic, strong) UILabel     *playedTime;
@property (nonatomic, strong) UILabel     *trackTitle;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) NSArray     *topList;
@property (nonatomic, strong) id          timeObserver;
@property (nonatomic, strong) MusicView   *musicView;

@end

@implementation PPMusicViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.imageView.layer.masksToBounds = YES;
    
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

    self.musicView = [[MusicView alloc] init];
    self.musicView.delegate = self;
    self.musicView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.musicView];
    [self.view addSubview:self.playedTime];
    [self.view addSubview:self.trackTitle];
    [self.view addSubview:self.currentTimeSlider];
  
    [self setupConstraints];
    
    MPRemoteCommandCenter *commandCenter = [MPRemoteCommandCenter sharedCommandCenter];
    
    commandCenter.previousTrackCommand.enabled = YES;
    [commandCenter.previousTrackCommand addTarget:self action:@selector(previousTrackAction)];
    
    commandCenter.playCommand.enabled = YES;
    [commandCenter.playCommand addTarget:self action:@selector(playControlCenterAction:)];
    
    commandCenter.pauseCommand.enabled = YES;
    [commandCenter.pauseCommand addTarget:self action:@selector(playControlCenterAction:)];
    
    commandCenter.nextTrackCommand.enabled = YES;
    [commandCenter.nextTrackCommand addTarget:self action:@selector(nextTrackAction)];
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    
//    [self playAction:self.musicView.playButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:nil];
    
    UIBarButtonItem *favouriteButton         = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"add"] style:UIBarButtonItemStylePlain target:self action:@selector(addToFavorites:)];
    
    UIBarButtonItem *downloadButton          = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"download"] style:UIBarButtonItemStylePlain target:self action:@selector(downloadTrackAction:)];
    
    self.navigationItem.rightBarButtonItems  = [NSArray arrayWithObjects:favouriteButton, downloadButton, nil];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (self.timeObserver)
    {
        [self.audioPlayer removeTimeObserver:self.timeObserver];
        self.timeObserver = nil;
    }
   
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Action methods

- (void)playAction:(UIButton *)sender
{
    if (!self.audioPlayer)
    {
        NSString *trackID = self.info.track_id;
        [self updateTrackTitle:self.info];
        
        [self trackDownloadAction:trackID];
        return;
    }
    
    if (self.musicView.playButton.selected)
    {
        self.musicView.playButton.selected = NO;
        [self.audioPlayer pause];
    }
    else
    {
        self.musicView.playButton.selected = YES;
        [self.audioPlayer play];
    }
}

- (void)nextTrackAction
{
    id <PPTrackInfoProtocol>song = [self.delegate topSongsList:PPTrackDirectionFastForward];
    [self updateTrackTitle:song];
    NSString *trackID = song.track_id;
    
    [self trackDownloadAction:trackID];
}

- (void)previousTrackAction
{
    id <PPTrackInfoProtocol>song = [self.delegate topSongsList:PPTrackDirectionFastRewind];
    [self updateTrackTitle:song];
    NSString *trackID = song.track_id;
    
    [self trackDownloadAction:trackID];
}

- (void)trackDownloadAction:(NSString *)trackID
{
    __weak typeof(self) weakSelf = self;
    [[SessionManager sharedInstance] tracksDownloadLinkWithTrackID:trackID withComplitionHandler:^(NSString *link, NSError *error) {
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSURL *url = [NSURL URLWithString:link];
        [weakSelf createPlayerWithURL:url];
        
    }];
}

- (void)sliderAction:(UISlider *)sender
{
    [self.currentTimeSlider setValue:sender.value animated:YES];
    [self.audioPlayer seekToTime:CMTimeMakeWithSeconds(sender.value, 1)];
}

- (void)playControlCenterAction:(MPRemoteCommand *)sender
{
    if (self.musicView.playButton.selected)
    {
        self.musicView.playButton.selected = NO;
        [self.audioPlayer pause];
        
    }
    else
    {
        self.musicView.playButton.selected = YES;
        [self.audioPlayer play];
    }
}

- (void)downloadTrackAction:(UIButton *)sender
{
    [[SessionManager sharedInstance] setIsDownload:YES];
    [[SessionManager sharedInstance] downloadTrackWithTrackID:self.info.track_id withComplitionHandler:^(NSString *recievedLocation) {
        
        Track *trackObj = [NSEntityDescription insertNewObjectForEntityForName:@"Track" inManagedObjectContext:[[CoreDataManager sharedInstanceCoreData] managedObjectContext]];
        
        [trackObj saveTrackInExternalFileWithLocation:recievedLocation];
        
        [[CoreDataManager sharedInstanceCoreData] saveContext];
        NSLog(@"Track is downloaded successfully %@", trackObj.download);
  
    }];
   
}

#pragma mark - Methods for Installing and Establishing

- (void)updateTime
{
    self.currentTimeSlider.maximumValue = CMTimeGetSeconds(self.audioPlayer.currentItem.asset.duration);
//    NSLog(@"max slider value %f ----------   min value = %f", self.currentTimeSlider.maximumValue, self.currentTimeSlider.minimumValue); 
    [self.currentTimeSlider setValue:CMTimeGetSeconds(self.audioPlayer.currentTime) animated:YES];
    
//    Access Current Time
    NSTimeInterval aCurrentTime = CMTimeGetSeconds(self.audioPlayer.currentTime);
    
//    update UI with currentTime;
    self.playedTime.text = [NSString stringWithFormat:@"%02li:%02li", (long)aCurrentTime/60, (long)aCurrentTime %60];
    
    NSArray *dividedString = [self.trackTitle.text componentsSeparatedByString:@"-"];
    
    NSDictionary *info = @{MPNowPlayingInfoPropertyElapsedPlaybackTime : self.playedTime.text,
                                  MPMediaItemPropertyPlaybackDuration  : @(self.currentTimeSlider.maximumValue),
                                              MPMediaItemPropertyTitle : [dividedString objectAtIndex:0],
                                             MPMediaItemPropertyArtist : [dividedString objectAtIndex:1]
                           };
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:info];
}

- (void)updateTrackTitle:(id <PPTrackInfoProtocol>)song
{
    NSString *artist = song.artist;
    NSString *track = song.title;
    
    self.trackTitle.text = [NSString stringWithFormat:@"%@ - %@", artist, track];
}

- (void)setupConstraints
{
    NSDictionary *views = NSDictionaryOfVariableBindings(_musicView, _currentTimeSlider, _playedTime, _trackTitle, _imageView);
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[_musicView(280)]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_musicView(50)]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
    
    NSLayoutConstraint *verticalConstraintForView = [NSLayoutConstraint constraintWithItem:self.musicView
                                                                                 attribute:NSLayoutAttributeCenterX
                                                                                 relatedBy:NSLayoutRelationEqual
                                                                                    toItem:self.view
                                                                                 attribute:NSLayoutAttributeCenterX
                                                                                multiplier:1
                                                                                  constant:0];
    [self.view addConstraint:verticalConstraintForView];
    
    NSLayoutConstraint *horizontalConstraintForView = [NSLayoutConstraint constraintWithItem:self.musicView
                                                                                   attribute:NSLayoutAttributeCenterY
                                                                                   relatedBy:NSLayoutRelationEqual
                                                                                      toItem:self.view
                                                                                   attribute:NSLayoutAttributeBottom
                                                                                  multiplier:0.8
                                                                                    constant:0];
    [self.view addConstraint:horizontalConstraintForView];
    
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
    
    NSLayoutConstraint *verticalConstraintForTime =  [NSLayoutConstraint constraintWithItem:self.playedTime
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
    
    NSLayoutConstraint *widthForImageView =         [NSLayoutConstraint constraintWithItem:self.imageView
                                                                                 attribute:NSLayoutAttributeWidth
                                                                                 relatedBy:NSLayoutRelationEqual
                                                                                    toItem:self.view
                                                                                 attribute:NSLayoutAttributeWidth
                                                                                multiplier:1.0
                                                                                  constant:0];
    [self.view addConstraint:widthForImageView];
    
    NSLayoutConstraint *heightForImageView =        [NSLayoutConstraint constraintWithItem:self.imageView
                                                                                 attribute:NSLayoutAttributeHeight
                                                                                 relatedBy:NSLayoutRelationEqual
                                                                                    toItem:self.view
                                                                                 attribute:NSLayoutAttributeHeight
                                                                                multiplier:1.0
                                                                                  constant:0];
    [self.view addConstraint:heightForImageView];
    
}

- (void)createPlayerWithURL:(NSURL *)url
{
    AVPlayerItem *avPlayerItem =[[AVPlayerItem alloc] initWithURL:url];
    self.audioPlayer = [[AVPlayer alloc] initWithPlayerItem:avPlayerItem];
    [self.audioPlayer play];
    
    self.musicView.playButton.selected = YES;
    
    __weak typeof(self) weakSelf = self;
    void (^observerBlock)(CMTime time) = ^(CMTime time) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf updateTime];
           
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
        });
    };
    
    self.timeObserver = [self.audioPlayer addPeriodicTimeObserverForInterval:CMTimeMake(1, 1)
                                                                       queue:dispatch_queue_create("CHI.ProstoPleerApp.avplayer", NULL)
                                                                  usingBlock:observerBlock];
}

- (void)playerItemDidReachEnd:(NSNotification *)notification
{
    [self nextTrackAction];
}

- (void)addToFavorites:(UIButton *)sender
{
    NSArray *result = [[CoreDataManager sharedInstanceCoreData] fetchObjects];
    Track *trackObj = [Track objectWithTrackID:self.info.text_id];
    
    if ([result containsObject:trackObj])
    {
        UIAlertController *alert = [UIAlertController createAlertWithMessage:NSLocalizedString(@"AlreadyAdded", nil)];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    trackObj = [NSEntityDescription insertNewObjectForEntityForName:@"Track" inManagedObjectContext:[[CoreDataManager sharedInstanceCoreData] managedObjectContext]];
    
    [trackObj createTrackWithTrackInfoObject:self.info];
    
    [[CoreDataManager sharedInstanceCoreData] saveContext];
    
    UIAlertController *alert = [UIAlertController createAlertWithMessage:NSLocalizedString(@"SuccessfullyAdded", nil)];
    [self presentViewController:alert animated:YES completion:nil];

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