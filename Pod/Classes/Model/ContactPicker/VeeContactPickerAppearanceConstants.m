//
//  Created by Andrea Cipriani on 14/03/16.
//  Copyright © 2016 Code Atlas SRL. All rights reserved.
//

#import "VeeContactPickerAppearanceConstants.h"

@implementation VeeContactPickerAppearanceConstants

#pragma mark - Singleton

+ (id)sharedInstance
{
    static VeeContactPickerAppearanceConstants* sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] initWithDefaultConstants];
    });
    return sharedInstance;
}

- (instancetype)initWithDefaultConstants
{
    if (self) {
        [self loadVeeContactPickerDefaultConstants];
        [self loadTableViewDefaultConstants];
        [self loadVeeContactTableViewCellDefaultConstants];
    }
    return self;
}

- (void)loadTableViewDefaultConstants
{
    _veeContactCellNibName = @"VeeContactUITableViewCell";
    _veeContactCellIdentifier = @"VeeContactCell";
    _veeContactCellHeight = 66.0;
}

-(void)loadVeeContactPickerDefaultConstants
{
    _cancelBarButtonItemTintColor = [self iOS7DefaultAccentBlueColor];
    _navigationBarTintColor = [self iOS7DefaultAccentBlueColor];
    _navigationBarBarTintColor = [UIColor whiteColor];
    _navigationBarTranslucent = NO;
    _veeContactEmptyViewLabelFont = [UIFont systemFontOfSize:15];
    _veeContactEmptyViewLabelTextColor = [UIColor blackColor];
    _veeContactPickerTableViewBottomMargin = 0;
}

- (void)loadVeeContactTableViewCellDefaultConstants
{
    _veeContactCellImageDiameter = @(50.0);
    _veeContactCellPrimaryLabelFont = [UIFont systemFontOfSize:17];
    _veeContactCellBackgroundColor = [UIColor whiteColor];
    _veeContactCellBackgroundColorWhenSelected = [UIColor lightGrayColor];
}


-(UIColor*)iOS7DefaultAccentBlueColor
{
    return [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
}

@end
