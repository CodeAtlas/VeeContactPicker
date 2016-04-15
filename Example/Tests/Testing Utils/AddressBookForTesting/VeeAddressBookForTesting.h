//
//  Created by Andrea Cipriani on 08/03/16.
//  Copyright © 2016 Code Atlas SRL. All rights reserved.
//

#import <Foundation/Foundation.h>
@import AddressBook;

@interface VeeAddressBookForTesting : NSObject

- (void)addVeeTestingContactsToAddressBook;
- (void)deleteVeeTestingContactsFromAddressBook;
- (ABRecordRef)abRecordRefOfCompleteContact;
- (ABRecordRef)abRecordRefOfUnifiedContact;
- (NSArray*)abRecordRefsOfTestingContacts;
//- (void)exportABtoVCF:(NSString*)vcfFileName;

@end
