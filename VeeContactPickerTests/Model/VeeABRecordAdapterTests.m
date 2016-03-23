//
//  Created by Andrea Cipriani on 22/03/16.
//  Copyright © 2016 Code Atlas SRL. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "VeeAddressBookForTesting.h"
#import "VeeABRecordAdapter.h"
#import "VeeAddressBookForTestingConstants.h"

@interface VeeABRecordAdapterTests : XCTestCase

@property (nonatomic,strong) VeeABRecordAdapter* veeABRecordComplete;
@property (nonatomic,strong) VeeABRecordAdapter* veeABRecordUnified;
@property (nonatomic,strong) NSArray<VeeABRecordAdapter*>* veeABAdaptedRecordsForTesting;

@end

static VeeAddressBookForTesting* veeAddressBookForTesting;

@implementation VeeABRecordAdapterTests

#pragma mark - Class setup

+ (void)setUp
{
    veeAddressBookForTesting = [VeeAddressBookForTesting new];
    [veeAddressBookForTesting deleteVeeTestingContactsFromAddressBook];
    [veeAddressBookForTesting addVeeTestingContactsToAddressBook];
}

+ (void)tearDown
{
    [veeAddressBookForTesting deleteVeeTestingContactsFromAddressBook];
}

#pragma mark - Methods setup

-(void)setUp
{
    _veeABRecordComplete = [[VeeABRecordAdapter alloc] initWithLinkedPeopleOfABRecord:[veeAddressBookForTesting abRecordRefOfCompleteContact]];
    _veeABRecordUnified = [[VeeABRecordAdapter alloc] initWithLinkedPeopleOfABRecord:[veeAddressBookForTesting abRecordRefOfUnifiedContact]];
    _veeABAdaptedRecordsForTesting = [self veeABAdaptedRecordsFromAddressBookForTesting];
}

-(void)tearDown
{
    
}

#pragma mark - Complete Veecontact tests

- (void)testCompleteContactCreation
{
    NSAssert(_veeABRecordComplete, @"Contact Complete creation failed");
}

- (void)testCompleteContactFirstName
{
    BOOL isFirstNameCorrect = [_veeABRecordComplete.firstName isEqualToString:kCompleteVeeContactFirstName];
    NSAssert(isFirstNameCorrect, @"Contact firstName is %@ but should be %@", _veeABRecordComplete.firstName, kCompleteVeeContactFirstName);
}

- (void)testCompleteContactMiddleName
{
    BOOL isMiddleNameCorrect = [_veeABRecordComplete.middleName isEqualToString:kCompleteVeeContactMiddleName];
    NSAssert(isMiddleNameCorrect, @"Contact middleName is %@ but should be %@", _veeABRecordComplete.middleName, kCompleteVeeContactMiddleName);
}

- (void)testCompleteContactLastName
{
    BOOL isLastNameCorrect = [_veeABRecordComplete.lastName isEqualToString:kCompleteVeeContactLastName];
    NSAssert(isLastNameCorrect, @"Contact lastName is %@ but should be %@", _veeABRecordComplete.lastName, kCompleteVeeContactLastName);
}

- (void)testCompleteContactNickname
{
    BOOL isNickNameCorrect = [_veeABRecordComplete.nickname isEqualToString:kCompleteVeeContactNickname];
    NSAssert(isNickNameCorrect, @"Contact nickname is %@ but should be %@", _veeABRecordComplete.nickname, kCompleteVeeContactNickname);
}

- (void)testCompleteContactOrganizationName
{
    BOOL isveeContactCompleteOrganizationNameCorrect = [_veeABRecordComplete.organizationName isEqualToString:kCompleteVeeContactOrganizationName];
    NSAssert(isveeContactCompleteOrganizationNameCorrect, @"Contact organizationName is %@ but should be %@", _veeABRecordComplete.organizationName, kCompleteVeeContactOrganizationName);
}

- (void)testCompleteContactCompositeName
{
    BOOL isCompositeNameCorrect = [_veeABRecordComplete.compositeName isEqualToString:kCompleteVeeContactCompositeName];
    NSAssert(isCompositeNameCorrect, @"Contact compositeName is %@ but should be %@", _veeABRecordComplete.compositeName, kCompleteVeeContactCompositeName);
}

- (void)testCompleteContactPhoneNumbersCount
{
    BOOL isPhoneNumbersCountCorrect = [_veeABRecordComplete.phoneNumbers count] == kCompleteVeeContactPhoneNumbersCount;
    NSAssert(isPhoneNumbersCountCorrect, @"Contact complete phone numbers count is %zd but should be %zd", [_veeABRecordComplete.phoneNumbers count], kCompleteVeeContactPhoneNumbersCount);
}

- (void)testCompleteContactEmailsCount
{
    BOOL isEmailsCountCorrect = [_veeABRecordComplete.emails count] == kCompleteVeeContactEmailsCount;
    NSAssert(isEmailsCountCorrect, @"Contact complete emails count is %zd but should be %zd", [_veeABRecordComplete.emails count], kCompleteVeeContactEmailsCount);
}

#pragma mark - Unified Veecontact

//TODO: ... Can't test unified contacts because I can't reproduce linked records in the address book programmatically, see http://stackoverflow.com/questions/24224929/is-there-a-way-to-programmatically-create-linked-contact

