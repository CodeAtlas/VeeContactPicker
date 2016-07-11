//
//  Created by Andrea Cipriani on 22/03/16.
//  Copyright © 2016 Code Atlas SRL. All rights reserved.
//

#import "VeeABRecord.h"

@interface VeeABRecord ()

@property (nonatomic, strong) NSMutableSet<NSNumber*>* recordIdsMutable;
@property (nonatomic, strong) NSMutableSet<NSString*>* phoneNumbersMutable;
@property (nonatomic, strong) NSMutableSet<NSString*>* emailsMutable;
@property (nonatomic, strong) NSMutableSet<NSDictionary*>* postalAddressesMutable;
@property (nonatomic, strong) NSMutableSet<NSString*>* websitesMutable;
@property (nonatomic, strong) NSMutableSet<NSString*>* twitterAccountsMutable;
@property (nonatomic, strong) NSMutableSet<NSString*>* facebookAccountsMutable;

@end

@implementation VeeABRecord

#pragma mark - Init

- (instancetype)initWithLinkedPeopleOfABRecord:(ABRecordRef)abRecord
{
    self = [super init];
    if (self) {
        NSAssert(abRecord, @"abRecord must exist");
        [self createWithLinkedPeopleFromABRecord:abRecord];
    }
    return self;
}

#pragma mark - Initalization utils

- (void)createWithLinkedPeopleFromABRecord:(ABRecordRef)abRecord
{
    NSArray* linkedPeople = CFBridgingRelease(ABPersonCopyArrayOfAllLinkedPeople(abRecord));
    for (int i = 0; i < linkedPeople.count; i++) {
        ABRecordRef linkedABRecord = CFArrayGetValueAtIndex((__bridge CFArrayRef)(linkedPeople), i);
        [self updateFromABRecord:linkedABRecord];
    }
}

- (void)updateFromABRecord:(ABRecordRef)abRecord
{
    [self addRecordIdFromABRecord:abRecord];
    [self updateDatesIfEmptyFromABRecord:abRecord];
    [self updateNameComponentsIfEmptyFromABRecord:abRecord];
    [self updateThumbnailImageIfEmptyFromABRecord:abRecord];
    [self addPhoneNumbersFromABRecord:abRecord];
    [self addEmailsFromABRecord:abRecord];
    [self addPostalAddressesFromABRecord:abRecord];
    [self addWebsitesFromABRecord:abRecord];
    [self addSocialAccountsFromPerson:abRecord];
}

- (void)addRecordIdFromABRecord:(ABRecordRef)abRecord
{
    NSNumber* recordId = [NSNumber numberWithInt:ABRecordGetRecordID(abRecord)];
    if (_recordIdsMutable == nil) {
        _recordIdsMutable = [NSMutableSet new];
    }
    [_recordIdsMutable addObject:recordId];
}

- (void)updateDatesIfEmptyFromABRecord:(ABRecordRef)abRecord
{
    [self updateCreatedFromABRecordIfItsAfter:abRecord];
    [self updateModifiedFromABRecordRefIfItsAfter:abRecord];
}

- (void)updateCreatedFromABRecordIfItsAfter:(ABRecordRef)abRecord
{
    if (!_createdAt) {
        _createdAt = (__bridge_transfer NSDate*)ABRecordCopyValue(abRecord, kABPersonCreationDateProperty);
        return;
    }
    NSDate* abRecordCreatedAt = (__bridge_transfer NSDate*)ABRecordCopyValue(abRecord, kABPersonCreationDateProperty);
    BOOL abRecordIsCreatedAfterThanSelf = [_createdAt compare:abRecordCreatedAt] == NSOrderedAscending;
    if (abRecordIsCreatedAfterThanSelf) {
        _createdAt = abRecordCreatedAt;
    }
}

- (void)updateModifiedFromABRecordRefIfItsAfter:(ABRecordRef)abRecord
{
    if (!_modifiedAt) {
        _modifiedAt = (__bridge_transfer NSDate*)ABRecordCopyValue(abRecord, kABPersonModificationDateProperty);
    }
    NSDate* abRecordModifiedAt = (__bridge_transfer NSDate*)ABRecordCopyValue(abRecord, kABPersonModificationDateProperty);
    BOOL abRecordIsModifedAfterThanSelf = [_modifiedAt compare:abRecordModifiedAt] == NSOrderedAscending;
    if (abRecordIsModifedAfterThanSelf) {
        _modifiedAt = abRecordModifiedAt;
    }
}

