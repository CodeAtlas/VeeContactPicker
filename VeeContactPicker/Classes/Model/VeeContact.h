//
//  Created by Andrea Cipriani on 14/12/15.
//  Copyright © 2015 Code Atlas SRL. All rights reserved.
//

@import Foundation;
@import UIKit;
#import "VeeContactProt.h"

@interface VeeContact : NSObject <VeeContactProt>

#pragma mark - Readonly

@property (nonatomic, readonly, strong) NSArray<NSNumber*>* recordIds;

#pragma mark - Single value properties

@property (nonatomic, strong) NSDate* modifiedAt;
@property (nonatomic, strong) NSDate* createdAt;
@property (nonatomic, copy) NSString* firstName;
@property (nonatomic, copy) NSString* lastName;
@property (nonatomic, copy) NSString* middleName;
@property (nonatomic, copy) NSString* nickname;
@property (nonatomic, copy) NSString* organizationName;
@property (nonatomic, copy) NSString* compositeName; //The concatenated value of these properties: Prefix, Suffix, Organization, First name, and Last name.
@property (nonatomic, copy) NSString* displayName; // It's based on which fields are not nil, in this order: "FirstName LastName" - "OrganizationName" - "LastName" - "First Name" - "Middle Name" - "Nickname" - "emailAddress"
@property (nonatomic, strong) UIImage* thumbnailImage;

#pragma mark - Multivalue properties

@property (nonatomic, strong) NSArray<NSString*>* phoneNumbers;
@property (nonatomic, strong) NSArray<NSString*>* emails;

#pragma mark - Getters

- (NSString*)sectionIdentifier; //In which section should the contact be? This is the title of that section

@end
