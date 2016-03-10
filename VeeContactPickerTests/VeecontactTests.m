//
//  VeecontactTests.m
//  VeeContactPicker
//
//  Created by Andrea Cipriani on 08/03/16.
//  Copyright © 2016 Code Atlas SRL. All rights reserved.
//

#import "VeeAddressBookForTesting.h"
#import <OCMock/OCMock.h>
#import <XCTest/XCTest.h>
#import "VeeContact.h"
#import "XCTest+VeeCommons.h"
#import "VeeAddressBookForTestingConstants.h"

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

- (void)testSingleVeeContactCreation
{
    VeeContact* veeContactSuper = [self veeContactSuper];
    NSAssert(veeContactSuper,@"VeeContact super creation failed");
}

- (void)testVeeContactsCreation
{
    NSArray* veeContacts = [self veeContactsFromAddressBookForTesting];
    BOOL isVeeContactsCountCorrect = [veeContacts count] == kVeeTestingContactsNumber;
    NSAssert(isVeeContactsCountCorrect,@"Loaded %zd contacts from abForTesting, but they should be %zd",[veeContacts count],kVeeTestingContactsNumber);
}

-(void)testVeeContactsRecordIdExist
{
    for (VeeContact* veeContact in [self veeContactsFromAddressBookForTesting]){
        BOOL hasAtLeastOneRecordId = [[veeContact recordIds] count] > 0;
        NSAssert(hasAtLeastOneRecordId,@"VeeContact %@ has no recordIds",veeContact.displayName);
    }
}

/*
 
 TODO: unifiedContact is recognized as one contact from the vcf
 
-(void)testUnifiedVeeContactRecordIds
{
    VeeContact* veeContactUnified = [self veeContactUnified];
    int aspectedNumberOfRecordIds = 3;
    BOOL hasThreeRecordIds = [[veeContactUnified recordIds] count] == aspectedNumberOfRecordIds;
    NSAssert(hasThreeRecordIds,@"VeeContact has %zd recordIds, but it should have %zd recordIds",[veeContactUnified.recordIds count],aspectedNumberOfRecordIds);
}
*/

-(void)testCreatedAtExist
{
    for (VeeContact* veeContact in [self veeContactsFromAddressBookForTesting]){
        NSAssert(veeContact.createdAt,@"VeeContact unified has no createdAt date");
    }
}

-(void)testModifiedAtExist
{
    for (VeeContact* veeContact in [self veeContactsFromAddressBookForTesting]){
        NSAssert(veeContact.modifiedAt,@"VeeContact unified has no modifiedAt date");
    }
}

-(void)testCreatedAtCantBeAfterModifiedAt
{
    for (VeeContact* veeContact in [self veeContactsFromAddressBookForTesting]){
        BOOL isVeeContactCreatedBeforeOrEqualeModifiedAt = [veeContact.createdAt compare:veeContact.modifiedAt] == NSOrderedSame || [veeContact.createdAt compare:veeContact.modifiedAt] == NSOrderedDescending;
        NSAssert(isVeeContactCreatedBeforeOrEqualeModifiedAt, @"Veecontact %@ createdAt %@, that is after its modifiedAt: %@",veeContact.displayName,veeContact.createdAt,veeContact.modifiedAt);
    }
}

-(void)testVeeContactSuperFirstName
{
    VeeContact* veeContactSuper = [self veeContactSuper];
    BOOL isFirstNameCorrect = [veeContactSuper.firstName isEqualToString:kSuperVeeContactFirstName];
    NSAssert(isFirstNameCorrect,@"VeeContact firstName is %@ but should be %@",veeContactSuper.firstName,kSuperVeeContactFirstName);
}

-(void)testVeeContactSuperMiddleName
{
    VeeContact* veeContactSuper = [self veeContactSuper];
    BOOL isMiddleNameCorrect = [veeContactSuper.middleName isEqualToString:kSuperVeeContactMiddleName];
    NSAssert(isMiddleNameCorrect,@"VeeContact middleName is %@ but should be %@",veeContactSuper.middleName,kSuperVeeContactMiddleName);
}

-(void)testVeeContactSuperLastName
{
    VeeContact* veeContactSuper = [self veeContactSuper];
    BOOL isLastNameCorrect = [veeContactSuper.lastName isEqualToString:kSuperVeeContactLastName];
    NSAssert(isLastNameCorrect,@"VeeContact lastName is %@ but should be %@",veeContactSuper.lastName,kSuperVeeContactLastName);
}

