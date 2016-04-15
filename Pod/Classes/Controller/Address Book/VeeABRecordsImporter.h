//
//  Created by Andrea Cipriani on 14/03/16.
//  Copyright © 2016 Code Atlas SRL. All rights reserved.
//

#import <Foundation/Foundation.h>
@import AddressBook;
@class VeeABRecord;

@interface VeeABRecordsImporter : NSObject

#pragma mark - Public methods

- (NSArray<VeeABRecord*>*)importVeeABRecordsFromAddressBook:(ABAddressBookRef)addressBook;

@end