- (void)updateNameComponentsIfEmptyFromABRecord:(ABRecordRef)abRecord
{
    if (!_firstName) {
        _firstName = CFBridgingRelease(ABRecordCopyValue(abRecord, kABPersonFirstNameProperty));
    }
    if (!_lastName) {
        _lastName = CFBridgingRelease(ABRecordCopyValue(abRecord, kABPersonLastNameProperty));
    }
    if (!_middleName) {
        _middleName = CFBridgingRelease(ABRecordCopyValue(abRecord, kABPersonMiddleNameProperty));
    }
    if (!_nickname) {
        _nickname = CFBridgingRelease(ABRecordCopyValue(abRecord, kABPersonNicknameProperty));
    }
    if (!_organizationName) {
        _organizationName = CFBridgingRelease(ABRecordCopyValue(abRecord, kABPersonOrganizationProperty));
    }
    if (!_compositeName) {
        _compositeName = CFBridgingRelease(ABRecordCopyCompositeName(abRecord));
    }
}

- (void)updateThumbnailImageIfEmptyFromABRecord:(ABRecordRef)abRecord
{
    if (_thumbnailImage) {
        return;
    }
    [self updateThumbnailImageFromABRecord:abRecord];
}

- (void)updateThumbnailImageFromABRecord:(ABRecordRef)abRecord
{
    if (ABPersonHasImageData(abRecord)) {
        NSData* imgData = CFBridgingRelease(ABPersonCopyImageDataWithFormat(abRecord, kABPersonImageFormatThumbnail));
        _thumbnailImage = [UIImage imageWithData:imgData];
    }
}

- (void)addPhoneNumbersFromABRecord:(ABRecordRef)abRecord
{
    ABMultiValueRef phoneNumbers = ABRecordCopyValue(abRecord, kABPersonPhoneProperty);
    CFIndex phoneNumbersCount = ABMultiValueGetCount(phoneNumbers);
    if (phoneNumbersCount > 0) {
        for (CFIndex i = 0; i < phoneNumbersCount; i++) {
            NSString* phoneNumber = CFBridgingRelease(ABMultiValueCopyValueAtIndex(phoneNumbers, i));
            if (_phoneNumbersMutable == nil) {
                _phoneNumbersMutable = [NSMutableSet new];
            }
            [_phoneNumbersMutable addObject:phoneNumber];
        }
    }
}

- (void)addEmailsFromABRecord:(ABRecordRef)abRecord
{
    ABMultiValueRef emails = ABRecordCopyValue(abRecord, kABPersonEmailProperty);
    CFIndex emailsCount = ABMultiValueGetCount(emails);
    if (emailsCount > 0) {
        for (CFIndex i = 0; i < emailsCount; i++) {
            NSString* email = CFBridgingRelease(ABMultiValueCopyValueAtIndex(emails, i));
            if (_emailsMutable == nil) {
                _emailsMutable = [NSMutableSet new];
            }
            [_emailsMutable addObject:email];
        }
    }
}

- (void)addPostalAddressesFromABRecord:(ABRecordRef)abRecord
{
    ABMultiValueRef postalAddresses = ABRecordCopyValue(abRecord, kABPersonAddressProperty);
    CFIndex postalAddressCount = ABMultiValueGetCount(postalAddresses);
    if (postalAddressCount > 0) {
        for (CFIndex i = 0; i < postalAddressCount; i++) {
            NSDictionary* postalDict = CFBridgingRelease(ABMultiValueCopyValueAtIndex(postalAddresses, i));
            if (_postalAddressesMutable == nil) {
                _postalAddressesMutable = [NSMutableSet new];
            }
            if (postalDict) {
                [_postalAddressesMutable addObject:postalDict];
            }
        }
    }
}

