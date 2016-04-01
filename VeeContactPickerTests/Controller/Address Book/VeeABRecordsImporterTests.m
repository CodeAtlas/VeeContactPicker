//
//  Created by Andrea Cipriani on 23/03/16.
//  Copyright © 2016 Code Atlas SRL. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "VeeABRecordsImporter.h"
@import AddressBook;

@interface VeeABRecordsImporterTests : XCTestCase

@property (nonatomic) ABAddressBookRef addressBook;
@property (nonatomic,assign) NSUInteger numberOfRecordsInAddressBook;

@end

@implementation VeeABRecordsImporterTests

#pragma mark - Methods setup

-(void)setUp
{
    NSAssert(ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized, @"ABAddressBookGetAuthorizationStatus is not authorized!");
    CFErrorRef* cfError = nil;
    _addressBook = ABAddressBookCreateWithOptions(NULL, cfError);
    if (cfError) {
        NSLog(@"Error while creating address book");
    }
    
    _numberOfRecordsInAddressBook = [self numberOfRecordsInAddressBook:_addressBook];
}

- (void)testNumberOfImportedRecords
{
    VeeABRecordsImporter* veeABRecordsImporter = [VeeABRecordsImporter new];
    NSUInteger numberOfImportedRecords = [[veeABRecordsImporter importVeeABRecordsFromAddressBook:_addressBook] count];
    BOOL isNumberOfImportedRecordsCorrect = _numberOfRecordsInAddressBook == numberOfImportedRecords;
    NSAssert(isNumberOfImportedRecordsCorrect, @"Number of imported records is %zd but should be %zd",numberOfImportedRecords,_numberOfRecordsInAddressBook);
}

#pragma mark - Private utils

-(NSUInteger)numberOfRecordsInAddressBook:(ABAddressBookRef)addressBook
{
    NSUInteger numberOfContactsInAddressBook = 0;
    
    NSArray* allSources = (__bridge_transfer NSArray*)(ABAddressBookCopyArrayOfAllSources(addressBook));
    for (int s = 0; s < allSources.count; s++) {
        ABRecordRef source = (__bridge ABRecordRef)(allSources[s]);
        NSArray* peopleInSource = (__bridge NSArray*)ABAddressBookCopyArrayOfAllPeopleInSource(addressBook, source);
        for (int p = 0; p < peopleInSource.count; p++) {
            numberOfContactsInAddressBook++;
        }
    }
    return numberOfContactsInAddressBook;
}

@end
