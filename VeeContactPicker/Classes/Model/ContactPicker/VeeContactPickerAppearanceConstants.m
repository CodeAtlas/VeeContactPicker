#import "VeeContactPickerAppearanceConstants.h"

NS_ASSUME_NONNULL_BEGIN

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
    self.veeContactCellIdentifier = @"VeeContactTableViewCell";
    self.veeContactCellHeight = 66.0;
}

-(void)loadVeeContactPickerDefaultConstants
{
    self.cancelBarButtonItemTintColor = [self iOS7DefaultAccentBlueColor];
    self.navigationBarTintColor = [self iOS7DefaultAccentBlueColor];
    self.navigationBarBarTintColor = [UIColor whiteColor];
    self.navigationBarTranslucent = NO;
    self.veeContactEmptyViewLabelFont = [UIFont systemFontOfSize:15];
    self.veeContactEmptyViewLabelTextColor = [UIColor blackColor];
    self.veeContactPickerTableViewBottomMargin = 0;
}

- (void)loadVeeContactTableViewCellDefaultConstants
{
    self.veeContactCellImageDiameter = @(50.0);
    self.veeContactCellPrimaryLabelFont = [UIFont systemFontOfSize:17];
    self.veeContactCellBackgroundColor = [UIColor whiteColor];
    self.veeContactCellBackgroundColorWhenSelected = [UIColor lightGrayColor];
}


-(UIColor*)iOS7DefaultAccentBlueColor
{
    return [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
}

@end

NS_ASSUME_NONNULL_END
