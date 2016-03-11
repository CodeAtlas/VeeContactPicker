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

@interface VeecontactTests : XCTestCase

@property (nonatomic, strong) VeeAddressBookForTesting* veeAddressBookForTesting;

@end

@implementation VeecontactTests

- (void)setUp
{
    [super setUp];
    _veeAddressBookForTesting = [VeeAddressBookForTesting new];
    [_veeAddressBookForTesting addVeeTestingContactsToAddressBook];
}

- (void)tearDown
{
    [super tearDown];
    [_veeAddressBookForTesting deleteVeeTestingContactsFromAddressBook];
}

#pragma mark - Complete Veecontact

- (void)testVeeContactCompleteCreation
{
    VeeContact* veeContactComplete = [self veeContactComplete];
    NSAssert(veeContactComplete, @"VeeContact Complete creation failed");
}

- (void)testVeeContactCompleteFirstName
{
    VeeContact* veeContactComplete = [self veeContactComplete];
    BOOL isFirstNameCorrect = [veeContactComplete.firstName isEqualToString:kCompleteVeeContactFirstName];
    NSAssert(isFirstNameCorrect, @"VeeContact firstName is %@ but should be %@", veeContactComplete.firstName, kCompleteVeeContactFirstName);
}

- (void)testVeeContactCompleteMiddleName
{
    VeeContact* veeContactComplete = [self veeContactComplete];
    BOOL isMiddleNameCorrect = [veeContactComplete.middleName isEqualToString:kCompleteVeeContactMiddleName];
    NSAssert(isMiddleNameCorrect, @"VeeContact middleName is %@ but should be %@", veeContactComplete.middleName, kCompleteVeeContactMiddleName);
}

- (void)testVeeContactCompleteLastName
{
    VeeContact* veeContactComplete = [self veeContactComplete];
    BOOL isLastNameCorrect = [veeContactComplete.lastName isEqualToString:kCompleteVeeContactLastName];
    NSAssert(isLastNameCorrect, @"VeeContact lastName is %@ but should be %@", veeContactComplete.lastName, kCompleteVeeContactLastName);
}

- (void)testVeeContactCompleteNickname
{
    VeeContact* veeContactComplete = [self veeContactComplete];
    BOOL isNickNameCorrect = [veeContactComplete.nickname isEqualToString:kCompleteVeeContactNickname];
    NSAssert(isNickNameCorrect, @"VeeContact nickname is %@ but should be %@", veeContactComplete.nickname, kCompleteVeeContactNickname);
}

- (void)testVeeContactCompleteOrganizationName
{
    VeeContact* veeContactComplete = [self veeContactComplete];
    BOOL isveeContactCompleteOrganizationNameCorrect = [veeContactComplete.organizationName isEqualToString:kCompleteVeeContactOrganizationName];
    NSAssert(isveeContactCompleteOrganizationNameCorrect, @"VeeContact organizationName is %@ but should be %@", veeContactComplete.organizationName, kCompleteVeeContactOrganizationName);
}

- (void)testVeeContactCompleteCompositeName
{
    /*
     Composite name: The concatenated value of these properties: Prefix, Suffix, Organization, First name, and Last name.
     */
    VeeContact* veeContactComplete = [self veeContactComplete];
    BOOL isCompositeNameCorrect = [veeContactComplete.compositeName isEqualToString:kCompleteVeeContactCompositeName];
    NSAssert(isCompositeNameCorrect, @"VeeContact compositeName is %@ but should be %@", veeContactComplete.compositeName, kCompleteVeeContactCompositeName);
}

/*
 Display name depends on which field is not nil, this is the order of preferences: "FirstName LastName" - "OrganizationName" - "LastName" - "First Name" - "Middle Name" - "Nickname" - "emailAddress"
 */

- (void)testVeeContactCompleteDisplayName
{
    VeeContact* veeContactComplete = [self veeContactComplete];
    BOOL isDisplayNameCorrect = [veeContactComplete.displayName isEqualToString:kCompleteVeeContactDisplayName];
    NSAssert(isDisplayNameCorrect, @"VeeContact displayName is %@ but should be %@", veeContactComplete.displayName, kCompleteVeeContactDisplayName);
}

- (void)testVeeContactCompleteDisplayNameWithoutFirstName
{
    VeeContact* veeContactComplete = [self veeContactComplete];
    [self nullifyIvarWithName:@"firstName" ofObject:veeContactComplete];

    NSString* aspectedDisplayName = veeContactComplete.organizationName;

    BOOL isDisplayNameCorrect = [veeContactComplete.displayName isEqualToString:aspectedDisplayName];
    NSAssert(isDisplayNameCorrect, @"VeeContact displayName is %@ but should be %@", veeContactComplete.displayName, aspectedDisplayName);
}

