#import "VeeContactProt.h"
#import <Foundation/Foundation.h>
@import AddressBook;

@protocol VeeContactFactoryProt <NSObject>

+ (NSArray<id<VeeContactProt> >*)veeContactProtsFromAddressBook:(ABAddressBookRef)addressBook;

@end
