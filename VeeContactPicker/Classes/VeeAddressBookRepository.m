//
//  Created by Andrea Cipriani on 14/03/16.
//  Copyright © 2016 Code Atlas SRL. All rights reserved.
//

#import "VeeAddressBookRepository.h"
#import "VeeAddressBookRepositoryImporter.h"

@interface VeeAddressBookRepository ()

@property (nonatomic, strong) NSArray<VeeContact*>* veeContacts;
@property (nonatomic, strong) NSDictionary* veeContactsForRecordIds;

@end

@implementation VeeAddressBookRepository

#pragma mark - Singleton

+ (VeeAddressBookRepository*)sharedInstance
{
    static VeeAddressBookRepository* sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [VeeAddressBookRepository new];
    });

    return sharedInstance;
}

#pragma mark - Public methods

- (void)initializeABRepositoryData
{
    ABAddressBookRef addressBook = ABAddressBookCreate();
    VeeAddressBookRepositoryImporter* abRepositoryImporter = [VeeAddressBookRepositoryImporter new];
    _veeContacts = [abRepositoryImporter importABRepositoryDataFromAddressBook:addressBook];
    _veeContactsForRecordIds = [abRepositoryImporter abContactsForRecordIds];
    if (addressBook){
        CFRelease(addressBook);
    }
}

-(void)initializeABRepositoryDataWithAddressBook:(ABAddressBookRef)addressBook
{
    VeeAddressBookRepositoryImporter* abRepositoryImporter = [VeeAddressBookRepositoryImporter new];
    _veeContacts = [abRepositoryImporter importABRepositoryDataFromAddressBook:addressBook];
    _veeContactsForRecordIds = [abRepositoryImporter abContactsForRecordIds];
}

- (NSArray<VeeContact*>*)veeContacts;
{
    if (_veeContacts) {
        return _veeContacts;
    }
    [self initializeABRepositoryData];
    return _veeContacts;
}

- (NSArray<VeeContact*>*)veeContactsForAddressBook:(ABAddressBookRef)addressBook
{
    [self initializeABRepositoryDataWithAddressBook:addressBook];
    return _veeContacts;
}

- (VeeContact*)veeContactForRecordId:(NSNumber*)recordId
{
    if (!_veeContactsForRecordIds){
        [self initializeABRepositoryData];
    }
    return _veeContactsForRecordIds[recordId];
}

@end