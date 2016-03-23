//
//  Created by Andrea Cipriani on 14/03/16.
//  Copyright © 2016 Code Atlas SRL. All rights reserved.
//

#import <Foundation/Foundation.h>
@import AddressBook;
@class VeeABRecordAdapter;

@interface VeeABAdaptedRecordsImporter : NSObject

#pragma mark - Public methods

- (NSArray<VeeABRecordAdapter*>*)importVeeABAdaptedRecordsFromAddressBook:(ABAddressBookRef)addressBook;

@end
