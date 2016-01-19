//
//  MusicView.m
//  ProstoPleerApp
//
//  Created by CHI Software on 12/8/15.
//  Copyright © 2015 CHI Software. All rights reserved.
//

#import "MusicView.h"

@interface MusicView ()
@property (strong, nonatomic) UIVisualEffectView *effectView;
@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation MusicView

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        
        self.playButton = [[UIButton alloc] init];
        [self.playButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        [self.playButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateSelected];
        [self.playButton addTarget:self action:@selector(playAction:) forControlEvents:UIControlEventTouchUpInside];
        self.playButton.translatesAutoresizingMaskIntoConstraints = NO;
        
        self.nextTrack = [[UIButton alloc] init];
        [self.nextTrack setImage:[UIImage imageNamed:@"next"] forState:UIControlStateNormal];
        [self.nextTrack addTarget:self action:@selector(nextTrackAction:) forControlEvents:UIControlEventTouchUpInside];
        self.nextTrack.translatesAutoresizingMaskIntoConstraints = NO;
        
        self.previousTrack = [[UIButton alloc] init];
        [self.previousTrack setImage:[UIImage imageNamed:@"previous"] forState:UIControlStateNormal];
        [self.previousTrack addTarget:self action:@selector(previousTrackAction:) forControlEvents:UIControlEventTouchUpInside];
        self.previousTrack.translatesAutoresizingMaskIntoConstraints = NO;
        
        self.currentTimeSlider = [[UISlider alloc] init];
        self.currentTimeSlider.continuous = YES;
        [self.currentTimeSlider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
        self.currentTimeSlider.translatesAutoresizingMaskIntoConstraints = NO;
        
        self.playedTime = [[UILabel alloc] init];
        self.playedTime.translatesAutoresizingMaskIntoConstraints = NO;
        
        self.trackTitle = [[UILabel alloc] init];
        self.trackTitle.lineBreakMode = NSLineBreakByWordWrapping;
        self.trackTitle.numberOfLines = 0;
        self.trackTitle.textAlignment = NSTextAlignmentCenter;
        self.trackTitle.translatesAutoresizingMaskIntoConstraints = NO;
        
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        self.effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
        self.effectView.translatesAutoresizingMaskIntoConstraints = NO;
        
        self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background"]];
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
        self.imageView.layer.masksToBounds = YES;
        
        [self addSubview:self.imageView];
        [self addSubview:self.effectView];
        [self.effectView addSubview:self.playButton];
        [self.effectView addSubview:self.nextTrack];
        [self.effectView addSubview:self.previousTrack];
        
        [self addSubview:self.currentTimeSlider];
        [self addSubview:self.playedTime];
        [self addSubview:self.trackTitle];

        [self setupConstraints];
    }    
    return self;
}

