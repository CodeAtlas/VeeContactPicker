//
//  VeecontactTests.m
//  VeeContactPicker
//
//  Created by Andrea Cipriani on 08/03/16.
//  Copyright © 2016 Code Atlas SRL. All rights reserved.
//

#import "VeeAddressBookForTesting.h"
#import "VeeAddressBookForTestingConstants.h"
#import "VeeContact.h"
#import "XCTest+VeeCommons.h"
#import <OCMock/OCMock.h>
#import <XCTest/XCTest.h>

@interface VeeContactTests : XCTestCase

@property (nonatomic, strong) VeeContact* veeContactComplete;
@property (nonatomic, strong) VeeContact* veeContactUnified;
@property (nonatomic, strong) NSArray* veecontactsForTesting;

@end

static VeeAddressBookForTesting* veeAddressBookForTesting;

@implementation VeeContactTests

#pragma mark - Class setup

+(void)setUp
{
    veeAddressBookForTesting = [VeeAddressBookForTesting new];
    [veeAddressBookForTesting addVeeTestingContactsToAddressBook];
}

+(void)tearDown
{
    [veeAddressBookForTesting deleteVeeTestingContactsFromAddressBook];
}

#pragma mark - Tests setup

- (void)setUp
{
    [super setUp];
    _veeContactComplete = [self veeContactComplete];
    _veeContactUnified = [self veeContactUnified];
    _veecontactsForTesting = [self veeContactsFromAddressBookForTesting];
}

- (void)tearDown
{
    [super tearDown];
}

#pragma mark - Complete Veecontact tests

- (void)testVeeContactCompleteCreation
{
    NSAssert(_veeContactComplete, @"VeeContact Complete creation failed");
}

- (void)testVeeContactCompleteFirstName
{
    BOOL isFirstNameCorrect = [_veeContactComplete.firstName isEqualToString:kCompleteVeeContactFirstName];
    NSAssert(isFirstNameCorrect, @"VeeContact firstName is %@ but should be %@", _veeContactComplete.firstName, kCompleteVeeContactFirstName);
}

- (void)testVeeContactCompleteMiddleName
{
    BOOL isMiddleNameCorrect = [_veeContactComplete.middleName isEqualToString:kCompleteVeeContactMiddleName];
    NSAssert(isMiddleNameCorrect, @"VeeContact middleName is %@ but should be %@", _veeContactComplete.middleName, kCompleteVeeContactMiddleName);
}

- (void)testVeeContactCompleteLastName
{
    BOOL isLastNameCorrect = [_veeContactComplete.lastName isEqualToString:kCompleteVeeContactLastName];
    NSAssert(isLastNameCorrect, @"VeeContact lastName is %@ but should be %@", _veeContactComplete.lastName, kCompleteVeeContactLastName);
}

- (void)testVeeContactCompleteNickname
{
    BOOL isNickNameCorrect = [_veeContactComplete.nickname isEqualToString:kCompleteVeeContactNickname];
    NSAssert(isNickNameCorrect, @"VeeContact nickname is %@ but should be %@", _veeContactComplete.nickname, kCompleteVeeContactNickname);
}

- (void)testVeeContactCompleteOrganizationName
{
    BOOL isveeContactCompleteOrganizationNameCorrect = [_veeContactComplete.organizationName isEqualToString:kCompleteVeeContactOrganizationName];
    NSAssert(isveeContactCompleteOrganizationNameCorrect, @"VeeContact organizationName is %@ but should be %@", _veeContactComplete.organizationName, kCompleteVeeContactOrganizationName);
}

- (void)testVeeContactCompleteCompositeName
{
    BOOL isCompositeNameCorrect = [_veeContactComplete.compositeName isEqualToString:kCompleteVeeContactCompositeName];
    NSAssert(isCompositeNameCorrect, @"VeeContact compositeName is %@ but should be %@", _veeContactComplete.compositeName, kCompleteVeeContactCompositeName);
}

