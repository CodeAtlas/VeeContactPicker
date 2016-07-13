#import "VeeContactProt.h"
#import <Foundation/Foundation.h>
#import "VeeContactFactoryProt.h"
@import AddressBook;

@interface VeeContactFactory : NSObject <VeeContactFactoryProt>

+ (NSArray<id<VeeContactProt> >*)veeContactProtsFromAddressBook:(ABAddressBookRef)addressBook;

@end
