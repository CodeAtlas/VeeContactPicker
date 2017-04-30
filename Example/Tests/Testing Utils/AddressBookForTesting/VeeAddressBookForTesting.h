//
//  Created by Andrea Cipriani on 08/03/16.
//  Copyright © 2016 Code Atlas SRL. All rights reserved.
//

#import <Foundation/Foundation.h>
@import AddressBook;

@interface VeeAddressBookForTesting : NSObject

- (void)addVeeTestingContactsToAddressBook;
- (void)deleteVeeTestingContactsFromAddressBook;
@property (NS_NONATOMIC_IOSONLY, readonly) ABRecordRef abRecordRefOfCompleteContact CF_RETURNS_NOT_RETAINED;
@property (NS_NONATOMIC_IOSONLY, readonly) ABRecordRef abRecordRefOfUnifiedContact CF_RETURNS_NOT_RETAINED;
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSArray *abRecordRefsOfTestingContacts;
//- (void)exportABtoVCF:(NSString*)vcfFileName;

@end
