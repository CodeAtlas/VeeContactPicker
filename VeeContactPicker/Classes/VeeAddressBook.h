//
//  Created by Andrea Cipriani on 14/03/16.
//  Copyright © 2016 Code Atlas SRL. All rights reserved.
//

#import <Foundation/Foundation.h>
@import AddressBook;

@interface VeeAddressBook : NSObject

+ (BOOL)hasABPermissions;
+ (void)askABPermissionsIfNeeded:(ABAddressBookRef)addressBookRef;

@end
