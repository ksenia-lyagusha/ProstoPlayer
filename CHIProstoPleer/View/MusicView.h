//
//  MusicView.h
//  ProstoPleerApp
//
//  Created by CHI Software on 12/8/15.
//  Copyright © 2015 CHI Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MusicView;

@protocol PPMusicViewDelegate <NSObject>

- (void)playAction:(UIView *)view;
- (void)nextTrackAction:(UIView *)view;
- (void)previousTrackAction:(UIView *)view;
- (void)pauseAction:(UIView *)view;

@end

@interface MusicView : UIView

@property (weak, nonatomic) id <PPMusicViewDelegate>delegate;

@property (strong, nonatomic) UIButton *playButton;
@property (strong, nonatomic) UIButton *nextTrack;
@property (strong, nonatomic) UIButton *previousTrack;
@property (strong, nonatomic) UIButton *pauseButton;
@property (strong, nonatomic) UILabel  *elapsedTimeLabel;
@property (strong, nonatomic) UILabel  *remainingTimeLabel;

@end
