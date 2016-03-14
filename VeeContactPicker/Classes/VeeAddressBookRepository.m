//
//  Created by Andrea Cipriani on 14/03/16.
//  Copyright © 2016 Code Atlas SRL. All rights reserved.
//

#import "VeeAddressBookRepository.h"
#import "VeeAddressBookRepositoryImporter.h"

@interface VeeAddressBookRepository ()

@property (nonatomic, strong) NSArray<VeeContact*>* veeContacts;
@property (nonatomic, strong) NSDictionary<NSNumber*,VeeContact*>* veeContactsForRecordIds;

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
    _veeContacts = [abRepositoryImporter importVeeContactsFromAddressBook:addressBook];
    _veeContactsForRecordIds = [self veeContactsForRecordIds:_veeContacts];
    if (addressBook){
        CFRelease(addressBook);
    }
}

-(void)initializeABRepositoryDataWithAddressBook:(ABAddressBookRef)addressBook
{
    VeeAddressBookRepositoryImporter* abRepositoryImporter = [VeeAddressBookRepositoryImporter new];
    _veeContacts = [abRepositoryImporter importVeeContactsFromAddressBook:addressBook];
    _veeContactsForRecordIds = [self veeContactsForRecordIds:_veeContacts];
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

-(NSDictionary<NSNumber*,VeeContact*>*)veeContactsForRecordIds:(NSArray<VeeContact*>*)veeContacts
{
    NSMutableDictionary<NSNumber*,VeeContact*>*veeContactsForRecordIdsMutable = [NSMutableDictionary new];
    for (VeeContact* veeContact in veeContacts){
        for (NSNumber* recordId in veeContact.recordIds){
            [veeContactsForRecordIdsMutable setObject:veeContact forKey:recordId];
        }
    }
    return [NSDictionary dictionaryWithDictionary:veeContactsForRecordIdsMutable];
}

- (VeeContact*)veeContactForRecordId:(NSNumber*)recordId
{
    if (!_veeContactsForRecordIds){
        [self initializeABRepositoryData];
    }
    return _veeContactsForRecordIds[recordId];
}

@end