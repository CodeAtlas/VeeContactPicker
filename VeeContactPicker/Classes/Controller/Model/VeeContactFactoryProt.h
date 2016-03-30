//
//  Created by Andrea Cipriani on 30/03/16.
//  Copyright © 2016 Code Atlas SRL. All rights reserved.
//

#import "VeeContactProt.h"
#import <Foundation/Foundation.h>
@import AddressBook;

@protocol VeeContactFactoryProt <NSObject>

+ (NSArray<id<VeeContactProt> >*)veeContactProtsFromAddressBook:(ABAddressBookRef)addressBook;

@end