- (void)testVeeContactCompleteDisplayName
{
    BOOL isDisplayNameCorrect = [_veeContactComplete.displayName isEqualToString:kCompleteVeeContactDisplayName];
    NSAssert(isDisplayNameCorrect, @"VeeContact displayName is %@ but should be %@", _veeContactComplete.displayName, kCompleteVeeContactDisplayName);
}

- (void)testVeeContactCompleteDisplayNameWithoutFirstName
{
    [self nullifyIvarWithName:@"firstName" ofObject:_veeContactComplete];

    NSString* aspectedDisplayName = _veeContactComplete.organizationName;

    BOOL isDisplayNameCorrect = [_veeContactComplete.displayName isEqualToString:aspectedDisplayName];
    NSAssert(isDisplayNameCorrect, @"VeeContact displayName is %@ but should be %@", _veeContactComplete.displayName, aspectedDisplayName);
}

- (void)testVeeContactCompleteDisplayNameWithoutLastName
{
    [self nullifyIvarWithName:@"lastName" ofObject:_veeContactComplete];

    NSString* aspectedDisplayName = _veeContactComplete.organizationName;

    BOOL isDisplayNameCorrect = [_veeContactComplete.displayName isEqualToString:aspectedDisplayName];
    NSAssert(isDisplayNameCorrect, @"VeeContact displayName is %@ but should be %@", _veeContactComplete.displayName, aspectedDisplayName);
}

- (void)testVeeContactCompleteDisplayNameWithoutFirstNameAndOrganization
{
    [self nullifyIvarWithName:@"firstName" ofObject:_veeContactComplete];
    [self nullifyIvarWithName:@"organizationName" ofObject:_veeContactComplete];

    NSString* aspectedDisplayName = _veeContactComplete.lastName;

    BOOL isDisplayNameCorrect = [_veeContactComplete.displayName isEqualToString:aspectedDisplayName];
    NSAssert(isDisplayNameCorrect, @"VeeContact displayName is %@ but should be %@", _veeContactComplete.displayName, aspectedDisplayName);
}

- (void)testVeeContactCompleteDisplayNameWithoutLastNameAndOrganization
{
    [self nullifyIvarWithName:@"lastName" ofObject:_veeContactComplete];
    [self nullifyIvarWithName:@"organizationName" ofObject:_veeContactComplete];

    NSString* aspectedDisplayName = _veeContactComplete.firstName;

    BOOL isDisplayNameCorrect = [_veeContactComplete.displayName isEqualToString:aspectedDisplayName];
    NSAssert(isDisplayNameCorrect, @"VeeContact displayName is %@ but should be %@", _veeContactComplete.displayName, aspectedDisplayName);
}

- (void)testVeeContactCompleteDisplayNameWithoutFirstNameLastNameAndOrganization
{
    [self nullifyIvarWithName:@"firstName" ofObject:_veeContactComplete];
    [self nullifyIvarWithName:@"lastName" ofObject:_veeContactComplete];
    [self nullifyIvarWithName:@"organizationName" ofObject:_veeContactComplete];

    NSString* aspectedDisplayName = _veeContactComplete.middleName;

    BOOL isDisplayNameCorrect = [_veeContactComplete.displayName isEqualToString:aspectedDisplayName];
    NSAssert(isDisplayNameCorrect, @"VeeContact displayName is %@ but should be %@", _veeContactComplete.displayName, aspectedDisplayName);
}

- (void)testVeeContactCompleteDisplayNameWithoutFirstNameLastNameMiddleNameAndOrganization
{
    [self nullifyIvarWithName:@"firstName" ofObject:_veeContactComplete];
    [self nullifyIvarWithName:@"lastName" ofObject:_veeContactComplete];
    [self nullifyIvarWithName:@"middleName" ofObject:_veeContactComplete];
    [self nullifyIvarWithName:@"organizationName" ofObject:_veeContactComplete];

    NSString* aspectedDisplayName = _veeContactComplete.nickname;

    BOOL isDisplayNameCorrect = [_veeContactComplete.displayName isEqualToString:aspectedDisplayName];
    NSAssert(isDisplayNameCorrect, @"VeeContact displayName is %@ but should be %@", _veeContactComplete.displayName, aspectedDisplayName);
}

