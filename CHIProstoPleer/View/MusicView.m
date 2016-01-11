//
//  MusicView.m
//  ProstoPleerApp
//
//  Created by CHI Software on 12/8/15.
//  Copyright © 2015 CHI Software. All rights reserved.
//

#import "MusicView.h"

@interface MusicView ()

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
        
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
        effectView.translatesAutoresizingMaskIntoConstraints = NO;

        [self addSubview:effectView];
        [self addSubview:self.playButton];
        [self addSubview:self.nextTrack];
        [self addSubview:self.previousTrack];
        
        NSDictionary *views = NSDictionaryOfVariableBindings(_playButton, _nextTrack, _previousTrack, effectView);
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
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[effectView]|"
                                                                     options:0
                                                                     metrics:metrics
                                                                       views:views]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[effectView]|"
                                                                     options:0
                                                                     metrics:metrics
                                                                       views:views]];
        
    }
    
    return self;
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

@end
