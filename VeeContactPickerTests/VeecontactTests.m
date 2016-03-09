//
//  VeecontactTests.m
//  VeeContactPicker
//
//  Created by Andrea Cipriani on 08/03/16.
//  Copyright © 2016 Code Atlas SRL. All rights reserved.
//

#import "VeeMockAddressBook.h"
#import <OCMock/OCMock.h>
#import <XCTest/XCTest.h>
#import "VeeContact.h"

#define VEE_MOCK_SUPERCONTACT_FIRSTNAME @"Super"
#define VEE_MOCK_SUPERCONTACT_MIDDLENAME @"middle"
#define VEE_MOCK_SUPERCONTACT_LASTNAME @"Contact"
#define VEE_MOCK_SUPERCONTACT_NICKNAME @"Supername"


@interface VeecontactTests : XCTestCase

@property (nonatomic, strong) VeeMockAddressBook* veeMockAddressBook;
@property (nonatomic) ABRecordRef veeMockSuperContactRecord;

@end

@implementation VeecontactTests

- (void)setUp
{
    [super setUp];
    _veeMockAddressBook = [VeeMockAddressBook new];
    [_veeMockAddressBook addVeeMockContactsToAddressBook];
    _veeMockSuperContactRecord = [_veeMockAddressBook veeMockSuperContact];
}

- (void)tearDown
{
    [super tearDown];
    [_veeMockAddressBook deleteVeeMockContactsFromAddressBook];
}

- (void)testVeecontactCreation
{
    VeeContact* veeMockSuperContact = [self veeMockSuperContact];
    NSAssert(veeMockSuperContact,@"veecontact creation failed");
}

-(void)testVeecontactFirstName
{
    VeeContact* veeMockSuperContact = [self veeMockSuperContact];
    BOOL isVeeMockSuperContactFirstNameCorrect = [veeMockSuperContact.firstName isEqualToString:VEE_MOCK_SUPERCONTACT_FIRSTNAME];
    NSAssert(isVeeMockSuperContactFirstNameCorrect,@"veecontact first name isn't correct");
}

-(void)testVeecontactMiddleName
{
    VeeContact* veeMockSuperContact = [self veeMockSuperContact];
    BOOL isVeeMockSuperContactMiddleNameCorrect = [veeMockSuperContact.middleName isEqualToString:VEE_MOCK_SUPERCONTACT_MIDDLENAME];
    NSAssert(isVeeMockSuperContactMiddleNameCorrect,@"veecontact middle name isn't correct");
}

-(void)testVeecontactLastName
{
    VeeContact* veeMockSuperContact = [self veeMockSuperContact];
    BOOL isVeeMockSuperContactMiddleNameCorrect = [veeMockSuperContact.lastName isEqualToString:VEE_MOCK_SUPERCONTACT_LASTNAME];
    NSAssert(isVeeMockSuperContactMiddleNameCorrect,@"veecontact last name isn't correct");
}

-(void)testVeecontactNickname
{
    VeeContact* veeMockSuperContact = [self veeMockSuperContact];
    BOOL isVeeMockSuperContactNickameCorrect = [veeMockSuperContact.nickname isEqualToString:VEE_MOCK_SUPERCONTACT_NICKNAME];
    NSAssert(isVeeMockSuperContactNickameCorrect,@"veecontact nickname isn't correct");
}


#pragma mark - Private utils

-(VeeContact*)veeMockSuperContact
{
    NSAssert(_veeMockSuperContactRecord, @"veeMockSuperContactRecord is not initialized");
    VeeContact* veeMockSuperContact = [[VeeContact alloc] initWithLinkedPeopleOfABRecord:_veeMockSuperContactRecord];
    return veeMockSuperContact;
}

@end
