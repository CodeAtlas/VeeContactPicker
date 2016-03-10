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
@property (nonatomic) ABRecordRef veeContactSuperRecord;
@property (nonatomic) ABRecordRef veecontactUnifiedRecord;

@end

@implementation VeecontactTests

- (void)setUp
{
    [super setUp];
    _veeAddressBookForTesting = [VeeAddressBookForTesting new];
    [_veeAddressBookForTesting addVeeTestingContactsToAddressBook];
    _veeContactSuperRecord = [_veeAddressBookForTesting veeContactSuperRecord];
    _veecontactUnifiedRecord = [_veeAddressBookForTesting veeContactUnifiedRecord];
}

- (void)tearDown
{
    [super tearDown];
    [_veeAddressBookForTesting deleteVeeTestingContactsFromAddressBook];
}

- (void)testVeeContactCreation
{
    VeeContact* veeContactSuper = [self veeContactSuper];
    VeeContact* veeContactUnified = [self veeContactUnified];
    NSAssert(veeContactSuper,@"VeeContact super creation failed");
    NSAssert(veeContactUnified,@"VeeContact unified creation failed");
}

-(void)testVeeContactHasAtLeastOneRecordId
{
    VeeContact* veeContactSuper = [self veeContactSuper];
    BOOL hasVeeContactAtLeastOneRecordId = [[veeContactSuper recordIds] count] > 0;
    NSAssert(hasVeeContactAtLeastOneRecordId,@"VeeContact has no recordIds");
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

-(void)testVeeContactFirstName
{
    VeeContact* veeContactSuper = [self veeContactSuper];
    BOOL isFirstNameCorrect = [veeContactSuper.firstName isEqualToString:kSuperVeeContactFirstName];
    NSAssert(isFirstNameCorrect,@"VeeContact firstName is %@ but should be %@",veeContactSuper.firstName,kSuperVeeContactFirstName);
}

-(void)testVeeContactMiddleName
{
    VeeContact* veeContactSuper = [self veeContactSuper];
    BOOL isMiddleNameCorrect = [veeContactSuper.middleName isEqualToString:kSuperVeeContactMiddleName];
    NSAssert(isMiddleNameCorrect,@"VeeContact middleName is %@ but should be %@",veeContactSuper.middleName,kSuperVeeContactMiddleName);
}

-(void)testVeeContactLastName
{
    VeeContact* veeContactSuper = [self veeContactSuper];
    BOOL isLastNameCorrect = [veeContactSuper.lastName isEqualToString:kSuperVeeContactLastName];
    NSAssert(isLastNameCorrect,@"VeeContact lastName is %@ but should be %@",veeContactSuper.lastName,kSuperVeeContactLastName);
}

-(void)testVeeContactNickname
{
    VeeContact* veeContactSuper = [self veeContactSuper];
    BOOL isNickNameCorrect = [veeContactSuper.nickname isEqualToString:kSuperVeeContactNickname];
    NSAssert(isNickNameCorrect,@"VeeContact nickname is %@ but should be %@",veeContactSuper.nickname,kSuperVeeContactNickname);
}

-(void)testVeeContactOrganizationName
{
    VeeContact* veeContactSuper = [self veeContactSuper];
    BOOL isveeContactSuperOrganizationNameCorrect = [veeContactSuper.organizationName isEqualToString:kSuperVeeContactOrganizationName];
    NSAssert(isveeContactSuperOrganizationNameCorrect,@"VeeContact organizationName is %@ but should be %@",veeContactSuper.organizationName,kSuperVeeContactOrganizationName);
}

-(void)testVeeContactCompositeName
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

-(void)testVeeContactDisplayName
{
    VeeContact* veeContactSuper = [self veeContactSuper];
    BOOL isDisplayNameCorrect = [veeContactSuper.displayName isEqualToString:kSuperVeeContactDisplayName];
    NSAssert(isDisplayNameCorrect,@"VeeContact displayName is %@ but should be %@",veeContactSuper.displayName,kSuperVeeContactDisplayName);
}

-(void)testVeeContactDisplayNameWithoutFirstName
{
    VeeContact* veeContactSuper = [self veeContactSuper];
    [self nullifyIvarWithName:@"firstName" ofObject:veeContactSuper];

    NSString* aspectedDisplayName = veeContactSuper.organizationName;
    
    BOOL isDisplayNameCorrect = [veeContactSuper.displayName isEqualToString:aspectedDisplayName];
    NSAssert(isDisplayNameCorrect,@"VeeContact displayName is %@ but should be %@",veeContactSuper.displayName,aspectedDisplayName);
}

-(void)testVeeContactDisplayNameWithoutLastName
{
    VeeContact* veeContactSuper = [self veeContactSuper];
    [self nullifyIvarWithName:@"lastName" ofObject:veeContactSuper];

    NSString* aspectedDisplayName = veeContactSuper.organizationName;
    
    BOOL isDisplayNameCorrect = [veeContactSuper.displayName isEqualToString:aspectedDisplayName];
    NSAssert(isDisplayNameCorrect,@"VeeContact displayName is %@ but should be %@",veeContactSuper.displayName,aspectedDisplayName);
}

-(void)testVeeContactDisplayNameWithoutFirstNameAndOrganization
{
    VeeContact* veeContactSuper = [self veeContactSuper];
    [self nullifyIvarWithName:@"firstName" ofObject:veeContactSuper];
    [self nullifyIvarWithName:@"organizationName" ofObject:veeContactSuper];
    
    NSString* aspectedDisplayName = veeContactSuper.lastName;
    
    BOOL isDisplayNameCorrect = [veeContactSuper.displayName isEqualToString:aspectedDisplayName];
    NSAssert(isDisplayNameCorrect,@"VeeContact displayName is %@ but should be %@",veeContactSuper.displayName,aspectedDisplayName);
}

-(void)testVeeContactDisplayNameWithoutLastNameAndOrganization
{
    VeeContact* veeContactSuper = [self veeContactSuper];
    [self nullifyIvarWithName:@"lastName" ofObject:veeContactSuper];
    [self nullifyIvarWithName:@"organizationName" ofObject:veeContactSuper];
    
    NSString* aspectedDisplayName = veeContactSuper.firstName;
    
    BOOL isDisplayNameCorrect = [veeContactSuper.displayName isEqualToString:aspectedDisplayName];
    NSAssert(isDisplayNameCorrect,@"VeeContact displayName is %@ but should be %@",veeContactSuper.displayName,aspectedDisplayName);
}

-(void)testVeeContactDisplayNameWithoutFirstNameLastNameAndOrganization
{
    VeeContact* veeContactSuper = [self veeContactSuper];
    [self nullifyIvarWithName:@"firstName" ofObject:veeContactSuper];
    [self nullifyIvarWithName:@"lastName" ofObject:veeContactSuper];
    [self nullifyIvarWithName:@"organizationName" ofObject:veeContactSuper];
    
    NSString* aspectedDisplayName = veeContactSuper.middleName;
    
    BOOL isDisplayNameCorrect = [veeContactSuper.displayName isEqualToString:aspectedDisplayName];
    NSAssert(isDisplayNameCorrect,@"VeeContact displayName is %@ but should be %@",veeContactSuper.displayName,aspectedDisplayName);
}

-(void)testVeeContactDisplayNameWithoutFirstNameLastNameMiddleNameAndOrganization
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

-(void)testVeeContactDisplayNameWithoutFirstNameLastNameMiddleNameNicknameAndOrganization
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

-(void)testVeeContactEmptyDisplayName
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
    NSAssert(_veeContactSuperRecord, @"_veeContactSuperRecord is not initialized");
    VeeContact* veeContactSuper = [[VeeContact alloc] initWithLinkedPeopleOfABRecord:_veeContactSuperRecord];
    return veeContactSuper;
}

-(VeeContact*)veeContactUnified
{
    NSAssert(_veecontactUnifiedRecord, @"_veecontactUnifiedRecord is not initialized");
    VeeContact* veeContactUnified = [[VeeContact alloc] initWithLinkedPeopleOfABRecord:_veecontactUnifiedRecord];
    return veeContactUnified;
}

-(BOOL)isEmailAddress:(NSString*)canBeAnEmail
{
    if ([canBeAnEmail containsString:@"@"]){
        return YES;
    }
    return NO;
}

@end
