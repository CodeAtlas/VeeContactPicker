@import Foundation;
@import UIKit;
#import "VeePostalAddressProt.h"
#import "VeeSectionable.h"

@protocol VeeContactProt <NSObject, VeeSectionableProt>

@property (nonatomic, copy) NSString* firstName;
@property (nonatomic, copy) NSString* lastName;
@property (nonatomic, copy) NSString* middleName;
@property (nonatomic, copy) NSString* nickname;
@property (nonatomic, copy) NSString* organizationName;
@property (nonatomic, copy) NSString* compositeName;
@property (nonatomic, strong) UIImage* thumbnailImage;

@property (nonatomic, strong) NSArray<NSString*>* phoneNumbers;
@property (nonatomic, strong) NSArray<NSString*>* emails;

@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString *displayName;
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString *displayNameSortedForABOptions;
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString *sectionIdentifier;

+ (NSPredicate*)searchPredicateForSearchString;

@optional

@property (nonatomic, readonly, strong) NSArray<NSNumber*>* recordIds;
@property (nonatomic, strong) NSArray<id<VeePostalAddressProt> >* postalAddresses;
@property (nonatomic, strong) NSArray<NSString*>* twitterAccounts;
@property (nonatomic, strong) NSArray<NSString*>* facebookAccounts;

@end
