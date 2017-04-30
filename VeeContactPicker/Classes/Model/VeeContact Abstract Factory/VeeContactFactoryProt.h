@import Foundation;
@import AddressBook;
#import "VeeContactProt.h"

NS_ASSUME_NONNULL_BEGIN

@protocol VeeContactFactoryProt <NSObject>
+ (NSArray<id<VeeContactProt>>*)veeContactProtsFromAddressBook:(ABAddressBookRef)addressBook;
@end

NS_ASSUME_NONNULL_END