- (void)addWebsitesFromABRecord:(ABRecordRef)abRecord
{
    ABMultiValueRef websites = ABRecordCopyValue(abRecord, kABPersonURLProperty);
    for (CFIndex i = 0; i < ABMultiValueGetCount(websites); i++) {
        NSString* website = (__bridge_transfer NSString*)ABMultiValueCopyValueAtIndex(websites, i);
        if (_websitesMutable == nil) {
            _websitesMutable = [NSMutableSet new];
        }
        [_websitesMutable addObject:website];
    }
}

- (void)addSocialAccountsFromPerson:(ABRecordRef)person
{
    ABMultiValueRef socialAccounts = ABRecordCopyValue(person, kABPersonSocialProfileProperty);
    for (CFIndex i = 0; i < ABMultiValueGetCount(socialAccounts); i++) {
        NSDictionary* socialDict = CFBridgingRelease(ABMultiValueCopyValueAtIndex(socialAccounts, i));
        if (socialDict == nil) {
            continue;
        }
        NSString* socialServiceName = [socialDict objectForKey:(__bridge_transfer NSString*)kABPersonSocialProfileServiceKey];
        NSString* socialAccountUsername = [socialDict objectForKey:(__bridge_transfer NSString*)kABPersonSocialProfileUsernameKey];

        if (socialServiceName == nil || socialAccountUsername == nil) {
            continue;
        }

        if ([socialServiceName isEqualToString:(__bridge_transfer NSString*)kABPersonSocialProfileServiceTwitter]) {
            if (_twitterAccountsMutable == nil) {
                _twitterAccountsMutable = [NSMutableSet new];
            }
            [_twitterAccountsMutable addObject:socialAccountUsername];
        }
        else if ([socialServiceName isEqualToString:(__bridge_transfer NSString*)kABPersonSocialProfileServiceFacebook]) {
            if (_facebookAccountsMutable == nil) {
                _facebookAccountsMutable = [NSMutableSet new];
            }
            [_facebookAccountsMutable addObject:socialAccountUsername];
        }
    }
}

#pragma mark - Getters

- (NSArray<NSNumber*>*)recordIds
{
    return [NSArray arrayWithArray:[_recordIdsMutable allObjects]];
}

- (NSArray<NSString*>*)phoneNumbers
{
    return [NSArray arrayWithArray:[_phoneNumbersMutable allObjects]];
}

- (NSArray<NSString*>*)emails
{
    return [NSArray arrayWithArray:[_emailsMutable allObjects]];
}

- (NSArray<NSDictionary*>*)postalAddresses
{
    return [NSArray arrayWithArray:[_postalAddressesMutable allObjects]];
}

- (NSArray<NSString*>*)websites
{
    return [NSArray arrayWithArray:[_websitesMutable allObjects]];
}

- (NSArray<NSString*>*)twitterAccounts
{
    return [NSArray arrayWithArray:[_twitterAccountsMutable allObjects]];
}

- (NSArray<NSString*>*)facebookAccounts
{
    return [NSArray arrayWithArray:[_facebookAccountsMutable allObjects]];
}

#pragma mark - Postal address keys constants

NSString* const kVeePostalAddressStreetKey = @"Street";
NSString* const kVeePostalAddressCityKey = @"City";
NSString* const kVeePostalAddressStateKey = @"State";
NSString* const kVeePostalAddressPostalCodeKey = @"ZIP";
NSString* const kVeePostalAddressCountryKey = @"Country";

#pragma mark - Equality

- (BOOL)isEqual:(id)other
{
    if (other == self) {
        return YES;
    }
    if (!other || ![other isKindOfClass:[self class]]) {
        return NO;
    }
    return [self isEqualToVeeVeeABRecord:other];
}

- (BOOL)isEqualToVeeVeeABRecord:(VeeABRecord*)veeABRecord
{
    if (self == veeABRecord) {
        return YES;
    }
    NSArray<NSNumber*>* sortedRecordIds = [[self recordIds] sortedArrayUsingSelector:@selector(compare:)];

    NSArray<NSNumber*>* veeABRecordsSortedRecordIds = [[veeABRecord recordIds] sortedArrayUsingSelector:@selector(compare:)];

    if ([sortedRecordIds isEqualToArray:veeABRecordsSortedRecordIds]) {
        return YES;
    }
    return NO;
}

- (NSUInteger)hash
{
    return [[self recordIds] hash];
}

@end
