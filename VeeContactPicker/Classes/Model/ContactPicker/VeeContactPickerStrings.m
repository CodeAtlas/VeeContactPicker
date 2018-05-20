#import "VeeContactPickerStrings.h"

NS_ASSUME_NONNULL_BEGIN

@implementation VeeContactPickerStrings

- (instancetype)initWithDefaultStrings
{
    return [self initWithNavigationBarTitle:@"Choose a contact"
                          cancelButtonTitle:@"Cancel"
                         emptyViewLabelText:@"There are no contacts to display"
                            doneButtonTitle:@"Done"];
}

+ (VeeContactPickerStrings*)defaultStrings
{
    VeeContactPickerStrings *veeContactPickerDefaultStrings = [[VeeContactPickerStrings alloc] initWithDefaultStrings];
    return veeContactPickerDefaultStrings;
}

- (instancetype)initWithNavigationBarTitle:(NSString *)navigationBarTitle
                         cancelButtonTitle:(NSString *)cancelButtonTitle
                        emptyViewLabelText:(NSString *)emptyViewLabelText {
    return [self initWithNavigationBarTitle:navigationBarTitle
                          cancelButtonTitle:cancelButtonTitle
                         emptyViewLabelText:emptyViewLabelText];
}

- (instancetype)initWithNavigationBarTitle:(NSString *)navigationBarTitle
                         cancelButtonTitle:(NSString *)cancelButtonTitle
                        emptyViewLabelText:(NSString *)emptyViewLabelText
                           doneButtonTitle:(NSString *)doneButtonTitle {
    self = [super init];
    if (self) {
        _doneButtonTitle = doneButtonTitle;
        _navigationBarTitle = navigationBarTitle;
        _cancelButtonTitle = cancelButtonTitle;
        _emptyViewLabelText = emptyViewLabelText;
        _searchBarPlaceholder = @"Search";
        _navigationBarTitleForMultipleContacts = @"Choose a contact";
    }
    return self;
}

@end

NS_ASSUME_NONNULL_END
