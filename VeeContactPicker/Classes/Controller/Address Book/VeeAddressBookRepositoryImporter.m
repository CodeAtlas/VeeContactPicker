//
//  Created by Andrea Cipriani on 14/03/16.
//  Copyright © 2016 Code Atlas SRL. All rights reserved.
//

#import "VeeAddressBookRepositoryImporter.h"
#import "VeeContact.h"

@implementation VeeAddressBookRepositoryImporter

#pragma mark - Public methods

- (NSArray<VeeContact*>*)importVeeContactsFromAddressBook:(ABAddressBookRef)addressBook
{
    if (ABAddressBookGetAuthorizationStatus() != kABAuthorizationStatusAuthorized){
        NSLog(@"Can't import ABRepositoryData because ABAuthStatus is not authorized");
        return @[];
    }

    NSArray* allSources = (__bridge_transfer NSArray*)(ABAddressBookCopyArrayOfAllSources(addressBook));
    NSMutableSet<VeeContact*>* veeContactsWithNoDuplicated = [NSMutableSet new];

    for (int s = 0; s < allSources.count; s++) {
        ABRecordRef source = (__bridge ABRecordRef)(allSources[s]);
        [veeContactsWithNoDuplicated addObjectsFromArray:[self importVeeContactsFromSingleSource:source ofAddressBook:addressBook]];
    }
    return [NSArray arrayWithArray:[veeContactsWithNoDuplicated allObjects]];
}

- (NSArray<VeeContact*>*)importVeeContactsFromSingleSource:(ABRecordRef)source ofAddressBook:(ABAddressBookRef)addressBook
{
    NSMutableArray* abRepositoryOfSingleSourceData = [NSMutableArray new];
    NSArray* peopleInSource = (__bridge NSArray*)ABAddressBookCopyArrayOfAllPeopleInSource(addressBook, source);
    for (int i = 0; i < peopleInSource.count; i++) {
        ABRecordRef abRecord = CFArrayGetValueAtIndex((__bridge CFArrayRef)(peopleInSource), i);
        VeeContact* veeContact = [[VeeContact alloc] initWithLinkedPeopleOfABRecord:abRecord];
        [abRepositoryOfSingleSourceData addObject:veeContact];
    }
    return [NSArray arrayWithArray:abRepositoryOfSingleSourceData];
}

@end
