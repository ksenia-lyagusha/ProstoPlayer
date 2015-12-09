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
        [playButton setImage:[UIImage imageNamed:@"play"]  forState:UIControlStateNormal];
        [playButton addTarget:self action:@selector(playAction:) forControlEvents:UIControlEventTouchUpInside];
        playButton.translatesAutoresizingMaskIntoConstraints = NO;
        
        UIButton *nextTrack = [[UIButton alloc] init];
        [nextTrack setImage:[UIImage imageNamed:@"next"] forState:UIControlStateNormal];
        [nextTrack addTarget:self action:@selector(nextTrackAction:) forControlEvents:UIControlEventTouchUpInside];
        nextTrack.translatesAutoresizingMaskIntoConstraints = NO;
        
        UIButton *previousTrack = [[UIButton alloc] init];
        [previousTrack setImage:[UIImage imageNamed:@"previous"] forState:UIControlStateNormal];
        [previousTrack addTarget:self action:@selector(previousTrackAction:) forControlEvents:UIControlEventTouchUpInside];
        previousTrack.translatesAutoresizingMaskIntoConstraints = NO;
        
        UIButton *pauseButton = [[UIButton alloc] init];
        [pauseButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
        [pauseButton addTarget:self action:@selector(pauseAction:) forControlEvents:UIControlEventTouchUpInside];
        pauseButton.translatesAutoresizingMaskIntoConstraints = NO;
    
        [self addSubview:playButton];
        [self addSubview:nextTrack];
        [self addSubview:previousTrack];
        [self addSubview:pauseButton];        
        
        NSDictionary *views = NSDictionaryOfVariableBindings(playButton, nextTrack, previousTrack, pauseButton);
        NSDictionary *metrics = @{@"sideSpacing" : @20.0, @"verticalSpacing" : @250.0, @"width" : @50.0, @"hight" : @50};
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-verticalSpacing-[nextTrack(hight)]"
                                                                     options:0
                                                                     metrics:metrics
                                                                       views:views]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-verticalSpacing-[playButton(hight)]"
                                                                     options:0
                                                                     metrics:metrics
                                                                       views:views]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-verticalSpacing-[previousTrack(hight)]"
                                                                     options:0
                                                                     metrics:metrics
                                                                       views:views]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-verticalSpacing-[pauseButton(hight)]"
                                                                     options:0
                                                                     metrics:metrics
                                                                       views:views]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-sideSpacing-[previousTrack(width)]-sideSpacing-[playButton(width)]-sideSpacing-[pauseButton(width)]-sideSpacing-[nextTrack(width)]"
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
        [self.delegate playAction:self];
    }
}

- (void)nextTrackAction:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(nextTrackAction:)])
    {
        [self.delegate nextTrackAction:self];
    }
}

- (void)previousTrackAction:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(previousTrackAction:)])
    {
        [self.delegate previousTrackAction:self];
    }
}

- (void)pauseAction:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(pauseAction:)])
    {
        [self.delegate pauseAction:self];
    }
}

@end
