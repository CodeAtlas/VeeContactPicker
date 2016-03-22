//
//  Created by Andrea Cipriani on 14/03/16.
//  Copyright © 2016 Code Atlas SRL. All rights reserved.
//

#import "VeeABAdaptedRecordsImporter.h"
#import "VeeABRecordAdapter.h"

@implementation VeeABAdaptedRecordsImporter

#pragma mark - Public methods

- (NSArray<VeeABRecordAdapter*>*)importVeeABAdaptedRecordsFromAddressBook:(ABAddressBookRef)addressBook
{
    if (ABAddressBookGetAuthorizationStatus() != kABAuthorizationStatusAuthorized){
        NSLog(@"Can't import ABRepositoryData because ABAuthStatus is not authorized");
        return @[];
    }

    NSArray* allSources = (__bridge_transfer NSArray*)(ABAddressBookCopyArrayOfAllSources(addressBook));
    NSMutableSet<VeeABRecordAdapter*>* adaptedRecords = [NSMutableSet new];

    for (int s = 0; s < allSources.count; s++) {
        ABRecordRef source = (__bridge ABRecordRef)(allSources[s]);
        [adaptedRecords addObjectsFromArray:[self importVeeABRecordsFromSingleSource:source ofAddressBook:addressBook]];
    }
    return [NSArray arrayWithArray:[adaptedRecords allObjects]];
}

- (NSArray<VeeABRecordAdapter*>*)importVeeABRecordsFromSingleSource:(ABRecordRef)source ofAddressBook:(ABAddressBookRef)addressBook
{
    NSMutableArray* abRepositoryOfSingleSourceData = [NSMutableArray new];
    NSArray* peopleInSource = (__bridge NSArray*)ABAddressBookCopyArrayOfAllPeopleInSource(addressBook, source);
    for (int i = 0; i < peopleInSource.count; i++) {
        ABRecordRef abRecord = CFArrayGetValueAtIndex((__bridge CFArrayRef)(peopleInSource), i);
        VeeABRecordAdapter* veeAdaptedRecord = [[VeeABRecordAdapter alloc] initWithLinkedPeopleOfABRecord:abRecord];
        [abRepositoryOfSingleSourceData addObject:veeAdaptedRecord];
    }
    return [NSArray arrayWithArray:abRepositoryOfSingleSourceData];
}

@end
