//
//  Created by Andrea Cipriani on 14/12/15.
//  Copyright © 2015 Code Atlas SRL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VeeContactUITableViewCell : UITableViewCell

#pragma mark - Outlets

@property (weak, nonatomic) IBOutlet UIImageView* contactImageView;
@property (weak, nonatomic) IBOutlet UILabel* primaryLabel;
@property (weak, nonatomic) IBOutlet UILabel* secondaryLabel;

#pragma mark - Constraints

@property (weak, nonatomic) IBOutlet NSLayoutConstraint* primaryLabelCenterYAlignmentConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contactImageViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contactImageViewWidthConstraint;

@end
