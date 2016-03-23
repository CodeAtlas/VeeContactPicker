//
//  VeecontactTests.m
//  VeeContactPicker
//
//  Created by Andrea Cipriani on 08/03/16.
//  Copyright © 2016 Code Atlas SRL. All rights reserved.
//

#import "VeeContact.h"
#import "VeecontactsForTestingFactory.h"
#import "VeeAddressBookForTestingConstants.h"
#import "XCTest+VeeCommons.h"
#import <XCTest/XCTest.h>

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

-(void)testVeeContactAreSortedByFirstName
{
    NSArray* veeContacts = [VeeContactsForTestingFactory createRandomVeeContacts:3];
    
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
    
    BOOL areSorted = [[veeContacts firstObject] isEqual:alice] && [[veeContacts lastObject] isEqual:bob];
    NSAssert(areSorted, @"Alice ALastName, Andrea and Bob ALastName are not sorted properly");
}

-(void)testVeeContactWithSameFirstNameAreSortedByDisplayName
{
    NSArray* veeContacts = [VeeContactsForTestingFactory createRandomVeeContacts:3];
    
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
    [aliceC setValue:@"D" forKey:@"lastName"]; //Ignored because middle name has the priority
    
    veeContacts = [veeContacts sortedArrayUsingSelector:@selector(compare:)];
    
    BOOL areSorted = [[veeContacts firstObject] isEqual:aliceA] && [[veeContacts lastObject] isEqual:aliceC];
    NSAssert(areSorted, @"Alice A, Alice B and Alice C are not sorted properly");
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
