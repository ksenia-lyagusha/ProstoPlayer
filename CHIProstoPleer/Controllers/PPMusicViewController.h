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

#import "PPTopSongsListViewController.h"

@interface PPMusicViewController : UIViewController

@property (strong, nonatomic) NSDictionary *trackInfo;
@property (weak, nonatomic) id <PPTopSongsListViewControllerDelegate>delegate;
@property (nonatomic, strong) AVPlayer *audioPlayer;

@end
