@import AddressBook;
@import UIKit;
@import Foundation;

NS_ASSUME_NONNULL_BEGIN

@interface VeeABRecord : NSObject

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithLinkedPeopleOfABRecord:(ABRecordRef)abRecordRef NS_DESIGNATED_INITIALIZER;

@property (nonatomic, readonly, strong) NSArray<NSNumber*> *recordIds;
@property (nonatomic, readonly, strong) NSDate *modifiedAt;
@property (nonatomic, readonly, strong) NSDate *createdAt;
@property (nonatomic, readonly, copy) NSString *firstName;
@property (nonatomic, readonly, copy) NSString *lastName;
@property (nonatomic, readonly, copy) NSString *middleName;
@property (nonatomic, readonly, copy) NSString *nickname;
@property (nonatomic, readonly, copy) NSString *organizationName;
@property (nonatomic, readonly, copy) NSString *compositeName;
@property (nonatomic, readonly, strong) UIImage *thumbnailImage;
@property (nonatomic, readonly, strong) NSArray<NSString*> *phoneNumbers;
@property (nonatomic, readonly, strong) NSArray<NSString*> *emails;
@property (nonatomic, readonly, strong) NSArray<NSDictionary*> *postalAddresses;
@property (nonatomic, readonly, strong) NSArray<NSString*> *websites;
@property (nonatomic, readonly, strong) NSArray<NSString*> *facebookAccounts;
@property (nonatomic, readonly, strong) NSArray<NSString*> *twitterAccounts;

#pragma mark - Postal address constants

extern NSString* const kVeePostalAddressStreetKey;
extern NSString* const kVeePostalAddressCityKey;
extern NSString* const kVeePostalAddressStateKey;
extern NSString* const kVeePostalAddressPostalCodeKey;
extern NSString* const kVeePostalAddressCountryKey;

@end

NS_ASSUME_NONNULL_END
