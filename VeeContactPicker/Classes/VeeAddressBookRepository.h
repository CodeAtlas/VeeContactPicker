//
//  Created by Andrea Cipriani on 14/03/16.
//  Copyright © 2016 Code Atlas SRL. All rights reserved.
//

#import <AddressBook/AddressBook.h>
#import <Foundation/Foundation.h>
#import "VeeContact.h"

@class VeeAddressBookRepositoryImporter;

@interface VeeAddressBookRepository : NSObject

#pragma mark - Singleton

+ (VeeAddressBookRepository*)sharedInstance;

#pragma mark - Public methods

- (NSArray<VeeContact*>*)veeContacts;
- (NSArray<VeeContact*>*)veeContactsForAddressBook:(ABAddressBookRef)addressBook;
- (VeeContact*)veeContactForRecordId:(NSNumber*)recordId;

@end
