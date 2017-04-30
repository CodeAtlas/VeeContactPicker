@import Foundation;
@import AddressBook;
#import "VeeContactFactoryProt.h"
#import "VeeContactProt.h"

NS_ASSUME_NONNULL_BEGIN

@interface VeeContactFactory : NSObject <VeeContactFactoryProt>
+ (NSArray<id<VeeContactProt> >*)veeContactProtsFromAddressBook:(ABAddressBookRef)addressBook;
@end

NS_ASSUME_NONNULL_END