- (void)testVeeContactCompleteDisplayNameWithoutLastName
{
    VeeContact* veeContactComplete = [self veeContactComplete];
    [self nullifyIvarWithName:@"lastName" ofObject:veeContactComplete];

    NSString* aspectedDisplayName = veeContactComplete.organizationName;

    BOOL isDisplayNameCorrect = [veeContactComplete.displayName isEqualToString:aspectedDisplayName];
    NSAssert(isDisplayNameCorrect, @"VeeContact displayName is %@ but should be %@", veeContactComplete.displayName, aspectedDisplayName);
}

- (void)testVeeContactCompleteDisplayNameWithoutFirstNameAndOrganization
{
    VeeContact* veeContactComplete = [self veeContactComplete];
    [self nullifyIvarWithName:@"firstName" ofObject:veeContactComplete];
    [self nullifyIvarWithName:@"organizationName" ofObject:veeContactComplete];

    NSString* aspectedDisplayName = veeContactComplete.lastName;

    BOOL isDisplayNameCorrect = [veeContactComplete.displayName isEqualToString:aspectedDisplayName];
    NSAssert(isDisplayNameCorrect, @"VeeContact displayName is %@ but should be %@", veeContactComplete.displayName, aspectedDisplayName);
}

- (void)testVeeContactCompleteDisplayNameWithoutLastNameAndOrganization
{
    VeeContact* veeContactComplete = [self veeContactComplete];
    [self nullifyIvarWithName:@"lastName" ofObject:veeContactComplete];
    [self nullifyIvarWithName:@"organizationName" ofObject:veeContactComplete];

    NSString* aspectedDisplayName = veeContactComplete.firstName;

    BOOL isDisplayNameCorrect = [veeContactComplete.displayName isEqualToString:aspectedDisplayName];
    NSAssert(isDisplayNameCorrect, @"VeeContact displayName is %@ but should be %@", veeContactComplete.displayName, aspectedDisplayName);
}

- (void)testVeeContactCompleteDisplayNameWithoutFirstNameLastNameAndOrganization
{
    VeeContact* veeContactComplete = [self veeContactComplete];
    [self nullifyIvarWithName:@"firstName" ofObject:veeContactComplete];
    [self nullifyIvarWithName:@"lastName" ofObject:veeContactComplete];
    [self nullifyIvarWithName:@"organizationName" ofObject:veeContactComplete];

    NSString* aspectedDisplayName = veeContactComplete.middleName;

    BOOL isDisplayNameCorrect = [veeContactComplete.displayName isEqualToString:aspectedDisplayName];
    NSAssert(isDisplayNameCorrect, @"VeeContact displayName is %@ but should be %@", veeContactComplete.displayName, aspectedDisplayName);
}

- (void)testVeeContactCompleteDisplayNameWithoutFirstNameLastNameMiddleNameAndOrganization
{
    VeeContact* veeContactComplete = [self veeContactComplete];
    [self nullifyIvarWithName:@"firstName" ofObject:veeContactComplete];
    [self nullifyIvarWithName:@"lastName" ofObject:veeContactComplete];
    [self nullifyIvarWithName:@"middleName" ofObject:veeContactComplete];
    [self nullifyIvarWithName:@"organizationName" ofObject:veeContactComplete];

    NSString* aspectedDisplayName = veeContactComplete.nickname;

    BOOL isDisplayNameCorrect = [veeContactComplete.displayName isEqualToString:aspectedDisplayName];
    NSAssert(isDisplayNameCorrect, @"VeeContact displayName is %@ but should be %@", veeContactComplete.displayName, aspectedDisplayName);
}

- (void)testVeeContactCompleteDisplayNameWithoutFirstNameLastNameMiddleNameNicknameAndOrganization
{
    VeeContact* veeContactComplete = [self veeContactComplete];
    [self nullifyIvarWithName:@"firstName" ofObject:veeContactComplete];
    [self nullifyIvarWithName:@"lastName" ofObject:veeContactComplete];
    [self nullifyIvarWithName:@"middleName" ofObject:veeContactComplete];
    [self nullifyIvarWithName:@"nickname" ofObject:veeContactComplete];
    [self nullifyIvarWithName:@"organizationName" ofObject:veeContactComplete];

    BOOL isDisplayNameCorrect = [self isEmailAddress:veeContactComplete.displayName];
    NSAssert(isDisplayNameCorrect, @"VeeContact displayName is %@ but should be an email address", veeContactComplete.displayName);
}