- (void)testVeeContactCompleteDisplayNameWithoutFirstNameLastNameMiddleNameNicknameAndOrganization
{
    [self nullifyIvarWithName:@"firstName" ofObject:_veeContactComplete];
    [self nullifyIvarWithName:@"lastName" ofObject:_veeContactComplete];
    [self nullifyIvarWithName:@"middleName" ofObject:_veeContactComplete];
    [self nullifyIvarWithName:@"nickname" ofObject:_veeContactComplete];
    [self nullifyIvarWithName:@"organizationName" ofObject:_veeContactComplete];

    BOOL isDisplayNameCorrect = [self isEmailAddress:_veeContactComplete.displayName];
    NSAssert(isDisplayNameCorrect, @"VeeContact displayName is %@ but should be an email address",_veeContactComplete.displayName);
}

- (void)testVeeContactCompleteEmptyDisplayName
{
    [self nullifyIvarWithName:@"firstName" ofObject:_veeContactComplete];
    [self nullifyIvarWithName:@"lastName" ofObject:_veeContactComplete];
    [self nullifyIvarWithName:@"middleName" ofObject:_veeContactComplete];
    [self nullifyIvarWithName:@"nickname" ofObject:_veeContactComplete];
    [self nullifyIvarWithName:@"organizationName" ofObject:_veeContactComplete];
    [self nullifyIvarWithName:@"emailsMutable" ofObject:_veeContactComplete];

    NSString* aspectedDisplayName = @"";

    BOOL isDisplayNameCorrect = [_veeContactComplete.displayName isEqualToString:aspectedDisplayName];
    NSAssert(isDisplayNameCorrect, @"VeeContact displayName is %@ but should be %@", _veeContactComplete.displayName, aspectedDisplayName);
}

-(void)testVeecontactCompletePhoneNumbersCount
{
    BOOL isPhoneNumbersCountCorrect = [_veeContactComplete.phoneNumbers count] == kCompleteVeeContactPhoneNumbersCount;
    NSAssert(isPhoneNumbersCountCorrect, @"VeeContact complete phone numbers count is %zd but should be %zd", [_veeContactComplete.phoneNumbers count], kCompleteVeeContactPhoneNumbersCount);
}

-(void)testVeecontactCompleteEmailsCount
{
    BOOL isEmailsCountCorrect = [_veeContactComplete.emails count] == kCompleteVeeContactEmailsCount;
    NSAssert(isEmailsCountCorrect, @"VeeContact complete emails count is %zd but should be %zd", [_veeContactComplete.emails count], kCompleteVeeContactEmailsCount);
}

#pragma mark - Unified Veecontact

//TODO: ...

#pragma mark - VeecontactsForTesting tests

- (void)testVeeContactsCreationCount
{
    BOOL isVeeContactsCountCorrect = [_veecontactsForTesting count] == kVeeTestingContactsNumber;
    NSAssert(isVeeContactsCountCorrect, @"Loaded %zd contacts from abForTesting, but they should be %zd", [_veecontactsForTesting count], kVeeTestingContactsNumber);
}

- (void)testVeeContactsRecordIdExist
{
    for (VeeContact* veeContact in _veecontactsForTesting) {
        BOOL hasAtLeastOneRecordId = [[veeContact recordIds] count] > 0;
        NSAssert(hasAtLeastOneRecordId, @"VeeContact %@ has no recordIds", veeContact.displayName);
    }
}

- (void)testVeecontactsCreatedAtExist
{
    for (VeeContact* veeContact in _veecontactsForTesting) {
        NSAssert(veeContact.createdAt, @"VeeContact unified has no createdAt date");
    }
}

- (void)testVeecontactsModifiedAtExist
{
    for (VeeContact* veeContact in _veecontactsForTesting) {
        NSAssert(veeContact.modifiedAt, @"VeeContact unified has no modifiedAt date");
    }
}

