//
//  Created by Andrea Cipriani on 22/03/16.
//  Copyright © 2016 Code Atlas SRL. All rights reserved.
//

#import "VeeContactProt.h"
#import <Foundation/Foundation.h>
#import "VeeContactFactoryProt.h"
@import AddressBook;

@interface VeeContactFactory : NSObject <VeeContactFactoryProt>

+ (NSArray<id<VeeContactProt> >*)veeContactProtsFromAddressBook:(ABAddressBookRef)addressBook;

@end
