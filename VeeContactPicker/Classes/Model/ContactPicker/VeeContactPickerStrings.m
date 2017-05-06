#import "VeeContactPickerStrings.h"

NS_ASSUME_NONNULL_BEGIN

@implementation VeeContactPickerStrings

- (instancetype)initWithDefaultStrings
{
    self = [super init];
    if (self) {
        _navigationBarTitle = @"Choose a contact";
        _navigationBarTitleForMultipleContacts = @"Choose contacts";
        _cancelButtonTitle = @"Cancel";
        _emptyViewLabelText = @"There are no contacts to display";
    }
    return self;
}

+ (VeeContactPickerStrings*)defaultStrings
{
    VeeContactPickerStrings *veeContactPickerDefaultStrings = [[VeeContactPickerStrings alloc] initWithDefaultStrings];
    return veeContactPickerDefaultStrings;
}

- (instancetype)initWithNavigationBarTitle:(NSString*)navigationBarTitle cancelButtonTitle:(NSString*)cancelButtonTitle emptyViewLabelText:(NSString*)emptyViewLabelText;
{
    self = [super init];
    if (self) {
        _navigationBarTitle = navigationBarTitle;
        _cancelButtonTitle = cancelButtonTitle;
        _emptyViewLabelText = emptyViewLabelText;
    }
    return self;
}

@end

NS_ASSUME_NONNULL_END
