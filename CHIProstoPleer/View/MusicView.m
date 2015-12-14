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
    if (self) {
        
        UIButton *playButton = [[UIButton alloc] init];
        [playButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        [playButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateSelected];
        [playButton addTarget:self action:@selector(playAction:) forControlEvents:UIControlEventTouchUpInside];
        playButton.translatesAutoresizingMaskIntoConstraints = NO;
        playButton.backgroundColor = [UIColor colorWithRed:255/251 green:255/250 blue:0 alpha:1];
        
        UIButton *nextTrack = [[UIButton alloc] init];
        [nextTrack setImage:[UIImage imageNamed:@"next"] forState:UIControlStateNormal];
        [nextTrack addTarget:self action:@selector(nextTrackAction:) forControlEvents:UIControlEventTouchUpInside];
        nextTrack.translatesAutoresizingMaskIntoConstraints = NO;
        nextTrack.backgroundColor = [UIColor colorWithRed:255/251 green:255/250 blue:0 alpha:1];
        
        UIButton *previousTrack = [[UIButton alloc] init];
        [previousTrack setImage:[UIImage imageNamed:@"previous"] forState:UIControlStateNormal];
        [previousTrack addTarget:self action:@selector(previousTrackAction:) forControlEvents:UIControlEventTouchUpInside];
        previousTrack.translatesAutoresizingMaskIntoConstraints = NO;
        previousTrack.backgroundColor = [UIColor colorWithRed:255/251 green:255/250 blue:0 alpha:1];
        
        [self addSubview:playButton];
        [self addSubview:nextTrack];
        [self addSubview:previousTrack];
        
        NSDictionary *views = NSDictionaryOfVariableBindings(playButton, nextTrack, previousTrack);
        NSDictionary *metrics = @{@"verticalSpacing" : @80.0, @"hight" : @50};
        
        NSLayoutConstraint *xCenterConstraint = [NSLayoutConstraint constraintWithItem:playButton
                                                                             attribute:NSLayoutAttributeCenterX
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:self
                                                                             attribute:NSLayoutAttributeCenterX
                                                                            multiplier:1.0
                                                                              constant:0];
        
        [self addConstraint:xCenterConstraint];
        
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[nextTrack(hight)]-verticalSpacing-|"
                                                                     options:0
                                                                     metrics:metrics
                                                                       views:views]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[playButton(hight)]-verticalSpacing-|"
                                                                     options:0
                                                                     metrics:metrics
                                                                       views:views]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[previousTrack(hight)]-verticalSpacing-|"
                                                                     options:0
                                                                     metrics:metrics
                                                                       views:views]];
        
        NSLayoutConstraint *previousTrackWidth = [NSLayoutConstraint constraintWithItem:previousTrack
                                                                              attribute:NSLayoutAttributeCenterX
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:self
                                                                              attribute:NSLayoutAttributeTrailingMargin
                                                                             multiplier:0.25
                                                                               constant:0];
     
        [self addConstraint:previousTrackWidth];
        
        NSLayoutConstraint *nextTrackWidth = [NSLayoutConstraint constraintWithItem:nextTrack
                                                                          attribute:NSLayoutAttributeCenterX
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self
                                                                          attribute:NSLayoutAttributeTrailingMargin
                                                                         multiplier:0.75
                                                                           constant:0];
        
         [self addConstraint:nextTrackWidth];
     
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