-(void)testVeeContactSuperNickname
{
    VeeContact* veeContactSuper = [self veeContactSuper];
    BOOL isNickNameCorrect = [veeContactSuper.nickname isEqualToString:kSuperVeeContactNickname];
    NSAssert(isNickNameCorrect,@"VeeContact nickname is %@ but should be %@",veeContactSuper.nickname,kSuperVeeContactNickname);
}

-(void)testVeeContactSuperOrganizationName
{
    VeeContact* veeContactSuper = [self veeContactSuper];
    BOOL isveeContactSuperOrganizationNameCorrect = [veeContactSuper.organizationName isEqualToString:kSuperVeeContactOrganizationName];
    NSAssert(isveeContactSuperOrganizationNameCorrect,@"VeeContact organizationName is %@ but should be %@",veeContactSuper.organizationName,kSuperVeeContactOrganizationName);
}

-(void)testVeeContactSuperCompositeName
{
    /*
     Composite name: The concatenated value of these properties: Prefix, Suffix, Organization, First name, and Last name.
     */
    VeeContact* veeContactSuper = [self veeContactSuper];
    BOOL isCompositeNameCorrect = [veeContactSuper.compositeName isEqualToString:kSuperVeeContactCompositeName];
    NSAssert(isCompositeNameCorrect,@"VeeContact compositeName is %@ but should be %@",veeContactSuper.compositeName,kSuperVeeContactCompositeName);
}

/*
 Display name depends on which field is not nil, this is the order of preferences: "FirstName LastName" - "OrganizationName" - "LastName" - "First Name" - "Middle Name" - "Nickname" - "emailAddress"
 */

-(void)testVeeContactSuperDisplayName
{
    VeeContact* veeContactSuper = [self veeContactSuper];
    BOOL isDisplayNameCorrect = [veeContactSuper.displayName isEqualToString:kSuperVeeContactDisplayName];
    NSAssert(isDisplayNameCorrect,@"VeeContact displayName is %@ but should be %@",veeContactSuper.displayName,kSuperVeeContactDisplayName);
}

-(void)testVeeContactSuperDisplayNameWithoutFirstName
{
    VeeContact* veeContactSuper = [self veeContactSuper];
    [self nullifyIvarWithName:@"firstName" ofObject:veeContactSuper];

    NSString* aspectedDisplayName = veeContactSuper.organizationName;
    
    BOOL isDisplayNameCorrect = [veeContactSuper.displayName isEqualToString:aspectedDisplayName];
    NSAssert(isDisplayNameCorrect,@"VeeContact displayName is %@ but should be %@",veeContactSuper.displayName,aspectedDisplayName);
}

-(void)testVeeContactSuperDisplayNameWithoutLastName
{
    VeeContact* veeContactSuper = [self veeContactSuper];
    [self nullifyIvarWithName:@"lastName" ofObject:veeContactSuper];

    NSString* aspectedDisplayName = veeContactSuper.organizationName;
    
    BOOL isDisplayNameCorrect = [veeContactSuper.displayName isEqualToString:aspectedDisplayName];
    NSAssert(isDisplayNameCorrect,@"VeeContact displayName is %@ but should be %@",veeContactSuper.displayName,aspectedDisplayName);
}

-(void)testVeeContactSuperDisplayNameWithoutFirstNameAndOrganization
{
    VeeContact* veeContactSuper = [self veeContactSuper];
    [self nullifyIvarWithName:@"firstName" ofObject:veeContactSuper];
    [self nullifyIvarWithName:@"organizationName" ofObject:veeContactSuper];
    
    NSString* aspectedDisplayName = veeContactSuper.lastName;
    
    BOOL isDisplayNameCorrect = [veeContactSuper.displayName isEqualToString:aspectedDisplayName];
    NSAssert(isDisplayNameCorrect,@"VeeContact displayName is %@ but should be %@",veeContactSuper.displayName,aspectedDisplayName);
}

-(void)testVeeContactSuperDisplayNameWithoutLastNameAndOrganization
{
    VeeContact* veeContactSuper = [self veeContactSuper];
    [self nullifyIvarWithName:@"lastName" ofObject:veeContactSuper];
    [self nullifyIvarWithName:@"organizationName" ofObject:veeContactSuper];
    
    NSString* aspectedDisplayName = veeContactSuper.firstName;
    
    BOOL isDisplayNameCorrect = [veeContactSuper.displayName isEqualToString:aspectedDisplayName];
    NSAssert(isDisplayNameCorrect,@"VeeContact displayName is %@ but should be %@",veeContactSuper.displayName,aspectedDisplayName);
}

