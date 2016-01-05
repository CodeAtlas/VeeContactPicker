//
//  VeeABContact.m
//  VeeContactPicker
//
//  Created by Andrea Cipriani on 14/12/15.
//  Copyright © 2015 Code Atlas SRL. All rights reserved.
//

#import "VeeABContact.h"

@implementation VeeABContact

- (instancetype)initWithPerson:(ABRecordRef)person
{
    self = [super init];
    if (self) {

        _recordId = [NSNumber numberWithInt:ABRecordGetRecordID(person)];        
        [self updateDataFromABRecordRef:person];
    }
    return self;
}

-(void)updateDataFromABRecordRef:(ABRecordRef)person
{
    if (!_firstName){
        _firstName = CFBridgingRelease(ABRecordCopyValue(person, kABPersonFirstNameProperty));
    }
    if (!_lastName){
        _lastName = CFBridgingRelease(ABRecordCopyValue(person, kABPersonLastNameProperty));
    }
    if (!_middleName){
        _middleName = CFBridgingRelease(ABRecordCopyValue(person, kABPersonMiddleNameProperty));
    }
    if (!_nickname){
        _nickname = CFBridgingRelease(ABRecordCopyValue(person, kABPersonNicknameProperty));
    }
    if (!_organizationName){
        _organizationName = CFBridgingRelease(ABRecordCopyValue(person, kABPersonOrganizationProperty));
    }
    
    if (!_compositeName){
        _compositeName = (__bridge_transfer NSString*)ABRecordCopyCompositeName(person);
    }
    
    if (!_thumbnailImage){
        if (ABPersonHasImageData(person)) {
            NSData* imgData = (__bridge_transfer NSData*)ABPersonCopyImageDataWithFormat(person, kABPersonImageFormatThumbnail);
            [self setThumbnailImage:[UIImage imageWithData:imgData]];
        }
    }
    
    ABMultiValueRef phoneNumbers = ABRecordCopyValue(person, kABPersonPhoneProperty);
    
    CFIndex phoneNumbersCount = ABMultiValueGetCount(phoneNumbers);
    if (phoneNumbersCount > 0) {
        NSMutableArray* phoneNumbersMutable = [NSMutableArray new];
        for (CFIndex i = 0; i < phoneNumbersCount; i++) {
            NSString* phoneNumber = CFBridgingRelease(ABMultiValueCopyValueAtIndex(phoneNumbers, i));
            [phoneNumbersMutable addObject:phoneNumber];
        }
        [self setPhoneNumbers:[NSArray arrayWithArray:phoneNumbersMutable]];
        CFRelease(phoneNumbers);
    }
    
    ABMultiValueRef emails = ABRecordCopyValue(person, kABPersonEmailProperty);
    
    CFIndex emailsCount = ABMultiValueGetCount(emails);
    if (emailsCount > 0) {
        NSMutableArray* emailsMutable = [NSMutableArray new];
        for (CFIndex i = 0; i < emailsCount; i++) {
            NSString* email = CFBridgingRelease(ABMultiValueCopyValueAtIndex(emails, i));
            [emailsMutable addObject:email];
        }
        [self setEmails:[NSArray arrayWithArray:emailsMutable]];
        CFRelease(emails);
    }
    
    [self updateSectionIdentifier];
}

-(void)updateSectionIdentifier
{
    //First Letter as Section identifier
    if (_firstName && _firstName.length > 0) {
        _sectionIdentifier = [[_firstName substringToIndex:1] uppercaseString];
    }
    else if (_lastName && _lastName.length > 0) {
        _sectionIdentifier = [[_lastName substringToIndex:1] uppercaseString];
    }
    else if ([self displayName] && [self displayName].length > 0) {
        _sectionIdentifier = [[[self displayName] substringToIndex:1] uppercaseString];
    }
    else {
        _sectionIdentifier = @"#";
    }
    if ([[[UILocalizedIndexedCollation currentCollation] sectionIndexTitles] containsObject:_sectionIdentifier] == NO){
        _sectionIdentifier = @"#";
    }
}

- (NSString*)displayName
{
    if (_firstName && _lastName) {
        return [_firstName stringByAppendingString:[NSString stringWithFormat:@" %@", _lastName]];
    }
    else if (_organizationName) {
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

- (BOOL)isEqual:(id)other
{
    if (other == self)
        return YES;
    if (!other || ![other isKindOfClass:[self class]])
        return NO;
    return [self isEqualToAbContact:other];
}

- (BOOL)isEqualToAbContact:(VeeABContact*)veeABContact
{
    if (![veeABContact recordId]) {
        NSLog(@"Warning: VeeABContact %@ has a null record id", veeABContact);
        return NO;
    }
    //Two contacts are equal if they have the same recordId
    if (self == veeABContact) {
        return YES;
    }
    if (![[self recordId] isEqualToNumber:[veeABContact recordId]]) {
        return NO;
    }
    return YES;
}

- (NSUInteger)hash
{
    return [_recordId hash];
}

- (NSString*)description
{
    return [NSString stringWithFormat:@"[%@ - RecordId: %@, FirstName: %@, LastName: %@, Composite name: %@, OrganizationName: %@, DisplayName: %@, PhoneNumbers: %@, Email addresses: %@]", NSStringFromClass([self class]), _recordId, _firstName, _lastName, _compositeName, _organizationName, _displayName,_phoneNumbers,_emails];
}

@end
