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

- (void)playAction:(id)sender;
- (void)nextTrackAction;
- (void)previousTrackAction;
- (void)sliderAction:(id)sender;

@end

@interface MusicView : UIVisualEffectView

@property (weak, nonatomic) id <PPMusicViewDelegate>delegate;

@property (strong, nonatomic) UIButton    *playButton;
@property (strong, nonatomic) UIButton    *nextTrack;
@property (strong, nonatomic) UIButton    *previousTrack;
@property (nonatomic, strong) UISlider    *currentTimeSlider;
@property (nonatomic, strong) UILabel     *playedTime;
@property (nonatomic, strong) UILabel     *trackTitle;

@end
