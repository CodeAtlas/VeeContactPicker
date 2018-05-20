@import Foundation;

NS_ASSUME_NONNULL_BEGIN

@interface VeeContactPickerStrings : NSObject

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithDefaultStrings;
- (instancetype)initWithNavigationBarTitle:(NSString *)navigationBarTitle
                         cancelButtonTitle:(NSString *)cancelButtonTitle
                        emptyViewLabelText:(NSString *)emptyViewLabelText;
- (instancetype)initWithNavigationBarTitle:(NSString *)navigationBarTitle
                         cancelButtonTitle:(NSString *)cancelButtonTitle
                        emptyViewLabelText:(NSString *)emptyViewLabelText
                           doneButtonTitle:(NSString *)doneButtonTitle;

+ (VeeContactPickerStrings *)defaultStrings;

@property (nonatomic, strong) NSString *navigationBarTitle;
@property (nonatomic, strong) NSString *navigationBarTitleForMultipleContacts;
@property (nonatomic, strong) NSString *cancelButtonTitle;
@property (nonatomic, strong) NSString *doneButtonTitle;
@property (nonatomic, strong) NSString *searchBarPlaceholder;
@property (nonatomic, strong) NSString *emptyViewLabelText;

@end

NS_ASSUME_NONNULL_END
