//
//  Created by Andrea Cipriani on 08/03/16.
//  Copyright © 2016 Code Atlas SRL. All rights reserved.
//

#import "VeeContact.h"
#import "VeecontactsForTestingFactory.h"
#import "VeeAddressBookForTestingConstants.h"
#import "XCTest+VeeCommons.h"
#import <XCTest/XCTest.h>
#import "OCMock.h"
#import "VeeAddressBook.h"
@import AddressBook;

@interface VeeContactTests : XCTestCase

@property (nonatomic, strong) VeeContact* veeContactComplete;
@property (nonatomic, strong) NSArray* randomVeeContacts;

@end

@implementation VeeContactTests

#pragma mark - Tests setup

- (void)setUp
{
    [super setUp];
    _veeContactComplete = [VeeContactsForTestingFactory veeContactComplete];
    _randomVeeContacts = [VeeContactsForTestingFactory createRandomVeeContacts:25];
}

- (void)tearDown
{
    [super tearDown];
}

#pragma mark - Display name

- (void)testVeeContactCompleteDisplayNameForOrderingByFirstName
{
    id veeAddressBookMock = OCMClassMock([VeeAddressBook class]);
    OCMStub([veeAddressBookMock isABSortOrderingByFirstName]).andReturn(YES);
    
    BOOL isDisplayNameCorrect = [_veeContactComplete.displayName isEqualToString:kCompleteVeeContactDisplayNameFirstNameFirst];
    NSAssert(isDisplayNameCorrect, @"VeeContact displayName is %@ but should be %@", _veeContactComplete.displayName, kCompleteVeeContactDisplayNameFirstNameFirst);
}

- (void)testVeeContactCompleteDisplayNameForOrderingByLastName
{
    id veeAddressBookMock = OCMClassMock([VeeAddressBook class]);
    OCMStub([veeAddressBookMock isABSortOrderingByFirstName]).andReturn(NO);
    
    BOOL isDisplayNameCorrect = [_veeContactComplete.displayName isEqualToString:kCompleteVeeContactDisplayNameLastNameFirst];
    NSAssert(isDisplayNameCorrect, @"VeeContact displayName is %@ but should be %@", _veeContactComplete.displayName, kCompleteVeeContactDisplayNameLastNameFirst);
}

- (void)testVeeContactCompleteDisplayNameWithoutFirstName
{
    id veeAddressBookMock = OCMClassMock([VeeAddressBook class]);
    OCMStub([veeAddressBookMock isABSortOrderingByFirstName]).andReturn(YES);
    
    [self nullifyIvarWithName:@"firstName" ofObject:_veeContactComplete];
    
    NSString* expectedDisplayName = _veeContactComplete.organizationName;
    
    BOOL isDisplayNameCorrect = [_veeContactComplete.displayName isEqualToString:expectedDisplayName];
    NSAssert(isDisplayNameCorrect, @"VeeContact displayName is %@ but should be %@", _veeContactComplete.displayName, expectedDisplayName);
}


- (void)testVeeContactCompleteDisplayNameWithoutLastName
{
    id veeAddressBookMock = OCMClassMock([VeeAddressBook class]);
    OCMStub([veeAddressBookMock isABSortOrderingByFirstName]).andReturn(NO);
    
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
    NSAssert(isDisplayNameCorrect, @"VeeContact displayName is %@ but should be an email address", _veeContactComplete.displayName);
}

- (void)testVeeContactCompleteEmptyDisplayName
{
    [self nullifyIvarWithName:@"firstName" ofObject:_veeContactComplete];
    [self nullifyIvarWithName:@"lastName" ofObject:_veeContactComplete];
    [self nullifyIvarWithName:@"middleName" ofObject:_veeContactComplete];
    [self nullifyIvarWithName:@"nickname" ofObject:_veeContactComplete];
    [self nullifyIvarWithName:@"organizationName" ofObject:_veeContactComplete];
    [self nullifyIvarWithName:@"emails" ofObject:_veeContactComplete];
    
    NSString* aspectedDisplayName = @"";
    
    BOOL isDisplayNameCorrect = [_veeContactComplete.displayName isEqualToString:aspectedDisplayName];
    NSAssert(isDisplayNameCorrect, @"VeeContact displayName is %@ but should be %@", _veeContactComplete.displayName, aspectedDisplayName);
}

