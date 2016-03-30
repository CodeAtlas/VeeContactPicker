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
        [self loadVeeContactPickerDefaultConstants];
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

-(void)loadVeeContactPickerDefaultConstants
{
    _cancelBarButtonItemTintColor = [self iOS7DefaultAccentBlueColor];
    _navigationBarTintColor = [self iOS7DefaultAccentBlueColor];
    _navigationBarBarTintColor = [self iOS7DefaultNavigationBarColor];
    _navigationBarTranslucent = NO;
    _veeContactEmptyViewLabelFont = [UIFont systemFontOfSize:15];
    _veeContactEmptyViewLabelTextColor = [UIColor blackColor];
}

- (void)loadVeeContactTableViewCellDefaultConstants
{
    _veeContactCellImageDiameter = @(50.0);
    _veeContactCellPrimaryLabelFont = [UIFont systemFontOfSize:17];
    _veeContactCellSecondaryLabelFont = [UIFont systemFontOfSize:15];
    _veeContactCellBackgroundColor = [UIColor whiteColor];
    _veeContactCellBackgroundColorWhenSelected = [UIColor lightGrayColor];
}


-(UIColor*)iOS7DefaultNavigationBarColor
{
    return [UIColor colorWithRed:(247.0f/255.0f) green:(247.0f/255.0f) blue:(247.0f/255.0f) alpha:1];
}

-(UIColor*)iOS7DefaultAccentBlueColor
{
    return [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
}

@end
