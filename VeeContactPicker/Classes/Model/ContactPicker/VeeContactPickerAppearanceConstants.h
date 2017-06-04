@import Foundation;
@import UIKit;

NS_ASSUME_NONNULL_BEGIN

@interface VeeContactPickerAppearanceConstants : NSObject

+ (instancetype)sharedInstance; //Initialization with default constants

#pragma mark - Table view Constants

@property (nonatomic, copy) NSString *veeContactCellIdentifier;
@property (nonatomic, assign) NSUInteger veeContactCellHeight;

#pragma mark - VeeContactPicker Appearance Constants

@property (nonatomic, strong) UIColor *cancelBarButtonItemTintColor;
@property (nonatomic, strong) UIColor *navigationBarTintColor;
@property (nonatomic, strong) UIColor *navigationBarBarTintColor;
@property (nonatomic, assign) BOOL navigationBarTranslucent;
@property (nonatomic, strong) UIFont *veeContactEmptyViewLabelFont;
@property (nonatomic, strong) UIColor *veeContactEmptyViewLabelTextColor;
@property (nonatomic, assign) NSUInteger veeContactPickerTableViewBottomMargin;

#pragma mark - VeeContactTableViewCell Appearance Constants

@property (nonatomic, strong) NSNumber *veeContactCellImageDiameter;
@property (nonatomic, strong) UIFont *veeContactCellPrimaryLabelFont;
@property (nonatomic, strong) UIColor *veeContactCellBackgroundColor;
@property (nonatomic, strong) UIColor *veeContactCellBackgroundColorWhenSelected;

@end

NS_ASSUME_NONNULL_END
