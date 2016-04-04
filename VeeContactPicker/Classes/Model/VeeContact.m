//
//  Created by Andrea Cipriani on 14/12/15.
//  Copyright © 2015 Code Atlas SRL. All rights reserved.
//

#import "NSObject+VeeCommons.h"
#import "VeeABRecord.h"
#import "VeeAddressBook.h"
#import "VeeContact.h"
#import "VeeIsEmpty.h"
#import "VeePostalAddress.h"

@implementation VeeContact

#pragma mark - Init

- (instancetype)initWithVeeABRecord:(VeeABRecord*)veeABRecord
{
    self = [super init];
    if (self) {
        _recordIds = [veeABRecord recordIds];
        _firstName = [veeABRecord firstName];
        _lastName = [veeABRecord lastName];
        _middleName = [veeABRecord middleName];
        _compositeName = [veeABRecord compositeName];
        _nickname = [veeABRecord nickname];
        _organizationName = [veeABRecord organizationName];
        _thumbnailImage = [veeABRecord thumbnailImage];
        _phoneNumbers = [veeABRecord phoneNumbers];
        _emails = [veeABRecord emails];
        _postalAddresses = [self postalAddressesFromVeeABRecord:veeABRecord];
        _twitterAccounts = [veeABRecord twitterAccounts];
        _facebookAccounts = [veeABRecord facebookAccounts];
    }
    return self;
}

- (instancetype)initWithFirstName:(NSString*)firstName middleName:(NSString*)middleName lastName:(NSString*)lastName nickName:(NSString*)nickname organizationName:(NSString*)organizationName compositeName:(NSString*)compositeName thubnailImage:(UIImage*)thumbnailImage phoneNumbers:(NSArray<NSString*>*)phoneNumbers emails:(NSArray<NSString*>*)emails
{
    self = [super init];
    if (self) {
        _firstName = firstName;
        _middleName = middleName;
        _lastName = lastName;
        _compositeName = compositeName;
        _organizationName = organizationName;
        _nickname = nickname;
        _thumbnailImage = thumbnailImage;
        _phoneNumbers = phoneNumbers;
        _emails = emails;
    }
    return self;
}

#pragma mark - Private utils

- (NSArray<id<VeePostalAddressProt> >*)postalAddressesFromVeeABRecord:(VeeABRecord*)veeABRecord
{
    NSMutableArray* veePostalAddressesMutable = [NSMutableArray new];
    for (NSDictionary* postalDict in veeABRecord.postalAddresses) {
        VeePostalAddress* veePostalAddress = [[VeePostalAddress alloc] initWithStreet:postalDict[kVeePostalAddressStreetKey] city:postalDict[kVeePostalAddressCityKey] state:postalDict[kVeePostalAddressStateKey] postal:postalDict[kVeePostalAddressPostalCodeKey] country:postalDict[kVeePostalAddressCountryKey]];

        [veePostalAddressesMutable addObject:veePostalAddress];
    }
    return [NSArray arrayWithArray:veePostalAddressesMutable];
}

#pragma mark - Getters

- (NSString*)displayName
{
    return [self displayNameWithFirstNameFirst];
}

- (NSString*)displayNameSortedForABOptions
{
    if ([VeeAddressBook isABSortOrderingByFirstName]){
        return [self displayNameWithFirstNameFirst];
    }
    else{
        return [self displayNameWithLastNameFirst];
    }
}

- (NSString*)displayNameWithFirstNameFirst
{
    if (_firstName && _lastName) {
        if (_middleName) {
            return [_firstName stringByAppendingString:[NSString stringWithFormat:@" %@ %@", _middleName, _lastName]];
        }
        return [_firstName stringByAppendingString:[NSString stringWithFormat:@" %@", _lastName]];
    }
    return [self displayNameForNonCompleteCompositeName];
}

- (NSString*)displayNameWithLastNameFirst
{
    if (_firstName && _lastName) {
        if (_middleName) {
            return [_lastName stringByAppendingString:[NSString stringWithFormat:@" %@ %@", _middleName, _firstName]];
        }
        return [_lastName stringByAppendingString:[NSString stringWithFormat:@" %@", _firstName]];
    }
    return [self displayNameForNonCompleteCompositeName];
}

- (NSString*)displayNameForNonCompleteCompositeName
{
    if (_organizationName) {
        return _organizationName;
    }
    if (_lastName) {
        return _lastName;
    }
    if (_firstName) {
        return _firstName;
    }
    if (_middleName) {
        return _middleName;
    }
    if (_nickname) {
        return _nickname;
    }
    if ([_emails count] > 0) {
        return [_emails firstObject];
    }
    return @"";
}

- (NSString*)sectionIdentifier
{
    if ([VeeAddressBook isABSortOrderingByFirstName]) {
        return [self sectionIdentifierForFirstName];
    }
    else {
        return [self sectionIdentiferForLastName];
    }
}

- (NSString*)sectionIdentifierForFirstName
{
    NSString* sectionIdentifier;

    if ([VeeIsEmpty isEmpty:_firstName] == NO) {
        sectionIdentifier = [[_firstName substringToIndex:1] uppercaseString];
    }
    else if ([VeeIsEmpty isEmpty:_lastName] == NO) {
        sectionIdentifier = [[_lastName substringToIndex:1] uppercaseString];
    }
    else if ([VeeIsEmpty isEmpty:[self displayName]] == NO) {
        sectionIdentifier = [[[self displayName] substringToIndex:1] uppercaseString];
    }
    return sectionIdentifier;
}

