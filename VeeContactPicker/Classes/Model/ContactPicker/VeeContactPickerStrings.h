@import Foundation;

NS_ASSUME_NONNULL_BEGIN

@interface VeeContactPickerStrings : NSObject

- (instancetype)initWithDefaultStrings NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithNavigationBarTitle:(NSString*)navigationBarTitle cancelButtonTitle:(NSString*)cancelButtonTitle emptyViewLabelText:(NSString*)emptyViewLabelText NS_DESIGNATED_INITIALIZER;
+ (VeeContactPickerStrings*)defaultStrings;

@property (nonatomic, strong) NSString* navigationBarTitle;
@property (nonatomic, strong) NSString* cancelButtonTitle;
@property (nonatomic, strong) NSString* emptyViewLabelText;

@end

NS_ASSUME_NONNULL_END
