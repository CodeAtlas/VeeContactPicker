@import Foundation;
#import "VeeContactProt.h"

NS_ASSUME_NONNULL_BEGIN

@protocol VeeContactPickerDelegate <NSObject>
- (void)didSelectContact:(id<VeeContactProt>)veeContact;
- (void)didSelectContacts:(NSArray<id<VeeContactProt>> *)veeContacts;
- (void)didCancelContactSelection;
- (void)didFailToAccessAddressBook;
- (void)willLoadContactData;
- (void)didLoadContactData;
@end

NS_ASSUME_NONNULL_END
