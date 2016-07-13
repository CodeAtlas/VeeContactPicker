#import <Foundation/Foundation.h>

@interface VeeContactPickerStrings : NSObject

- (instancetype)initWithDefaultStrings;
- (instancetype)initWithNavigationBarTitle:(NSString*)navigationBarTitle cancelButtonTitle:(NSString*)cancelButtonTitle emptyViewLabelText:(NSString*)emptyViewLabelText;
+ (VeeContactPickerStrings*)defaultStrings;

@property (nonatomic, strong) NSString* navigationBarTitle;
@property (nonatomic, strong) NSString* cancelButtonTitle;
@property (nonatomic, strong) NSString* emptyViewLabelText;

@end
