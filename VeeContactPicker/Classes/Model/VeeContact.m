//
//  Created by Andrea Cipriani on 14/12/15.
//  Copyright © 2015 Code Atlas SRL. All rights reserved.
//

#import "VeeContact.h"
#import "VeeIsEmpty.h"

@implementation VeeContact

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
    return [self isEqualToABContactProt:other];
}

- (BOOL)isEqualToABContactProt:(id<VeeContactProt>)veecontact
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
    return [NSString stringWithFormat:@"[%@ - Record Ids: %@, First name: %@, Last name: %@, Composite name: %@, Organization name: %@, Display name: %@, Phone numbers: %@, Email addresses: %@]", NSStringFromClass([self class]), _recordIds, _firstName, _lastName, _compositeName, _organizationName, _displayName, _phoneNumbers, _emails];
}

@end
