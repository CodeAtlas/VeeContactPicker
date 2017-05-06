@import Foundation;
@import UIKit;
#import "VeeContactProt.h"
#import "VeePostalAddressProt.h"
@class VeeABRecord;

@interface VeeContact : NSObject <VeeContactProt>

#pragma mark - Init

NS_ASSUME_NONNULL_BEGIN

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithVeeABRecord:(VeeABRecord*)veeABRecord;
- (instancetype)initWithFirstName:(nullable NSString*)firstName middleName:(nullable NSString*)middleName lastName:(nullable NSString*)lastName nickName:(nullable NSString*)nickName organizationName:(nullable NSString*)organizationName compositeName:(nullable NSString*)compositeName thubnailImage:(nullable UIImage*)thumbnailImage phoneNumbers:(nullable NSArray<NSString*>*)phoneNumbers emails:(nullable NSArray<NSString*>*)emails;

#pragma mark - Readonly

@property (nonatomic, readonly, strong) NSArray<NSNumber*>* recordIds;

#pragma mark - Single value properties

@property (nonatomic, copy) NSString* firstName;
@property (nonatomic, copy) NSString* lastName;
@property (nonatomic, copy) NSString* middleName;
@property (nonatomic, copy) NSString* nickname;
@property (nonatomic, copy) NSString* organizationName;
@property (nonatomic, copy) NSString* compositeName; //Prefix, Suffix, Organization, First name, and Last name.
@property (nonatomic, strong) UIImage* thumbnailImage;

#pragma mark - Multivalue properties

@property (nonatomic, strong) NSArray<NSString*>* phoneNumbers;
@property (nonatomic, strong) NSArray<NSString*>* emails;
@property (nonatomic, strong) NSArray<id<VeePostalAddressProt> >* postalAddresses;
@property (nonatomic, strong) NSArray<NSString*>* twitterAccounts;
@property (nonatomic, strong) NSArray<NSString*>* facebookAccounts;

#pragma mark - Getters

@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString * _Nonnull displayName; // It's based on non-empty fields of the contact: "FirstName LastName" - "OrganizationName" - "LastName" - "First Name" - "Middle Name" - "Nickname" - "emailAddress[0]"
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString * _Nonnull displayNameSortedForABOptions; //Display name is sorted considering the sort-ordering preference in the address book. See ABPersonGetSortOrdering()
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString * _Nonnull sectionIdentifier;

#pragma mark - Search predicate

+ (NSPredicate*)searchPredicateForSearchString; //$searchString is used for substitution. Default predicate is: @"displayName contains[c] $searchString || ANY emails contains[c] $searchString || ANY phoneNumbers contains[c] $searchString"
;

@end

NS_ASSUME_NONNULL_END