#pragma mark - Section identifier

- (void)testVeecontactsSectionIdentifierShouldBeOneCharacter
{
    for (VeeContact* veeContact in _randomVeeContacts) {
        NSString* veeContactSectionIdentifier = [veeContact sectionIdentifier];
        NSAssert(veeContactSectionIdentifier, @"VeeContact %@ has no section identifier", veeContact.displayName);
        BOOL isSectionIdentiferOneCharacter = [veeContactSectionIdentifier length] == 1;
        NSAssert(isSectionIdentiferOneCharacter, @"VeeContact %@ has a section identifier with length != 1: %@", veeContact.displayName, veeContactSectionIdentifier);
    }
}

- (void)testVeecontactCompleteSectionIdentifier
{
    BOOL isSectionIdentifierCorrect = [_veeContactComplete.sectionIdentifier isEqualToString:kCompleteVeeContactSectionIdentifier];
    NSAssert(isSectionIdentifierCorrect, @"VeeContact complete sectionIdentifier is %@ but should be %@", _veeContactComplete.sectionIdentifier, kCompleteVeeContactSectionIdentifier);
}

- (void)testVeecontactCompleteSectionIdentifierWithoutFirstName
{
    [self nullifyIvarWithName:@"firstName" ofObject:_veeContactComplete];
    BOOL isSectionIdentifierCorrect = [_veeContactComplete.sectionIdentifier isEqualToString:kCompleteVeeContactWithoutFirstNameSectionIdentifier];

    NSAssert(isSectionIdentifierCorrect, @"VeeContact complete sectionIdentifier is %@ but should be %@", _veeContactComplete.sectionIdentifier, kCompleteVeeContactWithoutFirstNameSectionIdentifier);
}

- (void)testVeecontactCompleteSectionIdentifierWithoutFirstNameAndLastName
{
    [self nullifyIvarWithName:@"firstName" ofObject:_veeContactComplete];
    [self nullifyIvarWithName:@"lastName" ofObject:_veeContactComplete];
    BOOL isSectionIdentifierCorrect = [_veeContactComplete.sectionIdentifier isEqualToString:kCompleteVeeContactWithoutFirstNameAndLastNameSectionIdentifier];

    NSAssert(isSectionIdentifierCorrect, @"VeeContact complete sectionIdentifier is %@ but should be %@", _veeContactComplete.sectionIdentifier, kCompleteVeeContactWithoutFirstNameAndLastNameSectionIdentifier);
}

- (void)testVeecontactCompleteSectionIdentifierEmptyDisplayNameShouldBeNil
{
    [self nullifyIvarWithName:@"firstName" ofObject:_veeContactComplete];
    [self nullifyIvarWithName:@"lastName" ofObject:_veeContactComplete];
    [self nullifyIvarWithName:@"middleName" ofObject:_veeContactComplete];
    [self nullifyIvarWithName:@"nickname" ofObject:_veeContactComplete];
    [self nullifyIvarWithName:@"organizationName" ofObject:_veeContactComplete];
    [self nullifyIvarWithName:@"emails" ofObject:_veeContactComplete];

    NSString* aspectedSectionIdentifier = _veeContactComplete.sectionIdentifier;
    
    NSAssert(aspectedSectionIdentifier == nil, @"VeeContact complete sectionIdentifier is %@ but should be nil", _veeContactComplete.sectionIdentifier);
}

#pragma mark - Sorting