- (NSString*)sectionIdentiferForLastName
{
    NSString* sectionIdentifier;

    if ([VeeIsEmpty isEmpty:_lastName] == NO) {
        sectionIdentifier = [[_lastName substringToIndex:1] uppercaseString];
    }
    else if ([VeeIsEmpty isEmpty:_firstName] == NO) {
        sectionIdentifier = [[_firstName substringToIndex:1] uppercaseString];
    }
    else if ([VeeIsEmpty isEmpty:[self displayName]] == NO) {
        sectionIdentifier = [[[self displayName] substringToIndex:1] uppercaseString];
    }
    return sectionIdentifier;
}

#pragma mark - Sort

- (NSComparisonResult)compare:(VeeContact*)otherVeeContact
{
    NSString* firstSortProperty;
    NSString* secondSortProperty;

    if ([VeeAddressBook isABSortOrderingByFirstName]) {
        firstSortProperty = @"firstName";
        secondSortProperty = @"lastName";
    }
    else {
        firstSortProperty = @"lastName";
        secondSortProperty = @"firstName";
    }

    NSString* firstContactSortValue = [self sortPropertyOfVeeContact:self withFirstOption:firstSortProperty andSecondOption:secondSortProperty];
    NSString* secondContactSortValue = [self sortPropertyOfVeeContact:otherVeeContact withFirstOption:firstSortProperty andSecondOption:secondSortProperty];
    NSComparisonResult result = [firstContactSortValue compare:secondContactSortValue options:NSDiacriticInsensitiveSearch | NSCaseInsensitiveSearch];

    if ([[self compositeName] isEqualToString:@"Andrea Barbieri"]) {
        NSLog(@"Andrea Barbieri compared to %@ == %zd", [otherVeeContact displayName], result);
    }
    if (result == NSOrderedSame) {
        return [[self displayName] compare:[otherVeeContact displayName] options:NSDiacriticInsensitiveSearch | NSCaseInsensitiveSearch];
    }
    else {
        return result;
    }
}

- (NSString*)sortPropertyOfVeeContact:(id)veeContact withFirstOption:(NSString*)firstProperty andSecondOption:(NSString*)secondProperty
{
    if ([veeContact respondsToSelector:NSSelectorFromString(firstProperty)] == NO || [veeContact respondsToSelector:NSSelectorFromString(secondProperty)] == NO) {
        NSLog(@"VeeContact doesn't respond to one of this selectors %@ %@", firstProperty, secondProperty);
        return [veeContact displayName];
    }

    if ([VeeIsEmpty isEmpty:[veeContact valueForKey:firstProperty]]) {
        if ([VeeIsEmpty isEmpty:[veeContact valueForKey:secondProperty]]) {
            return [veeContact displayName];
        }
        return [veeContact valueForKey:secondProperty];
    }
    return [veeContact valueForKey:firstProperty];
}

#pragma mark - Search predicate

+ (NSPredicate*)searchPredicateForSearchString
{
    return [NSPredicate predicateWithFormat:@"displayName contains[c] $searchString || ANY emails contains[c] $searchString || ANY phoneNumbers contains[c] $searchString"];
}

#pragma mark - Equality

- (BOOL)isEqual:(id)other
{
    if (other == self) {
        return YES;
    }
    if (!other || ![other isKindOfClass:[self class]]) {
        return NO;
    }
    return [self isEqualToVeeContactProt:other];
}

- (BOOL)isEqualToVeeContactProt:(id<VeeContactProt>)veecontact
{
    if (self == veecontact) {
        return YES;
    }

    NSArray<NSNumber*>* sortedRecordIds = [[self recordIds] sortedArrayUsingSelector:@selector(compare:)];

    NSArray<NSNumber*>* veeContactSortedRecordIds = [[veecontact recordIds] sortedArrayUsingSelector:@selector(compare:)];

    if ([sortedRecordIds isEqualToArray:veeContactSortedRecordIds]) {
        return YES;
    }
    return NO;
}

- (NSUInteger)hash
{
    return [[self recordIds] hash];
}

- (NSString*)description
{
    NSString* hasImage;
    if (_thumbnailImage) {
        hasImage = @"Has thumbnailImage";
    }
    else {
        hasImage = @"Hasn't thumbnailImage";
    }
    return [NSString stringWithFormat:@"\n[%@:\n Composite Name: %@\n Record Ids: %@\n %@\n First name: %@\n Last name: %@\n Organization name: %@\n Display name: %@\n Phone numbers: %@\n Email addresses: %@\n postalAddresses: %@\n twitterAccounts: %@\n facebookAccounts: %@\n]", NSStringFromClass([self class]), _compositeName, [self formattedDescriptionOfArray:_recordIds], hasImage, _firstName, _lastName, _organizationName, [self displayName], [self formattedDescriptionOfArray:_phoneNumbers], [self formattedDescriptionOfArray:_emails], [self formattedDescriptionOfArray:_postalAddresses], [self formattedDescriptionOfArray:_twitterAccounts], [self formattedDescriptionOfArray:_facebookAccounts]];
}

@end
