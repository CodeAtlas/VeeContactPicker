//
//  VeeAddressBookForTestingConstants.m
//  VeeContactPicker
//
//  Created by Andrea Cipriani on 10/03/16.
//  Copyright © 2016 Code Atlas SRL. All rights reserved.
//

#import "VeeAddressBookForTestingConstants.h"

@implementation VeeAddressBookForTestingConstants

NSString* const kVCFFileName = @"vee_testing_ab";

NSString* const kVeeTestingContactsSignature = @"a8a8f8738b79cd660f519c1a342654a0";

#pragma mark - Testing contacts
NSInteger const kVeeTestingContactsNumber = 21;
NSInteger const kVeeTestingContactsWithImage = 11;
NSInteger const kVeeTestingContactsPhoneNumbersCount = 32;
NSInteger const kVeeTestingContactsEmailsCount = 34;

#pragma mark - Complete contact
NSString* const kCompleteVeeContactFirstName = @"Complete";
NSString* const kCompleteVeeContactMiddleName = @"middle";
NSString* const kCompleteVeeContactLastName = @"Contact";
NSString* const kCompleteVeeContactNickname = @"Supername";
NSString* const kCompleteVeeContactOrganizationName = @"Fake SRL";
NSString* const kCompleteVeeContactCompositeName = @"Complete middle Contact";
NSString* const kCompleteVeeContactDisplayName = @"Complete middle Contact";
NSInteger const kCompleteVeeContactPhoneNumbersCount = 5;
NSInteger const kCompleteVeeContactEmailsCount = 4;
NSInteger const kCompleteVeeContactPostalAddressesCount = 1;
NSString* const kCompleteVeeContactPostalCorsoSempioneStreet = @"Corso Sempione";
NSString* const kCompleteVeeContactPostalCorsoSempioneCity = @"Milano";
NSString* const kCompleteVeeContactPostalCorsoSempioneState = @"Lombardia";
NSString* const kCompleteVeeContactPostalCorsoSempionePostal = @"20035";
NSString* const kCompleteVeeContactPostalCorsoSempioneCountry = @"Italia";
NSInteger const kCompleteVeeContactWebsitesCount = 4;
NSString* const kCompleteVeeContactSectionIdentifier = @"C";
NSString* const kCompleteVeeContactWithoutFirstNameSectionIdentifier = @"C";
NSString* const kCompleteVeeContactWithoutFirstNameAndLastNameSectionIdentifier = @"F";
NSString* const kCompleteVeeContactEmptyDisplayNameSectionIdentifier = @"#";

#pragma mark - Unified contact
NSString* const kUnifiedVeecontactFirstName = @"Unified";

@end