- (void)testVeeContactCompleteEmptyDisplayName
{
    VeeContact* veeContactComplete = [self veeContactComplete];
    [self nullifyIvarWithName:@"firstName" ofObject:veeContactComplete];
    [self nullifyIvarWithName:@"lastName" ofObject:veeContactComplete];
    [self nullifyIvarWithName:@"middleName" ofObject:veeContactComplete];
    [self nullifyIvarWithName:@"nickname" ofObject:veeContactComplete];
    [self nullifyIvarWithName:@"organizationName" ofObject:veeContactComplete];
    [self nullifyIvarWithName:@"emailsMutable" ofObject:veeContactComplete];

    NSString* aspectedDisplayName = @"";

    BOOL isDisplayNameCorrect = [veeContactComplete.displayName isEqualToString:aspectedDisplayName];
    NSAssert(isDisplayNameCorrect, @"VeeContact displayName is %@ but should be %@", veeContactComplete.displayName, aspectedDisplayName);
}

#pragma mark - Unified Veecontact

//TODO: ...

#pragma mark - Veecontacts ABForTesting

- (void)testVeeContactsCreationCount
{
    NSArray* veeContacts = [self veeContactsFromAddressBookForTesting];
    BOOL isVeeContactsCountCorrect = [veeContacts count] == kVeeTestingContactsNumber;
    NSAssert(isVeeContactsCountCorrect, @"Loaded %zd contacts from abForTesting, but they should be %zd", [veeContacts count], kVeeTestingContactsNumber);
}

- (void)testVeeContactsRecordIdExist
{
    for (VeeContact* veeContact in [self veeContactsFromAddressBookForTesting]) {
        BOOL hasAtLeastOneRecordId = [[veeContact recordIds] count] > 0;
        NSAssert(hasAtLeastOneRecordId, @"VeeContact %@ has no recordIds", veeContact.displayName);
    }
}

- (void)testVeecontactsCreatedAtExist
{
    for (VeeContact* veeContact in [self veeContactsFromAddressBookForTesting]) {
        NSAssert(veeContact.createdAt, @"VeeContact unified has no createdAt date");
    }
}

- (void)testVeecontactsModifiedAtExist
{
    for (VeeContact* veeContact in [self veeContactsFromAddressBookForTesting]) {
        NSAssert(veeContact.modifiedAt, @"VeeContact unified has no modifiedAt date");
    }
}

- (void)testVeecontactsCreatedAtCantBeAfterModifiedAt
{
    for (VeeContact* veeContact in [self veeContactsFromAddressBookForTesting]) {
        BOOL isVeeContactCreatedBeforeOrEqualeModifiedAt = [veeContact.createdAt compare:veeContact.modifiedAt] == NSOrderedSame || [veeContact.createdAt compare:veeContact.modifiedAt] == NSOrderedAscending;
        NSAssert(isVeeContactCreatedBeforeOrEqualeModifiedAt, @"Veecontact %@ createdAt %@, that is after its modifiedAt: %@", veeContact.displayName, veeContact.createdAt, veeContact.modifiedAt);
    }
}

- (void)TODOtestVeecontactsImageCount
{
    NSUInteger veecontactsImageCount = 0;
    for (VeeContact* veeContact in [self veeContactsFromAddressBookForTesting]) {
        if (veeContact.thumbnailImage) {
            veecontactsImageCount++;
        }
    }

    BOOL isVeecontactsImageNumberCorrect = veecontactsImageCount == kVeeTestingContactsWithImage;
    NSAssert(isVeecontactsImageNumberCorrect, @"Veecontacts with image are %ld, but they should be %ld", veecontactsImageCount, (long)kVeeTestingContactsWithImage);
}

#pragma mark - Private utils

- (VeeContact*)veeContactComplete
{
    VeeContact* veeContactComplete = [[VeeContact alloc] initWithLinkedPeopleOfABRecord:[_veeAddressBookForTesting veeContactCompleteRecord]];
    return veeContactComplete;
}

- (VeeContact*)veeContactUnified
{
    VeeContact* veeContactUnified = [[VeeContact alloc] initWithLinkedPeopleOfABRecord:[_veeAddressBookForTesting veeContactUnifiedRecord]];
    return veeContactUnified;
}

- (NSArray*)veeContactsFromAddressBookForTesting
{
    NSMutableArray* veeContactsFromABForTestingMutable = [NSMutableArray new];
    for (id abRecordRefBoxed in [_veeAddressBookForTesting recordRefsOfAddressBookForTesting]) {
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