-(void)testVeeContactSortingByFirstName
{
    NSArray* veeContacts = [VeeContactsForTestingFactory createRandomVeeContacts:3];
    id veeAddressBookMock = OCMClassMock([VeeAddressBook class]);
    OCMStub([veeAddressBookMock isABSortOrderingByFirstName]).andReturn(YES);
    
    VeeContact* bob = veeContacts[0];
    [bob setValue:@"Bob" forKey:@"firstName"];
    [bob setValue:@"ALastName" forKey:@"lastName"];
    
    VeeContact* alice = veeContacts[1];
    [alice setValue:@"Alice" forKey:@"firstName"];
    [alice setValue:@"ALastName" forKey:@"lastName"];
    
    VeeContact* andrea = veeContacts[2];
    [andrea setValue:@"Andrea" forKey:@"firstName"];
    [self nullifyIvarWithName:@"lastName" ofObject:andrea];
    
    veeContacts = [veeContacts sortedArrayUsingSelector:@selector(compare:)];
    
    BOOL areSortedByFirstName = [[veeContacts firstObject] isEqual:alice] && [[veeContacts lastObject] isEqual:bob];
    NSAssert(areSortedByFirstName, @"Contacts are not sorted properly by first name");
}

-(void)testVeeContactSortingByLastName
{
    NSArray* veeContacts = [VeeContactsForTestingFactory createRandomVeeContacts:3];
    
    id veeAddressBookMock = OCMClassMock([VeeAddressBook class]);
    OCMStub([veeAddressBookMock isABSortOrderingByFirstName]).andReturn(NO);
    
    VeeContact* carl = veeContacts[0];
    [carl setValue:@"Carl" forKey:@"lastName"];
    [self nullifyIvarWithName:@"firstName" ofObject:carl];
    
    VeeContact* bob = veeContacts[1];
    [bob setValue:@"AFirstName" forKey:@"firstName"];
    [bob setValue:@"Bob" forKey:@"lastName"];
    
    VeeContact* alice = veeContacts[2];
    [alice setValue:@"AFirstName" forKey:@"firstName"];
    [alice setValue:@"Alice" forKey:@"lastName"];

    
    veeContacts = [veeContacts sortedArrayUsingSelector:@selector(compare:)];
    
    BOOL areSortedByLastName = [[veeContacts firstObject] isEqual:alice] && [[veeContacts lastObject] isEqual:carl];
    NSAssert(areSortedByLastName, @"Contacts are not sorted properly by last name");
}

-(void)testVeeContactWithSameFirstNameAreSortedByDisplayName
{
    NSArray* veeContacts = [VeeContactsForTestingFactory createRandomVeeContacts:3];
    id veeAddressBookMock = OCMClassMock([VeeAddressBook class]);
    OCMStub([veeAddressBookMock isABSortOrderingByFirstName]).andReturn(YES);
    VeeContact* aliceC = veeContacts[0];
    [aliceC setValue:@"Alice" forKey:@"firstName"];
    [aliceC setValue:@"C" forKey:@"lastName"];
    [self nullifyIvarWithName:@"middleName" ofObject:aliceC];

    VeeContact* aliceA = veeContacts[1];
    [aliceA setValue:@"Alice" forKey:@"firstName"];
    [aliceA setValue:@"A" forKey:@"lastName"];
    [self nullifyIvarWithName:@"middleName" ofObject:aliceA];
    
    VeeContact* aliceB = veeContacts[2];
    [aliceB setValue:@"Alice" forKey:@"firstName"];
    [aliceB setValue:@"B" forKey:@"middleName"];
    [aliceB setValue:@"D" forKey:@"lastName"]; //Ignored because middle name has the priority
    
    veeContacts = [veeContacts sortedArrayUsingSelector:@selector(compare:)];
    
    BOOL areSorted = [[veeContacts firstObject] isEqual:aliceA] && [[veeContacts lastObject] isEqual:aliceC];
    NSAssert(areSorted, @"Contacts with same firstName are not sorted properly");
}

