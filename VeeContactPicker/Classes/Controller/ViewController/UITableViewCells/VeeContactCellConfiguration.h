@import Foundation;
#import "VeeContactProt.h"
@class VeeContactTableViewCell;
@class VeeContactPickerOptions;

NS_ASSUME_NONNULL_BEGIN

@interface VeeContactCellConfiguration : NSObject

#pragma mark - Initializers

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithVeePickerOptions:(VeeContactPickerOptions*)veeContactPickerOptions NS_DESIGNATED_INITIALIZER;

#pragma mark - Public Methods

- (void)configureCell:(VeeContactTableViewCell*)cell forVeeContact:(id<VeeContactProt>)veeContact;

@end

NS_ASSUME_NONNULL_END
