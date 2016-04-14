//
//  Created by Andrea Cipriani on 28/03/16.
//  Copyright © 2016 Code Atlas SRL. All rights reserved.
//

#import "VeeContactCellConfiguration.h"
#import "VeeContactUITableViewCell.h"
#import "UILabel+Boldify.h"
#import "VeeContactPickerOptions.h"
#import "UIImageView+AGCInitials.h"
#import "VeeCommons.h"

@interface VeeContactCellConfiguration ()

@property (nonatomic,strong) VeeContactPickerOptions* veeContactPickerOptions;

@end

@implementation VeeContactCellConfiguration

#pragma mark - Initializers

- (instancetype)initWithVeePickerOptions:(VeeContactPickerOptions*)veeContactPickerOptions
{
    self = [super init];
    if (self) {
        _veeContactPickerOptions = veeContactPickerOptions;
    }
    return self;
}

#pragma mark - Public Methods

- (void)configureCell:(VeeContactUITableViewCell*)veeContactUITableViewCell forVeeContact:(id<VeeContactProt>)veeContact
{
    [self configureCellInitialValues:veeContactUITableViewCell];
    [self configureCellLabels:veeContactUITableViewCell forVeeContact:veeContact];
    [self configureCellImage:veeContactUITableViewCell forVeeContact:veeContact];
}

#pragma mark - Private utils

- (void)configureCellInitialValues:(VeeContactUITableViewCell*)veeContactUITableViewCell
{
    veeContactUITableViewCell.primaryLabelCenterYAlignmentConstraint.constant = 0;
    veeContactUITableViewCell.secondaryLabel.hidden = YES;
    veeContactUITableViewCell.primaryLabel.text = @"";
    veeContactUITableViewCell.secondaryLabel.text = @"";
    veeContactUITableViewCell.contactImageView.image = nil;
}

- (void)configureCellLabels:(VeeContactUITableViewCell*)veeContactUITableViewCell forVeeContact:(id<VeeContactProt>)veeContact
{
    veeContactUITableViewCell.primaryLabel.text = [veeContact displayName];
    NSArray* nameComponents = [[veeContact displayNameSortedForABOptions] componentsSeparatedByString:@" "];
    BOOL isMissingANameComponent = [VeeCommons isEmpty:[veeContact firstName]] || [VeeCommons isEmpty:[veeContact lastName]];
    BOOL nameComponentsAreLessThanOne = [nameComponents count] < 1;
    NSString* toBoldify;
    if (isMissingANameComponent || nameComponentsAreLessThanOne){
        toBoldify = [veeContact displayName];
    }
    else {
        toBoldify = [nameComponents firstObject];
    }
    [veeContactUITableViewCell.primaryLabel boldSubstring:toBoldify];
}

- (void)configureCellImage:(VeeContactUITableViewCell*)veeContactUITableViewCell forVeeContact:(id<VeeContactProt>)veeContact
{
    if ([veeContact thumbnailImage]) {
        veeContactUITableViewCell.contactImageView.image = [veeContact thumbnailImage];
    }
    else {
        if (_veeContactPickerOptions.showLettersWhenContactImageIsMissing) {
            [veeContactUITableViewCell.contactImageView agc_setImageWithInitialsFromName:[veeContact displayName] separatedByString:@" "];             
        }
        else {
            [veeContactUITableViewCell.contactImageView setImage:_veeContactPickerOptions.contactThumbnailImagePlaceholder];
        }
    }
}

@end
