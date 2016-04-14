//
//  Created by Andrea Cipriani on 14/12/15.
//  Copyright © 2015 Code Atlas SRL. All rights reserved.
//

@import Foundation;
@import UIKit;
#import "VeeContactProt.h"
#import "VeePostalAddressProt.h"
@class VeeABRecord;

@interface VeeContact : NSObject <VeeContactProt>

#pragma mark - Init

- (instancetype)initWithVeeABRecord:(VeeABRecord*)veeABRecord;
- (instancetype)initWithFirstName:(NSString*)firstName middleName:(NSString*)middleName lastName:(NSString*)lastName nickName:(NSString*)nickName organizationName:(NSString*)organizationName compositeName:(NSString*)compositeName thubnailImage:(UIImage*)thumbnailImage phoneNumbers:(NSArray<NSString*>*)phoneNumbers emails:(NSArray<NSString*>*)emails;

#pragma mark - Readonly

@property (nonatomic, readonly, strong) NSArray<NSNumber*>* recordIds;

#pragma mark - Single value properties

@property (nonatomic, copy) NSString* firstName;
@property (nonatomic, copy) NSString* lastName;
@property (nonatomic, copy) NSString* middleName;
@property (nonatomic, copy) NSString* nickname;
@property (nonatomic, copy) NSString* organizationName;
@property (nonatomic, copy) NSString* compositeName; //The concatenated value of these properties: Prefix, Suffix, Organization, First name, and Last name.
@property (nonatomic, strong) UIImage* thumbnailImage;

#pragma mark - Multivalue properties

@property (nonatomic, strong) NSArray<NSString*>* phoneNumbers;
@property (nonatomic, strong) NSArray<NSString*>* emails;
@property (nonatomic, strong) NSArray<id<VeePostalAddressProt> >* postalAddresses;
@property (nonatomic, strong) NSArray<NSString*>* twitterAccounts;
@property (nonatomic, strong) NSArray<NSString*>* facebookAccounts;

#pragma mark - Getters

- (NSString*)displayName; // It's based on which fields are not nil, in this order: "FirstName LastName" - "OrganizationName" - "LastName" - "First Name" - "Middle Name" - "Nickname" - "emailAddress[0]"
- (NSString*)displayNameSortedForABOptions; //Display name sorted considering sort-ordering preference for lists of persons in the address book. See ABPersonGetSortOrdering()
- (NSString*)sectionIdentifier; //In which section should the contact be? This is the title of that section

#pragma mark - Search predicate

+ (NSPredicate*)searchPredicateForSearchString; //$searchString will be used for substitution. Default predicate is: @"displayName contains[c] $searchString || ANY emails contains[c] $searchString || ANY phoneNumbers contains[c] $searchString"
;

@end
