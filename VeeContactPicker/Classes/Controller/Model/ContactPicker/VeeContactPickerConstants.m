//
//  Created by Andrea Cipriani on 14/03/16.
//  Copyright © 2016 Code Atlas SRL. All rights reserved.
//

#import "VeeContactPickerConstants.h"

@implementation VeeContactPickerConstants

#pragma mark - Singleton

+ (id)sharedInstance
{
    static VeeContactPickerConstants* sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] initWithDefaultConstants];
    });
    return sharedInstance;
}

- (instancetype)initWithDefaultConstants
{
    if (self) {
        [self loadTableViewDefaultConstants];
        [self loadVeeContactTableViewCellDefaultConstants];
    }
    return self;
}

- (void)loadTableViewDefaultConstants
{
    _veeContactCellNibName = @"VeeContactUITableViewCell";
    _veeContactCellIdentifier = @"VeeContactCell"; //Also referenced into the xib
    _veeContactCellHeight = 60.0;
}

- (void)loadVeeContactTableViewCellDefaultConstants
{
    _veeContactCellImageDiameter = @(50.0);
    _veeContactCellPrimaryLabelFont = [UIFont systemFontOfSize:17];
    _veeContactCellSecondaryLabelFont = [UIFont systemFontOfSize:15];
    _veeContactCellBackgroundColor = [UIColor whiteColor];
    _veeContactCellBackgroundColorWhenSelected = [UIColor lightGrayColor];
}

@end
