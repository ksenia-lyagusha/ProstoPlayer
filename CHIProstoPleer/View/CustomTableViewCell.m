//
//  CustomTableViewCell.m
//  ProstoPleerApp
//
//  Created by CHI Software on 19.01.16.
//  Copyright © 2016 CHI Software. All rights reserved.
//

#import "CustomTableViewCell.h"

@implementation CustomTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.customTextLabel = [[UILabel alloc] init];
        self.customTextLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.customTextLabel.numberOfLines = 0;
        
        self.customDetailTextLabel = [[UILabel alloc] init];
        self.customDetailTextLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.customDetailTextLabel.numberOfLines = 0;
        self.customDetailTextLabel.textColor = [UIColor grayColor];
        self.customDetailTextLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightLight];
        
        [self addSubview:self.customTextLabel];
        [self addSubview:self.customDetailTextLabel];
                
        [self setupConstraints];
    }
    return self;
}

- (void)setupConstraints
{
    NSDictionary *views = NSDictionaryOfVariableBindings(_customDetailTextLabel, _customTextLabel);
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_customTextLabel]-[_customDetailTextLabel]->=10-|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:views]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_customTextLabel]-|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:views]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_customDetailTextLabel]-|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:views]];
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end