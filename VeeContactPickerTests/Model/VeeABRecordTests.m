//
//  Created by Andrea Cipriani on 22/03/16.
//  Copyright © 2016 Code Atlas SRL. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "VeeABRecord.h"
#import "VeeAddressBookForTesting.h"
#import "VeeAddressBookForTestingConstants.h"

@interface VeeABRecordTests : XCTestCase

@property (nonatomic,strong) VeeABRecord* veeABRecordComplete;
@property (nonatomic,strong) VeeABRecord* veeABRecordUnified;
@property (nonatomic,strong) NSArray<VeeABRecord*>* veeABRecordsForTesting;

@end

static VeeAddressBookForTesting* veeAddressBookForTesting;

@implementation VeeABRecordTests

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
    _veeABRecordComplete = [[VeeABRecord alloc] initWithLinkedPeopleOfABRecord:[veeAddressBookForTesting abRecordRefOfCompleteContact]];
    _veeABRecordUnified = [[VeeABRecord alloc] initWithLinkedPeopleOfABRecord:[veeAddressBookForTesting abRecordRefOfUnifiedContact]];
    _veeABRecordsForTesting = [self veeABRecordsFromAddressBookForTesting];
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

-(void)testCompleteContactPostalAddresses
{
    BOOL isPostalAddressesCountCorrect = [_veeABRecordComplete.postalAddresses count] == kCompleteVeeContactPostalAddressesCount;
    NSAssert(isPostalAddressesCountCorrect, @"Contact complete postals count is %zd but should be %zd", [_veeABRecordComplete.postalAddresses count], kCompleteVeeContactPostalAddressesCount);
}

-(void)testCompleteContactPostalAddressMilanoCorsoSempione
{
    NSDictionary* corsoSempioneDict;
    for (NSDictionary* postalAddressDict in _veeABRecordComplete.postalAddresses){
        if ([postalAddressDict[@"street"] isEqualToString:@"Corso Sempione"]){
            corsoSempioneDict = postalAddressDict;
        }
    }
    
    NSAssert(corsoSempioneDict,@"Corso Sempione address not found");

    BOOL isStreetCorrect = [corsoSempioneDict[@"street"] isEqualToString:kCompleteVeeContactPostalCorsoSempioneStreet];
    BOOL isCityCorrect = [corsoSempioneDict[@"city"] isEqualToString:kCompleteVeeContactPostalCorsoSempioneCity];
    BOOL isStateCorrect = [corsoSempioneDict[@"state"] isEqualToString:kCompleteVeeContactPostalCorsoSempioneState];
    BOOL isPostalCorrect = [corsoSempioneDict[@"postal"] isEqualToString:kCompleteVeeContactPostalCorsoSempionePostal];
    BOOL isCountryCorrect = [corsoSempioneDict[@"country"] isEqualToString:kCompleteVeeContactPostalCorsoSempioneCountry];

    NSAssert(isStreetCorrect, @"Contact complete postal street is %@ but should be %@", corsoSempioneDict[@"street"], kCompleteVeeContactPostalCorsoSempioneStreet);
    NSAssert(isCityCorrect, @"Contact complete postal street is %@ but should be %@", corsoSempioneDict[@"city"], kCompleteVeeContactPostalCorsoSempioneCity);
    NSAssert(isStateCorrect, @"Contact complete postal street is %@ but should be %@", corsoSempioneDict[@"state"], kCompleteVeeContactPostalCorsoSempioneState);
    NSAssert(isPostalCorrect, @"Contact complete postal street is %@ but should be %@", corsoSempioneDict[@"postal"], kCompleteVeeContactPostalCorsoSempionePostal);
    NSAssert(isCountryCorrect, @"Contact complete postal street is %@ but should be %@", corsoSempioneDict[@"country"], kCompleteVeeContactPostalCorsoSempioneCountry);
}

-(void)testCompleteContactWebsitesCount
{
    BOOL isWebsitesCountCorrect = [_veeABRecordComplete.websites count] == kCompleteVeeContactWebsitesCount;
    NSAssert(isWebsitesCountCorrect, @"Contact websites count is %zd but should be %zd", [_veeABRecordComplete.websites count], kCompleteVeeContactWebsitesCount);
}

-(void)testCompleteContactWebsites
{
    NSArray* expectedWebsites = @[@"www.duplicate.com",@"http://www.completework.it",@"www.complete.blog.it",@"http://www.completeuser.it"];
    expectedWebsites = [expectedWebsites sortedArrayUsingSelector:@selector(compare:)];
    NSArray* completContactSortedWebistes = [_veeABRecordComplete.websites sortedArrayUsingSelector:@selector(compare:)];
    BOOL websitesAreCorrect = [completContactSortedWebistes isEqualToArray:expectedWebsites];
    NSAssert(websitesAreCorrect, @"Contact websites are %@ but they should be ",_veeABRecordComplete.websites, expectedWebsites);
}

-(void)testCompleteContactTwitterAccounts
{
    BOOL isTwitterCorrect = [[_veeABRecordComplete twitterAccounts] containsObject:kCompleteVeeContactTwitterAccount];
    NSAssert(isTwitterCorrect,@"Complete contact should have a Twitter account: %@, but Twitter accounts are: %@",kCompleteVeeContactTwitterAccount,[_veeABRecordComplete twitterAccounts]);
}