-(void)testVeeContactWithSameLastNameAreSortedByDisplayName
{
    NSArray* veeContacts = [VeeContactsForTestingFactory createRandomVeeContacts:3];
    id veeAddressBookMock = OCMClassMock([VeeAddressBook class]);
    OCMStub([veeAddressBookMock isABSortOrderingByFirstName]).andReturn(YES);
    
    VeeContact* aliceC = veeContacts[0];
    [aliceC setValue:@"C" forKey:@"firstName"];
    [aliceC setValue:@"Surname" forKey:@"lastName"];
    [self nullifyIvarWithName:@"middleName" ofObject:aliceC];
    
    VeeContact* aliceA = veeContacts[1];
    [aliceA setValue:@"A" forKey:@"firstName"];
    [aliceA setValue:@"Surname" forKey:@"lastName"];
    [self nullifyIvarWithName:@"middleName" ofObject:aliceA];
    
    VeeContact* aliceB = veeContacts[2];
    [aliceB setValue:@"B" forKey:@"firstName"];
    [aliceB setValue:@"D" forKey:@"middleName"]; //Ignored because first name has the priority
    [aliceB setValue:@"Surname" forKey:@"lastName"];
    
    veeContacts = [veeContacts sortedArrayUsingSelector:@selector(compare:)];
    
    BOOL areSorted = [[veeContacts firstObject] isEqual:aliceA] && [[veeContacts lastObject] isEqual:aliceC];
    NSAssert(areSorted, @"Contacts with same lastName are not sorted properly");
}

-(void)testVeeContactWithNoLastNameSorting
{
    NSArray* veeContacts = [VeeContactsForTestingFactory createRandomVeeContacts:2];
    
    VeeContact* aliceWithNoLastName = veeContacts[1];
    [aliceWithNoLastName setValue:@"Alice" forKey:@"firstName"];
    [self nullifyIvarWithName:@"middleName" ofObject:aliceWithNoLastName];
    [self nullifyIvarWithName:@"lastName" ofObject:aliceWithNoLastName];
    
    VeeContact* alice = veeContacts[0];
    [alice setValue:@"Alice" forKey:@"firstName"];
    [self nullifyIvarWithName:@"middleName" ofObject:alice];
    [alice setValue:@"ALastName" forKey:@"lastName"];
    
    veeContacts = [veeContacts sortedArrayUsingSelector:@selector(compare:)];
    
    BOOL areSorted = [[veeContacts firstObject] isEqual:alice];
    NSAssert(areSorted, @"Alice ALastName and Bob ALastName are not sorted properly");
}

-(void)testVeeContactCompanySorting
{
    NSArray* veeContacts = [VeeContactsForTestingFactory createRandomVeeContacts:3];
    
    VeeContact* companyVeeContact = veeContacts[0];
    [self nullifyIvarWithName:@"firstName" ofObject:companyVeeContact];
    [self nullifyIvarWithName:@"lastName" ofObject:companyVeeContact];
    [companyVeeContact setValue:@"Company" forKey:@"organizationName"];
    
    VeeContact* alice = veeContacts[2];
    [alice setValue:@"Alice" forKey:@"firstName"];
    [alice setValue:@"ALastName" forKey:@"lastName"];
 
    VeeContact* dan = veeContacts[1];
    [dan setValue:@"Dan" forKey:@"firstName"];
    [dan setValue:@"DLastName" forKey:@"lastName"];
    
    veeContacts = [veeContacts sortedArrayUsingSelector:@selector(compare:)];
    BOOL areSorted = [[veeContacts firstObject] isEqual:alice] && [[veeContacts lastObject] isEqual:dan];
    NSAssert(areSorted, @"Alice ALastName and Company are not sorted properly");
}

#pragma mark - Private utils

- (BOOL)isEmailAddress:(NSString*)canBeAnEmail
{
    if ([canBeAnEmail containsString:@"@"]) {
        return YES;
    }
    return NO;
}


@end
