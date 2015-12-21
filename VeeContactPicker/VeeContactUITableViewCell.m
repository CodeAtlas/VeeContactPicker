//
//  VeeContactUITableViewCell.m
//  VeeContactPicker
//
//  Created by Andrea Cipriani on 14/12/15.
//  Copyright © 2015 Code Atlas SRL. All rights reserved.
//

#import "VeeContactUITableViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation VeeContactUITableViewCell

- (void)awakeFromNib {
    //Set contact image view corner radius to be circular
    _contactImageView.layer.cornerRadius = _contactImageView.frame.size.height / 2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    //Avoid background color disappering, see http://stackoverflow.com/questions/5222736/uiview-backgroundcolor-disappears-when-uitableviewcell-is-selected
    UIColor *backgroundColor = _contactImageView.backgroundColor;
    [super setSelected:selected animated:animated];
    _contactImageView.backgroundColor = backgroundColor;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    //Avoid background color disappering, see http://stackoverflow.com/questions/5222736/uiview-backgroundcolor-disappears-when-uitableviewcell-is-selected
    UIColor *backgroundColor = _contactImageView.backgroundColor;
    [super setHighlighted:highlighted animated:animated];
    _contactImageView.backgroundColor = backgroundColor;
}

@end
