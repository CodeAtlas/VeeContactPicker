//
//  VeeContactUITableViewCell.h
//  VeeContactPicker
//
//  Created by Andrea Cipriani on 14/12/15.
//  Copyright © 2015 Code Atlas SRL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VeeContactUITableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *contactImageView;
@property (weak, nonatomic) IBOutlet UILabel *firstLabel; //TODO: rename in primaryLabel
@property (weak, nonatomic) IBOutlet UILabel *thirdLabel; //TODO: rename in secondaryLabel

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstLabelCenterYAlignmenetConstraint;

@end