- (void)setupConstraints
{
    NSDictionary *views = NSDictionaryOfVariableBindings(_currentTimeSlider, _trackTitle, _playButton, _nextTrack, _previousTrack, _effectView, _imageView);
    NSDictionary *metrics = @{@"verticalSpacing" : @80.0, @"hight" : @50, @"width" : @50};
    
    NSLayoutConstraint *xCenterConstraint = [NSLayoutConstraint constraintWithItem:self.playButton
                                                                         attribute:NSLayoutAttributeCenterX
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self
                                                                         attribute:NSLayoutAttributeCenterX
                                                                        multiplier:1.0
                                                                          constant:0];
    [self addConstraint:xCenterConstraint];
    
    NSLayoutConstraint *xRightConstraint = [NSLayoutConstraint constraintWithItem:self.nextTrack
                                                                        attribute:NSLayoutAttributeCenterX
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self
                                                                        attribute:NSLayoutAttributeTrailing
                                                                       multiplier:0.8
                                                                         constant:0];
    [self addConstraint:xRightConstraint];
    
    NSLayoutConstraint *xLeftConstraint = [NSLayoutConstraint constraintWithItem:self.previousTrack
                                                                       attribute:NSLayoutAttributeCenterX
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self
                                                                       attribute:NSLayoutAttributeTrailing
                                                                      multiplier:0.2
                                                                        constant:0];
    [self addConstraint:xLeftConstraint];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_nextTrack(hight)]|"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_playButton(hight)]|"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_previousTrack(hight)]|"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[_nextTrack(width)]"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[_playButton(width)]"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[_previousTrack(width)]"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];
    
    NSLayoutConstraint *horizontalConstraintForSlider = [NSLayoutConstraint constraintWithItem:self.currentTimeSlider
                                                                                     attribute:NSLayoutAttributeCenterY
                                                                                     relatedBy:NSLayoutRelationEqual
                                                                                        toItem:self
                                                                                     attribute:NSLayoutAttributeBottom
                                                                                    multiplier:0.6
                                                                                      constant:0];
    [self addConstraint:horizontalConstraintForSlider];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-30-[_currentTimeSlider]-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_trackTitle(50)]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_trackTitle]-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
    
    NSLayoutConstraint *verticalConstraintForTime =  [NSLayoutConstraint constraintWithItem:self.playedTime
                                                                                  attribute:NSLayoutAttributeCenterX
                                                                                  relatedBy:NSLayoutRelationEqual
                                                                                     toItem:self
                                                                                  attribute:NSLayoutAttributeCenterX
                                                                                 multiplier:1
                                                                                   constant:0];
    [self addConstraint:verticalConstraintForTime];
    
    NSLayoutConstraint *horizontalConstraintForTime = [NSLayoutConstraint constraintWithItem:self.playedTime
                                                                                   attribute:NSLayoutAttributeCenterY
                                                                                   relatedBy:NSLayoutRelationEqual
                                                                                      toItem:self
                                                                                   attribute:NSLayoutAttributeBottom
                                                                                  multiplier:0.65
                                                                                    constant:0];
    [self addConstraint:horizontalConstraintForTime];
    
    NSLayoutConstraint *yCenterConstraintForTitle = [NSLayoutConstraint constraintWithItem:self.trackTitle
                                                                                 attribute:NSLayoutAttributeCenterY
                                                                                 relatedBy:NSLayoutRelationEqual
                                                                                    toItem:self
                                                                                 attribute:NSLayoutAttributeCenterY
                                                                                multiplier:1.0
                                                                                  constant:0];
    [self addConstraint:yCenterConstraintForTitle];
    
    NSLayoutConstraint *xCenterConstraintForTitle = [NSLayoutConstraint constraintWithItem:self.trackTitle
                                                                                 attribute:NSLayoutAttributeCenterX
                                                                                 relatedBy:NSLayoutRelationEqual
                                                                                    toItem:self
                                                                                 attribute:NSLayoutAttributeCenterX
                                                                                multiplier:1.0
                                                                                  constant:0];
    [self addConstraint:xCenterConstraintForTitle];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_effectView(50)]"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:views]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[_effectView(280)]"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:views]];
    
    NSLayoutConstraint *verticalConstraintForView = [NSLayoutConstraint constraintWithItem:self.effectView
                                                                                 attribute:NSLayoutAttributeCenterX
                                                                                 relatedBy:NSLayoutRelationEqual
                                                                                    toItem:self
                                                                                 attribute:NSLayoutAttributeCenterX
                                                                                multiplier:1
                                                                                  constant:0];
    [self addConstraint:verticalConstraintForView];
    
    NSLayoutConstraint *horizontalConstraintForView = [NSLayoutConstraint constraintWithItem:self.effectView
                                                                                   attribute:NSLayoutAttributeCenterY
                                                                                   relatedBy:NSLayoutRelationEqual
                                                                                      toItem:self
                                                                                   attribute:NSLayoutAttributeBottom
                                                                                  multiplier:0.8
                                                                                    constant:0];
    [self addConstraint:horizontalConstraintForView];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_imageView]|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:views]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_imageView]|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:views]];
}

-(void)playAction:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(playAction:)])
    {
        [self.delegate playAction:sender];
    }
}

- (void)nextTrackAction:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(nextTrackAction)])
    {
        [self.delegate nextTrackAction];
    }
}

- (void)previousTrackAction:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(previousTrackAction)])
    {
        [self.delegate previousTrackAction];
    }
}

- (void)sliderAction:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(sliderAction:)])
    {
        [self.delegate sliderAction:sender];
    }
}
@end