- (void)testVeecontactsCreatedAtCantBeAfterModifiedAt
{
    for (VeeContact* veeContact in _veecontactsForTesting) {
        BOOL isVeeContactCreatedBeforeOrEqualeModifiedAt = [veeContact.createdAt compare:veeContact.modifiedAt] == NSOrderedSame || [veeContact.createdAt compare:veeContact.modifiedAt] == NSOrderedAscending;
        NSAssert(isVeeContactCreatedBeforeOrEqualeModifiedAt, @"Veecontact %@ createdAt %@, that is after its modifiedAt: %@", veeContact.displayName, veeContact.createdAt, veeContact.modifiedAt);
    }
}

- (void)testVeecontactsImageCount
{
    NSUInteger veecontactsImageCount = 0;
    for (VeeContact* veeContact in _veecontactsForTesting) {
        if (veeContact.thumbnailImage) {
            veecontactsImageCount++;
        }
    }

    BOOL isVeecontactsImageNumberCorrect = veecontactsImageCount == kVeeTestingContactsWithImage;
    NSAssert(isVeecontactsImageNumberCorrect, @"Veecontacts with image are %zd, but they should be %zd", veecontactsImageCount, kVeeTestingContactsWithImage);
}

- (void)testVeecontactsPhoneNumbersCount
{
    NSUInteger phoneNumberCount = 0;
    for (VeeContact* veeContact in _veecontactsForTesting) {
        phoneNumberCount += [[veeContact phoneNumbers] count];
    }
    
    BOOL isPhoneNumberCountCorrect = phoneNumberCount == kVeeTestingContactsPhoneNumbersCount;
    NSAssert(isPhoneNumberCountCorrect, @"Veecontacts phone numbers are %ld, but they should be %ld", phoneNumberCount, kVeeTestingContactsPhoneNumbersCount);
}

- (void)testVeecontactsPhoneNumberDuplicate
{
    for (VeeContact* veeContact in _veecontactsForTesting) {
        NSSet * phoneNumberSet = [NSSet setWithArray:veeContact.phoneNumbers];
        NSAssert([phoneNumberSet count] == [veeContact.phoneNumbers count] , @"Veecontacts phone numbers contain duplicates!");
    }
}

- (void)testVeecontactsEmailsCount
{
    NSUInteger emailsCount = 0;
    for (VeeContact* veeContact in _veecontactsForTesting) {
        emailsCount += [[veeContact emails] count];
    }
    
    BOOL isEmailCountCorrect = emailsCount == kVeeTestingContactsEmailsCount;
    NSAssert(isEmailCountCorrect, @"Veecontacts phone numbers are %ld, but they should be %ld", emailsCount, kVeeTestingContactsEmailsCount);
}

- (void)testVeecontactsEmailsNoDuplicate
{
    for (VeeContact* veeContact in _veecontactsForTesting) {
        NSSet * emailSet = [NSSet setWithArray:veeContact.emails];
        NSAssert([emailSet count] == [veeContact.emails count] , @"Veecontacts emails contain duplicates!");
    }
}

#pragma mark - Private utils

- (VeeContact*)veeContactComplete
{
    VeeContact* veeContactComplete = [[VeeContact alloc] initWithLinkedPeopleOfABRecord:[veeAddressBookForTesting veeContactCompleteRecord]];
    return veeContactComplete;
}

- (VeeContact*)veeContactUnified
{
    VeeContact* veeContactUnified = [[VeeContact alloc] initWithLinkedPeopleOfABRecord:[veeAddressBookForTesting veeContactUnifiedRecord]];
    return veeContactUnified;
}

- (NSArray*)veeContactsFromAddressBookForTesting
{
    NSMutableArray* veeContactsFromABForTestingMutable = [NSMutableArray new];
    for (id abRecordRefBoxed in [veeAddressBookForTesting recordRefsOfAddressBookForTesting]) {
        VeeContact* veeContact = [[VeeContact alloc] initWithLinkedPeopleOfABRecord:(__bridge ABRecordRef)(abRecordRefBoxed)];
        [veeContactsFromABForTestingMutable addObject:veeContact];
    }
    return [NSArray arrayWithArray:veeContactsFromABForTestingMutable];
}

- (BOOL)isEmailAddress:(NSString*)canBeAnEmail
{
    if ([canBeAnEmail containsString:@"@"]) {
        return YES;
    }
    return NO;
}

@end
