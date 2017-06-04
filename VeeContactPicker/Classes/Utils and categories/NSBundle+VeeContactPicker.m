#import "NSBundle+VeeContactPicker.h"
#import "VeeCommons.h"

@implementation NSBundle (VeeContactPicker)

+ (NSBundle *)veeContactPickerBundle {
    return [NSBundle bundleForClass:VeeCommons.class];
}

@end