-(void)testCompleteContactFacebookAccounts
{
    BOOL isFacebookAccountCorrect = [[_veeABRecordComplete facebookAccounts] containsObject:kCompleteVeeContactFacebookAccount];
    NSAssert(isFacebookAccountCorrect,@"Complete contact should have a Facebook account: %@, but Facebook accounts are: %@",kCompleteVeeContactFacebookAccount,[_veeABRecordComplete facebookAccounts]);
}

//Test multiple postal addresses


#pragma mark - Unified Veecontact

//TODO: ... Can't test unified contacts because I can't reproduce linked records in the address book programmatically, see http://stackoverflow.com/questions/24224929/is-there-a-way-to-programmatically-create-linked-contact

#pragma mark - VeecontactsForTesting tests

- (void)testTestingRecordsCreationCount
{
    BOOL isVeeContactsCountCorrect = [_veeABRecordsForTesting count] == kVeeTestingContactsNumber;
    NSAssert(isVeeContactsCountCorrect, @"Loaded %zd contacts from abForTesting, but they should be %zd", [_veeABRecordsForTesting count], kVeeTestingContactsNumber);
}

- (void)testRecordIdExist
{
    for (VeeABRecord* veeABRecord in _veeABRecordsForTesting) {
        BOOL hasAtLeastOneRecordId = [[veeABRecord recordIds] count] > 0;
        NSAssert(hasAtLeastOneRecordId, @"Contact %@ has no recordIds", veeABRecord.compositeName);
    }
}

- (void)testCreatedAtExist
{
    for (VeeABRecord* veeABRecord in _veeABRecordsForTesting) {
        NSAssert(veeABRecord.createdAt, @"Contact unified has no createdAt date");
    }
}

- (void)testModifiedAtExist
{
    for (VeeABRecord* veeABRecord in _veeABRecordsForTesting) {
        NSAssert(veeABRecord.modifiedAt, @"Contact unified has no modifiedAt date");
    }
}

- (void)testCreatedAtCantBeAfterModifiedAt
{
    for (VeeABRecord* veeABRecord in _veeABRecordsForTesting) {
        BOOL isCreatedAtBeforeOrEqualeModifiedAt = [veeABRecord.createdAt compare:veeABRecord.modifiedAt] == NSOrderedSame || [veeABRecord.createdAt compare:veeABRecord.modifiedAt] == NSOrderedAscending;
        NSAssert(isCreatedAtBeforeOrEqualeModifiedAt, @"%@ createdAt %@, that is after its modifiedAt: %@", veeABRecord.compositeName, veeABRecord.createdAt, veeABRecord.modifiedAt);
    }
}

- (void)testImageCount
{
    NSUInteger imageCount = 0;
    for (VeeABRecord* veeABRecord in _veeABRecordsForTesting) {
        if (veeABRecord.thumbnailImage) {
            imageCount++;
        }
    }
    
    BOOL isImageCountCorrect = imageCount == kVeeTestingContactsWithImage;
    NSAssert(isImageCountCorrect, @"Contacts with image are %zd, but they should be %zd", imageCount, kVeeTestingContactsWithImage);
}

- (void)testPhoneNumbersCount
{
    NSUInteger phoneNumbersCount = 0;
    for (VeeABRecord* veeABRecord in _veeABRecordsForTesting) {
        phoneNumbersCount += [[veeABRecord phoneNumbers] count];
    }
    
    BOOL isPhoneNumberCountCorrect = phoneNumbersCount == kVeeTestingContactsPhoneNumbersCount;
    NSAssert(isPhoneNumberCountCorrect, @"Phone numbers are %ld, but they should be %ld", phoneNumbersCount, kVeeTestingContactsPhoneNumbersCount);
}

- (void)testPhoneNumberDuplicates
{
    for (VeeABRecord* veeABRecord in _veeABRecordsForTesting) {
        NSSet* phoneNumberSet = [NSSet setWithArray:veeABRecord.phoneNumbers];
        NSAssert([phoneNumberSet count] == [veeABRecord.phoneNumbers count], @"Phone numbers contain duplicates!");
    }
}

- (void)testEmailsCount
{
    NSUInteger emailsCount = 0;
    for (VeeABRecord* veeABRecord in _veeABRecordsForTesting) {
        emailsCount += [[veeABRecord emails] count];
    }
    
    BOOL isEmailCountCorrect = emailsCount == kVeeTestingContactsEmailsCount;
    NSAssert(isEmailCountCorrect, @"Phone numbers are %ld, but they should be %ld", emailsCount, kVeeTestingContactsEmailsCount);
}

- (void)testEmailsNoDuplicate
{
    for (VeeABRecord* veeABRecord in _veeABRecordsForTesting) {
        NSSet* emailSet = [NSSet setWithArray:veeABRecord.emails];
        NSAssert([emailSet count] == [veeABRecord.emails count], @"Emails contain duplicates!");
    }
}

#pragma mark - Private utils

-(NSArray*)veeABRecordsFromAddressBookForTesting
{
    NSMutableArray* veeABRecordsMutable = [NSMutableArray new];
    for (id abRecordRefBoxed in [veeAddressBookForTesting abRecordRefsOfTestingContacts]){
        [veeABRecordsMutable addObject:[[VeeABRecord alloc] initWithLinkedPeopleOfABRecord:(__bridge ABRecordRef)(abRecordRefBoxed)]];
    }
    return [NSArray arrayWithArray:veeABRecordsMutable];
}

@end
