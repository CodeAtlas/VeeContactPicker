//
//  Created by Andrea Cipriani on 14/12/15.
//  Copyright © 2015 Code Atlas SRL. All rights reserved.
//

#import "VeeContactUITableViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "VeeContactPickerConstants.h"

@interface VeeContactUITableViewCell()

@end

@implementation VeeContactUITableViewCell

- (void)awakeFromNib
{
    _contactImageViewWidthConstraint.constant = [[[VeeContactPickerConstants sharedInstance] veeContactCellImageDiameter] floatValue];
    _contactImageViewHeightConstraint.constant = [[[VeeContactPickerConstants sharedInstance] veeContactCellImageDiameter] floatValue];
    _contactImageView.layer.cornerRadius = [[[VeeContactPickerConstants sharedInstance] veeContactCellImageDiameter] floatValue] / 2;
    _primaryLabel.font = [[VeeContactPickerConstants sharedInstance] veeContactCellPrimaryLabelFont];
    _secondaryLabel.font = [[VeeContactPickerConstants sharedInstance] veeContactCellSecondaryLabelFont];
    self.backgroundColor = [[VeeContactPickerConstants sharedInstance] veeContactCellBackgroundColor];

    UIView* backgroundView = [UIView new];
    backgroundView.backgroundColor = [[VeeContactPickerConstants sharedInstance] veeContactCellBackgroundColorWhenSelected];
    self.selectedBackgroundView = backgroundView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    //Avoid background color disappering when selecting cell, see http://stackoverflow.com/questions/5222736/uiview-backgroundcolor-disappears-when-uitableviewcell-is-selected
    
    UIColor* backgroundColor = _contactImageView.backgroundColor;
    [super setSelected:selected animated:animated];
    _contactImageView.backgroundColor = backgroundColor;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    //Avoid background color disappering when selecting cell, see http://stackoverflow.com/questions/5222736/uiview-backgroundcolor-disappears-when-uitableviewcell-is-selected
    
    UIColor* backgroundColor = _contactImageView.backgroundColor;
    [super setHighlighted:highlighted animated:animated];
    _contactImageView.backgroundColor = backgroundColor;
}

@end
