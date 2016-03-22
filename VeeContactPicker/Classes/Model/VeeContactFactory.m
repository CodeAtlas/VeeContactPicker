//  Created by Andrea Cipriani on 22/03/16.
//  Copyright © 2016 Code Atlas SRL. All rights reserved.
//

#import "VeeContactFactory.h"
#import "VeeABAdaptedRecordsImporter.h"
#import "VeeABRecordAdapter.h"
#import "VeeContact.h"

@implementation VeeContactFactory

+(NSArray<id<VeeContactProt>>*)veeContactsFromAddressBook:(ABAddressBookRef)addressBook
{
    VeeABAdaptedRecordsImporter* abRepositoryImporter = [VeeABAdaptedRecordsImporter new];
    NSArray<VeeABRecordAdapter*>* adaptedABRecords = [abRepositoryImporter importVeeABAdaptedRecordsFromAddressBook:addressBook];
    NSMutableArray* veeContacts = [NSMutableArray new];
    for (VeeABRecordAdapter* abAdaptedRecord in adaptedABRecords){
        id<VeeContactProt> veeContact = [[VeeContact alloc] initWithVeeABRecordAdapter:abAdaptedRecord];
        [veeContacts addObject:veeContact];
    }
    return [NSArray arrayWithArray:veeContacts];
}

@end
