//
//  Created by Andrea Cipriani on 22/03/16.
//  Copyright © 2016 Code Atlas SRL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VeeContactProt.h"
@import AddressBook;

@interface VeeContactFactory : NSObject

+(NSArray<id<VeeContactProt>>*)veeContactsFromAddressBook:(ABAddressBookRef)addressBook;

@end
