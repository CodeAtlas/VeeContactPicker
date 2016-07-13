#import "VeeContactPickerStrings.h"
#import "NSObject+AGCDescription.h"

@implementation VeeContactPickerStrings

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [self initWithDefaultStrings];
    }
    return self;
}

- (instancetype)initWithDefaultStrings
{
    self = [super init];
    if (self) {
        _navigationBarTitle = @"Choose a contact";
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

#pragma mark - NSObject

- (NSString*)description
{
    return [self agc_description];
}

- (NSString*)debugDescription
{
    return [self agc_debugDescription];
}

@end