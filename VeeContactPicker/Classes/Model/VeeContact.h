//
//  VeeABContact.h
//  VeeContactPicker
//
//  Created by Andrea Cipriani on 14/12/15.
//  Copyright © 2015 Code Atlas SRL. All rights reserved.
//

#import "VeeContactProt.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@import AddressBook;

@interface VeeContact : NSObject <VeeContactProt>

- (instancetype)initWithLinkedPeopleOfABRecord:(ABRecordRef)abRecordRef;

@property (nonatomic, readonly, strong) NSArray<NSNumber*>* recordIds;

#pragma mark - Single value properties

@property (nonatomic, readonly, strong) NSDate* modifiedAt;
@property (nonatomic, readonly, strong) NSDate* createdAt;
@property (nonatomic, readonly, copy) NSString* firstName;
@property (nonatomic, readonly, copy) NSString* lastName;
@property (nonatomic, readonly, copy) NSString* middleName;
@property (nonatomic, readonly, copy) NSString* nickname;
@property (nonatomic, readonly, copy) NSString* organizationName;
@property (nonatomic, readonly, copy) NSString* compositeName; //The concatenated value of these properties: Prefix, Suffix, Organization, First name, and Last name.
@property (nonatomic, readonly, copy) NSString* displayName; // It's based on which fields are not nil, in this order: "FirstName LastName" - "OrganizationName" - "LastName" - "First Name" - "Middle Name" - "Nickname" - "emailAddress"
@property (nonatomic, readonly, strong) UIImage* thumbnailImage;

#pragma mark - Multivalue properties

@property (nonatomic, readonly, strong) NSArray<NSString*>* phoneNumbers;
@property (nonatomic, readonly, strong) NSArray<NSString*>* emails;

@end
