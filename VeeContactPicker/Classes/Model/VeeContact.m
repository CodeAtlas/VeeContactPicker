//
//  Created by Andrea Cipriani on 14/12/15.
//  Copyright © 2015 Code Atlas SRL. All rights reserved.
//

#import "VeeContact.h"
#import "VeeIsEmpty.h"
#import "VeeABRecordAdapter.h"

@implementation VeeContact

#pragma mark - Init

-(instancetype)initWithVeeABRecordAdapter:(VeeABRecordAdapter*)veeABRecordAdapter
{
    self = [super init];
    if (self) {
        _recordIds = [veeABRecordAdapter recordIds];
        _firstName = [veeABRecordAdapter firstName];
        _lastName = [veeABRecordAdapter lastName];
        _middleName = [veeABRecordAdapter middleName];
        _compositeName = [veeABRecordAdapter compositeName];
        _nickname = [veeABRecordAdapter nickname];
        _organizationName = [veeABRecordAdapter organizationName];
        _thumbnailImage = [veeABRecordAdapter thumbnailImage];
        _phoneNumbers = [veeABRecordAdapter phoneNumbers];
        _emails = [veeABRecordAdapter emails];
    }
    return self;
}

-(instancetype)initWithFirstName:(NSString*)firstName middleName:(NSString*)middleName lastName:(NSString*)lastName nickName:(NSString*)nickname organizationName:(NSString*)organizationName compositeName:(NSString*)compositeName thubnailImage:(UIImage*)thumbnailImage phoneNumbers:(NSArray<NSString*>*)phoneNumbers emails:(NSArray<NSString*>*)emails
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

#pragma mark - Getters

- (NSString*)displayName
{
    if (_firstName && _lastName) {
        if (_middleName) {
            return [_firstName stringByAppendingString:[NSString stringWithFormat:@" %@ %@", _middleName, _lastName]];
        }
        return [_firstName stringByAppendingString:[NSString stringWithFormat:@" %@", _lastName]];
    }
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
    NSString* sectionIdentifierForVeecontact;

    if ([VeeIsEmpty isEmpty:_firstName] == NO) {
        sectionIdentifierForVeecontact = [[_firstName substringToIndex:1] uppercaseString];
    }
    else if ([VeeIsEmpty isEmpty:_lastName] == NO) {
        sectionIdentifierForVeecontact = [[_lastName substringToIndex:1] uppercaseString];
    }
    else if ([VeeIsEmpty isEmpty:[self displayName]] == NO) {
        sectionIdentifierForVeecontact = [[[self displayName] substringToIndex:1] uppercaseString];
    }
    return sectionIdentifierForVeecontact;
}

#pragma mark - Sort

- (NSComparisonResult)compare:(VeeContact*)otherVeeContact
{
    NSString* firstSortProperty = @"firstName";
    NSString* secondSortProperty = @"lastName";

    NSString* firstContactSortProperty = [self sortPropertyOfVeeContact:self withFirstOption:firstSortProperty andSecondOption:secondSortProperty];
    NSString* secondContactSortProperty = [self sortPropertyOfVeeContact:otherVeeContact withFirstOption:firstSortProperty andSecondOption:secondSortProperty];
    NSComparisonResult result = [firstContactSortProperty compare:secondContactSortProperty options:NSDiacriticInsensitiveSearch | NSCaseInsensitiveSearch];
    if (result == NSOrderedSame) {
        return [[self displayName] compare:otherVeeContact.displayName options:NSDiacriticInsensitiveSearch | NSCaseInsensitiveSearch];
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

#pragma mark - NSObject

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
    if (![[self recordIds] isEqual:[veecontact recordIds]]) {
        return NO;
    }
    return YES;
}

- (NSUInteger)hash
{
    return [[self recordIds] hash];
}

- (NSString*)description
{
    return [NSString stringWithFormat:@"[%@ - Record Ids: %@, First name: %@, Last name: %@, Composite name: %@, Organization name: %@, Display name: %@, Phone numbers: %@, Email addresses: %@]", NSStringFromClass([self class]), _recordIds, _firstName, _lastName, _compositeName, _organizationName, [self displayName], _phoneNumbers, _emails];
}

@end
