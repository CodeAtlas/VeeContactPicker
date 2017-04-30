#import "NSObject+VeeCommons.h"
#import "VeeABRecord.h"
#import "VeeAddressBook.h"
#import "VeeCommons.h"
#import "VeeContact.h"
#import "VeePostalAddress.h"

@implementation VeeContact

#pragma mark - Init

- (instancetype)initWithVeeABRecord:(VeeABRecord*)veeABRecord
{
    self = [super init];
    if (self) {
        _recordIds = veeABRecord.recordIds;
        _firstName = veeABRecord.firstName;
        _lastName = veeABRecord.lastName;
        _middleName = veeABRecord.middleName;
        _compositeName = veeABRecord.compositeName;
        _nickname = veeABRecord.nickname;
        _organizationName = veeABRecord.organizationName;
        _thumbnailImage = veeABRecord.thumbnailImage;
        _phoneNumbers = veeABRecord.phoneNumbers;
        _emails = veeABRecord.emails;
        _postalAddresses = [self postalAddressesFromVeeABRecord:veeABRecord];
        _twitterAccounts = veeABRecord.twitterAccounts;
        _facebookAccounts = veeABRecord.facebookAccounts;
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
    if ([VeeAddressBook isABSortOrderingByFirstName]) {
        return [self displayNameWithFirstNameFirst];
    }
    else {
        return [self displayNameWithLastNameFirst];
    }
}

- (NSString*)displayNameWithFirstNameFirst
{
    if ([VeeCommons vee_isNotEmpty:_firstName] && [VeeCommons vee_isNotEmpty:_lastName]) {
        if ([VeeCommons vee_isNotEmpty:_middleName]) {
            return [_firstName stringByAppendingString:[NSString stringWithFormat:@" %@ %@", _middleName, _lastName]];
        }
        return [_firstName stringByAppendingString:[NSString stringWithFormat:@" %@", _lastName]];
    }
    return [self displayNameForNonCompleteCompositeName];
}

- (NSString*)displayNameWithLastNameFirst
{
    if ([VeeCommons vee_isNotEmpty:_firstName] && [VeeCommons vee_isNotEmpty:_lastName]) {
        if ([VeeCommons vee_isNotEmpty:_middleName]) {
            return [_lastName stringByAppendingString:[NSString stringWithFormat:@" %@ %@", _middleName, _firstName]];
        }
        return [_lastName stringByAppendingString:[NSString stringWithFormat:@" %@", _firstName]];
    }
    return [self displayNameForNonCompleteCompositeName];
}

- (NSString*)displayNameForNonCompleteCompositeName
{
    if ([VeeCommons vee_isNotEmpty:_organizationName]) {
        return _organizationName;
    }
    if ([VeeCommons vee_isNotEmpty:_lastName]) {
        return _lastName;
    }
    if ([VeeCommons vee_isNotEmpty:_firstName]) {
        return _firstName;
    }
    if ([VeeCommons vee_isNotEmpty:_middleName]) {
        return _middleName;
    }
    if ([VeeCommons vee_isNotEmpty:_nickname]) {
        return _nickname;
    }
    if (_emails.count > 0) {
        return _emails.firstObject;
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

    if ([VeeCommons vee_isEmpty:_firstName] == NO) {
        sectionIdentifier = [_firstName substringToIndex:1].uppercaseString;
    }
    else if ([VeeCommons vee_isEmpty:_lastName] == NO) {
        sectionIdentifier = [_lastName substringToIndex:1].uppercaseString;
    }
    else if ([VeeCommons vee_isEmpty:[self displayName]] == NO) {
        sectionIdentifier = [[self displayName] substringToIndex:1].uppercaseString;
    }
    return sectionIdentifier;
}

- (NSString*)sectionIdentiferForLastName
{
    NSString* sectionIdentifier;

    if ([VeeCommons vee_isEmpty:_lastName] == NO) {
        sectionIdentifier = [_lastName substringToIndex:1].uppercaseString;
    }
    else if ([VeeCommons vee_isEmpty:_firstName] == NO) {
        sectionIdentifier = [_firstName substringToIndex:1].uppercaseString;
    }
    else if ([VeeCommons vee_isEmpty:[self displayName]] == NO) {
        sectionIdentifier = [[self displayName] substringToIndex:1].uppercaseString;
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

    if ([VeeCommons vee_isEmpty:[veeContact valueForKey:firstProperty]]) {
        if ([VeeCommons vee_isEmpty:[veeContact valueForKey:secondProperty]]) {
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

    NSArray<NSNumber*>* sortedRecordIds = [self.recordIds sortedArrayUsingSelector:@selector(compare:)];

    NSArray<NSNumber*>* veeContactSortedRecordIds = [veecontact.recordIds sortedArrayUsingSelector:@selector(compare:)];

    if ([sortedRecordIds isEqualToArray:veeContactSortedRecordIds]) {
        return YES;
    }
    return NO;
}

- (NSUInteger)hash
{
    return self.recordIds.hash;
}

- (NSString*)description
{
    return [NSString stringWithFormat:@"<%@,\n %@>", self.class, [self propertiesDescriptionDictionary]];
}

- (NSString*)debugDescription
{
    return [NSString stringWithFormat:@"<%@: %p,\n %@>", self.class, self, [self propertiesDescriptionDictionary]];
}

- (NSDictionary*)propertiesDescriptionDictionary
{
    NSString* hasImage;
    if (_thumbnailImage) {
        hasImage = @"YES";
    }
    else {
        hasImage = @"NO";
    }
    return @{
        @"compositeName" : [self vee_formattedDescriptionOfProperty:_compositeName],
        @"recordIds" : [self vee_formattedDescriptionOfArray:_recordIds],
        @"hasThumbnailImage" : hasImage,
        @"firstName" : [self vee_formattedDescriptionOfProperty:_firstName],
        @"lastName" : [self vee_formattedDescriptionOfProperty:_lastName],
        @"organizationName" : [self vee_formattedDescriptionOfProperty:_organizationName],
        @"displayName" : [self vee_formattedDescriptionOfProperty:[self displayName]],
        @"phoneNumbers" : [self vee_formattedDescriptionOfArray:_phoneNumbers],
        @"emails" : [self vee_formattedDescriptionOfArray:_emails],
        @"postalAddresses" : [self vee_formattedDescriptionOfArray:_postalAddresses],
        @"twitterAccounts" : [self vee_formattedDescriptionOfArray:_twitterAccounts],
        @"facebookAccounts" : [self vee_formattedDescriptionOfArray:_facebookAccounts]
    };
}

@end