#pragma mark - VeecontactsForTesting tests

- (void)testTestingRecordsCreationCount
{
    BOOL isVeeContactsCountCorrect = [_veeABAdaptedRecordsForTesting count] == kVeeTestingContactsNumber;
    NSAssert(isVeeContactsCountCorrect, @"Loaded %zd contacts from abForTesting, but they should be %zd", [_veeABAdaptedRecordsForTesting count], kVeeTestingContactsNumber);
}

- (void)testRecordIdExist
{
    for (VeeABRecordAdapter* veeABAdaptedRecord in _veeABAdaptedRecordsForTesting) {
        BOOL hasAtLeastOneRecordId = [[veeABAdaptedRecord recordIds] count] > 0;
        NSAssert(hasAtLeastOneRecordId, @"Contact %@ has no recordIds", veeABAdaptedRecord.compositeName);
    }
}

- (void)testCreatedAtExist
{
    for (VeeABRecordAdapter* veeABAdaptedRecord in _veeABAdaptedRecordsForTesting) {
        NSAssert(veeABAdaptedRecord.createdAt, @"Contact unified has no createdAt date");
    }
}

- (void)testModifiedAtExist
{
    for (VeeABRecordAdapter* veeABAdaptedRecord in _veeABAdaptedRecordsForTesting) {
        NSAssert(veeABAdaptedRecord.modifiedAt, @"Contact unified has no modifiedAt date");
    }
}

- (void)testCreatedAtCantBeAfterModifiedAt
{
    for (VeeABRecordAdapter* veeABAdaptedRecord in _veeABAdaptedRecordsForTesting) {
        BOOL isCreatedAtBeforeOrEqualeModifiedAt = [veeABAdaptedRecord.createdAt compare:veeABAdaptedRecord.modifiedAt] == NSOrderedSame || [veeABAdaptedRecord.createdAt compare:veeABAdaptedRecord.modifiedAt] == NSOrderedAscending;
        NSAssert(isCreatedAtBeforeOrEqualeModifiedAt, @"%@ createdAt %@, that is after its modifiedAt: %@", veeABAdaptedRecord.compositeName, veeABAdaptedRecord.createdAt, veeABAdaptedRecord.modifiedAt);
    }
}

- (void)testImageCount
{
    NSUInteger imageCount = 0;
    for (VeeABRecordAdapter* veeABAdaptedRecord in _veeABAdaptedRecordsForTesting) {
        if (veeABAdaptedRecord.thumbnailImage) {
            imageCount++;
        }
    }
    
    BOOL isImageCountCorrect = imageCount == kVeeTestingContactsWithImage;
    NSAssert(isImageCountCorrect, @"Contacts with image are %zd, but they should be %zd", imageCount, kVeeTestingContactsWithImage);
}

- (void)testPhoneNumbersCount
{
    NSUInteger phoneNumbersCount = 0;
    for (VeeABRecordAdapter* veeABAdaptedRecord in _veeABAdaptedRecordsForTesting) {
        phoneNumbersCount += [[veeABAdaptedRecord phoneNumbers] count];
    }
    
    BOOL isPhoneNumberCountCorrect = phoneNumbersCount == kVeeTestingContactsPhoneNumbersCount;
    NSAssert(isPhoneNumberCountCorrect, @"Phone numbers are %ld, but they should be %ld", phoneNumbersCount, kVeeTestingContactsPhoneNumbersCount);
}

- (void)testPhoneNumberDuplicates
{
    for (VeeABRecordAdapter* veeABAdaptedRecord in _veeABAdaptedRecordsForTesting) {
        NSSet* phoneNumberSet = [NSSet setWithArray:veeABAdaptedRecord.phoneNumbers];
        NSAssert([phoneNumberSet count] == [veeABAdaptedRecord.phoneNumbers count], @"Phone numbers contain duplicates!");
    }
}

- (void)testEmailsCount
{
    NSUInteger emailsCount = 0;
    for (VeeABRecordAdapter* veeABAdaptedRecord in _veeABAdaptedRecordsForTesting) {
        emailsCount += [[veeABAdaptedRecord emails] count];
    }
    
    BOOL isEmailCountCorrect = emailsCount == kVeeTestingContactsEmailsCount;
    NSAssert(isEmailCountCorrect, @"Phone numbers are %ld, but they should be %ld", emailsCount, kVeeTestingContactsEmailsCount);
}

- (void)testEmailsNoDuplicate
{
    for (VeeABRecordAdapter* veeABAdaptedRecord in _veeABAdaptedRecordsForTesting) {
        NSSet* emailSet = [NSSet setWithArray:veeABAdaptedRecord.emails];
        NSAssert([emailSet count] == [veeABAdaptedRecord.emails count], @"Emails contain duplicates!");
    }
}

#pragma mark - Private utils

-(NSArray*)veeABAdaptedRecordsFromAddressBookForTesting
{
    NSMutableArray* veeABRecordsMutable = [NSMutableArray new];
    for (id abRecordRefBoxed in [veeAddressBookForTesting abRecordRefsOfTestingContacts]){
        [veeABRecordsMutable addObject:[[VeeABRecordAdapter alloc] initWithLinkedPeopleOfABRecord:(__bridge ABRecordRef)(abRecordRefBoxed)]];
    }
    return [NSArray arrayWithArray:veeABRecordsMutable];
}

@end