-(void)testVeeContactSuperDisplayNameWithoutFirstNameLastNameAndOrganization
{
    VeeContact* veeContactSuper = [self veeContactSuper];
    [self nullifyIvarWithName:@"firstName" ofObject:veeContactSuper];
    [self nullifyIvarWithName:@"lastName" ofObject:veeContactSuper];
    [self nullifyIvarWithName:@"organizationName" ofObject:veeContactSuper];
    
    NSString* aspectedDisplayName = veeContactSuper.middleName;
    
    BOOL isDisplayNameCorrect = [veeContactSuper.displayName isEqualToString:aspectedDisplayName];
    NSAssert(isDisplayNameCorrect,@"VeeContact displayName is %@ but should be %@",veeContactSuper.displayName,aspectedDisplayName);
}

-(void)testVeeContactSuperDisplayNameWithoutFirstNameLastNameMiddleNameAndOrganization
{
    VeeContact* veeContactSuper = [self veeContactSuper];
    [self nullifyIvarWithName:@"firstName" ofObject:veeContactSuper];
    [self nullifyIvarWithName:@"lastName" ofObject:veeContactSuper];
    [self nullifyIvarWithName:@"middleName" ofObject:veeContactSuper];
    [self nullifyIvarWithName:@"organizationName" ofObject:veeContactSuper];
    
    NSString* aspectedDisplayName = veeContactSuper.nickname;

    BOOL isDisplayNameCorrect = [veeContactSuper.displayName isEqualToString:aspectedDisplayName];
    NSAssert(isDisplayNameCorrect,@"VeeContact displayName is %@ but should be %@",veeContactSuper.displayName,aspectedDisplayName);
}

-(void)testVeeContactSuperDisplayNameWithoutFirstNameLastNameMiddleNameNicknameAndOrganization
{
    VeeContact* veeContactSuper = [self veeContactSuper];
    [self nullifyIvarWithName:@"firstName" ofObject:veeContactSuper];
    [self nullifyIvarWithName:@"lastName" ofObject:veeContactSuper];
    [self nullifyIvarWithName:@"middleName" ofObject:veeContactSuper];
    [self nullifyIvarWithName:@"nickname" ofObject:veeContactSuper];
    [self nullifyIvarWithName:@"organizationName" ofObject:veeContactSuper];
    
    BOOL isDisplayNameCorrect = [self isEmailAddress:veeContactSuper.displayName];
    NSAssert(isDisplayNameCorrect,@"VeeContact displayName is %@ but should be an email address",veeContactSuper.displayName);
}

-(void)testVeeContactSuperEmptyDisplayName
{
    VeeContact* veeContactSuper = [self veeContactSuper];
    [self nullifyIvarWithName:@"firstName" ofObject:veeContactSuper];
    [self nullifyIvarWithName:@"lastName" ofObject:veeContactSuper];
    [self nullifyIvarWithName:@"middleName" ofObject:veeContactSuper];
    [self nullifyIvarWithName:@"nickname" ofObject:veeContactSuper];
    [self nullifyIvarWithName:@"organizationName" ofObject:veeContactSuper];
    [self nullifyIvarWithName:@"emailsMutable" ofObject:veeContactSuper];

    NSString* aspectedDisplayName = @"";
    
    BOOL isDisplayNameCorrect = [veeContactSuper.displayName isEqualToString:aspectedDisplayName];
    NSAssert(isDisplayNameCorrect,@"VeeContact displayName is %@ but should be %@",veeContactSuper.displayName,aspectedDisplayName);
}

#pragma mark - Private utils

-(VeeContact*)veeContactSuper
{
    VeeContact* veeContactSuper = [[VeeContact alloc] initWithLinkedPeopleOfABRecord:[_veeAddressBookForTesting veeContactSuperRecord]];
    return veeContactSuper;
}

-(VeeContact*)veeContactUnified
{
    VeeContact* veeContactUnified = [[VeeContact alloc] initWithLinkedPeopleOfABRecord:[_veeAddressBookForTesting veeContactUnifiedRecord]];
    return veeContactUnified;
}

-(NSArray*)veeContactsFromAddressBookForTesting
{
    NSMutableArray * veeContactsFromABForTestingMutable = [NSMutableArray new];
    for (id abRecordRefBoxed in [_veeAddressBookForTesting recordRefsOfAddressBookForTesting]){
        VeeContact* veeContact = [[VeeContact alloc] initWithLinkedPeopleOfABRecord:(__bridge ABRecordRef)(abRecordRefBoxed)];
        [veeContactsFromABForTestingMutable addObject:veeContact];
    }
    return [NSArray arrayWithArray:veeContactsFromABForTestingMutable];
}

-(BOOL)isEmailAddress:(NSString*)canBeAnEmail
{
    if ([canBeAnEmail containsString:@"@"]){
        return YES;
    }
    return NO;
}

@end
