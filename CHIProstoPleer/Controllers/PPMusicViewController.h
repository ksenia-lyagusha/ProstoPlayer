//
//  PPMusicViewController.h
//  ProstoPleerApp
//
//  Created by Оксана on 25.11.15.
//  Copyright © 2015 CHI Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "ProstoPleerProtocols.h"

#import "PPTopSongsListViewController.h"

@interface PPMusicViewController : UIViewController

@property (strong, nonatomic) id <PPTrackInfoProtocol>info;
@property (weak, nonatomic)   id <PPTopSongsListViewControllerDelegate>delegate;
@property (strong, nonatomic) AVPlayer *audioPlayer;
@property (nonatomic)         NSInteger index;

@end
