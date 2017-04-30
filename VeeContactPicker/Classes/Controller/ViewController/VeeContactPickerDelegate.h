@import Foundation;
#import "VeeContactProt.h"

NS_ASSUME_NONNULL_BEGIN

@protocol VeeContactPickerDelegate <NSObject>
- (void)didSelectContact:(id<VeeContactProt>)abContact;
- (void)didCancelContactSelection;
- (void)didFailToAccessAddressBook;
@end

NS_ASSUME_NONNULL_END
