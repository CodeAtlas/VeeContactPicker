#import "VeeABRecord.h"

NS_ASSUME_NONNULL_BEGIN

@interface VeeABRecord()
@property (nonatomic, strong) NSArray<NSNumber*> *recordIds;
@property (nonatomic, strong) NSDate *modifiedAt;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;
@property (nonatomic, copy) NSString *middleName;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *organizationName;
@property (nonatomic, copy) NSString *compositeName;
@property (nonatomic, strong) UIImage *thumbnailImage;
@property (nonatomic, strong) NSArray<NSString*> *phoneNumbers;
@property (nonatomic, strong) NSArray<NSString*> *emails;
@property (nonatomic, strong) NSArray<NSDictionary*> *postalAddresses;
@property (nonatomic, strong) NSArray<NSString*> *websites;
@property (nonatomic, strong) NSArray<NSString*> *facebookAccounts;
@property (nonatomic, strong) NSArray<NSString*> *twitterAccounts;
@property (nonatomic, strong) NSMutableSet<NSNumber*>* recordIdsMutable;
@property (nonatomic, strong) NSMutableSet<NSString*>* phoneNumbersMutable;
@property (nonatomic, strong) NSMutableSet<NSString*>* emailsMutable;
@property (nonatomic, strong) NSMutableSet<NSDictionary*>* postalAddressesMutable;
@property (nonatomic, strong) NSMutableSet<NSString*>* websitesMutable;
@property (nonatomic, strong) NSMutableSet<NSString*>* twitterAccountsMutable;
@property (nonatomic, strong) NSMutableSet<NSString*>* facebookAccountsMutable;
@end

@implementation VeeABRecord

#pragma mark - Init

- (instancetype)initWithLinkedPeopleOfABRecord:(ABRecordRef)abRecord
{
    self = [super init];
    if (self) {
        NSAssert(abRecord, @"abRecord must exist");
        NSArray* linkedPeople = CFBridgingRelease(ABPersonCopyArrayOfAllLinkedPeople(abRecord));
        for (int i = 0; i < linkedPeople.count; i++) {
            ABRecordRef linkedABRecord = CFArrayGetValueAtIndex((__bridge CFArrayRef)(linkedPeople), i);
            [self updateFromABRecord:linkedABRecord];
        }
    }
    return self;
}

#pragma mark - Private

- (void)updateFromABRecord:(ABRecordRef)abRecord
{
    [self addRecordIdFromABRecord:abRecord];
    [self updateDatesIfEmptyFromABRecord:abRecord];
    [self updateNameComponentsIfEmptyFromABRecord:abRecord];
    [self updateThumbnailImageIfEmptyFromABRecord:abRecord];
    [self addPhoneNumbersFromABRecord:abRecord];
    [self addEmailsFromABRecord:abRecord];
    [self addPostalAddressesFromABRecord:abRecord];
    [self addWebsitesFromABRecord:abRecord];
    [self addSocialAccountsFromPerson:abRecord];
}

- (void)addRecordIdFromABRecord:(ABRecordRef)abRecord
{
    NSNumber* recordId = @(ABRecordGetRecordID(abRecord));
    if (self.recordIdsMutable == nil){
        self.recordIdsMutable = [NSMutableSet new];
    }
    [self.recordIdsMutable addObject:recordId];
}

- (void)updateDatesIfEmptyFromABRecord:(ABRecordRef)abRecord
{
    [self updateCreatedFromABRecordIfItsAfter:abRecord];
    [self updateModifiedFromABRecordRefIfItsAfter:abRecord];
}

- (void)updateCreatedFromABRecordIfItsAfter:(ABRecordRef)abRecord
{
    if (!self.createdAt) {
        self.createdAt = (__bridge_transfer NSDate*)ABRecordCopyValue(abRecord, kABPersonCreationDateProperty);
        return;
    }
    NSDate* abRecordCreatedAt = (__bridge_transfer NSDate*)ABRecordCopyValue(abRecord, kABPersonCreationDateProperty);
    BOOL abRecordIsCreatedAfterThanSelf = [self.createdAt compare:abRecordCreatedAt] == NSOrderedAscending;
    if (abRecordIsCreatedAfterThanSelf) {
        self.createdAt = abRecordCreatedAt;
    }
}

- (void)updateModifiedFromABRecordRefIfItsAfter:(ABRecordRef)abRecord
{
    if (!self.modifiedAt) {
        self.modifiedAt = (__bridge_transfer NSDate*)ABRecordCopyValue(abRecord, kABPersonModificationDateProperty);
    }
    NSDate* abRecordModifiedAt = (__bridge_transfer NSDate*)ABRecordCopyValue(abRecord, kABPersonModificationDateProperty);
    BOOL abRecordIsModifedAfterThanSelf = [self.modifiedAt compare:abRecordModifiedAt] == NSOrderedAscending;
    if (abRecordIsModifedAfterThanSelf) {
        self.modifiedAt = abRecordModifiedAt;
    }
}

- (void)updateNameComponentsIfEmptyFromABRecord:(ABRecordRef)abRecord
{
    if (!self.firstName) {
        self.firstName = CFBridgingRelease(ABRecordCopyValue(abRecord, kABPersonFirstNameProperty));
    }
    if (!self.lastName) {
        self.lastName = CFBridgingRelease(ABRecordCopyValue(abRecord, kABPersonLastNameProperty));
    }
    if (!self.middleName) {
        self.middleName = CFBridgingRelease(ABRecordCopyValue(abRecord, kABPersonMiddleNameProperty));
    }
    if (!self.nickname) {
        self.nickname = CFBridgingRelease(ABRecordCopyValue(abRecord, kABPersonNicknameProperty));
    }
    if (!self.organizationName) {
        self.organizationName = CFBridgingRelease(ABRecordCopyValue(abRecord, kABPersonOrganizationProperty));
    }
    if (!self.compositeName) {
        self.compositeName = CFBridgingRelease(ABRecordCopyCompositeName(abRecord));
    }
}

- (void)updateThumbnailImageIfEmptyFromABRecord:(ABRecordRef)abRecord
{
    if (self.thumbnailImage) {
        return;
    }
    [self updateThumbnailImageFromABRecord:abRecord];
}

- (void)updateThumbnailImageFromABRecord:(ABRecordRef)abRecord
{
    if (ABPersonHasImageData(abRecord)) {
        NSData* imgData = CFBridgingRelease(ABPersonCopyImageDataWithFormat(abRecord, kABPersonImageFormatThumbnail));
        self.thumbnailImage = [UIImage imageWithData:imgData];
    }
}

- (void)addPhoneNumbersFromABRecord:(ABRecordRef)abRecord
{
    ABMultiValueRef phoneNumbers = ABRecordCopyValue(abRecord, kABPersonPhoneProperty);
    CFIndex phoneNumbersCount = ABMultiValueGetCount(phoneNumbers);
    if (phoneNumbersCount > 0) {
        for (CFIndex i = 0; i < phoneNumbersCount; i++) {
            NSString* phoneNumber = CFBridgingRelease(ABMultiValueCopyValueAtIndex(phoneNumbers, i));
            if (self.phoneNumbersMutable == nil){
                self.phoneNumbersMutable = [NSMutableSet new];
            }
            [self.phoneNumbersMutable addObject:phoneNumber];
        }
    }
}

- (void)addEmailsFromABRecord:(ABRecordRef)abRecord
{
    ABMultiValueRef emails = ABRecordCopyValue(abRecord, kABPersonEmailProperty);
    CFIndex emailsCount = ABMultiValueGetCount(emails);
    if (emailsCount > 0) {
        for (CFIndex i = 0; i < emailsCount; i++) {
            NSString* email = CFBridgingRelease(ABMultiValueCopyValueAtIndex(emails, i));
            if (self.emailsMutable == nil){
                self.emailsMutable = [NSMutableSet new];
            }
            [self.emailsMutable addObject:email];
        }
    }
}

-(void)addPostalAddressesFromABRecord:(ABRecordRef)abRecord
{
    ABMultiValueRef postalAddresses = ABRecordCopyValue(abRecord, kABPersonAddressProperty);
    CFIndex postalAddressCount = ABMultiValueGetCount(postalAddresses);
    if (postalAddressCount > 0){
        for (CFIndex i = 0; i < postalAddressCount; i++) {
            NSDictionary* postalDict = CFBridgingRelease(ABMultiValueCopyValueAtIndex(postalAddresses, i));
            if (self.postalAddressesMutable == nil){
                self.postalAddressesMutable = [NSMutableSet new];
            }
            if (postalDict){
                [self.postalAddressesMutable addObject:postalDict];
            }
        }
    }
}

-(void)addWebsitesFromABRecord:(ABRecordRef)abRecord
{
    ABMultiValueRef websites = ABRecordCopyValue(abRecord, kABPersonURLProperty);
    for (CFIndex i = 0; i < ABMultiValueGetCount(websites); i++) {
        NSString* website = (__bridge_transfer NSString*)ABMultiValueCopyValueAtIndex(websites, i);
        if (self.websitesMutable == nil){
            self.websitesMutable = [NSMutableSet new];
        }
        [self.websitesMutable addObject:website];
    }
}

- (void)addSocialAccountsFromPerson:(ABRecordRef)person
{
    ABMultiValueRef socialAccounts = ABRecordCopyValue(person, kABPersonSocialProfileProperty);
    for (CFIndex i = 0; i < ABMultiValueGetCount(socialAccounts); i++) {
        NSDictionary* socialDict = CFBridgingRelease(ABMultiValueCopyValueAtIndex(socialAccounts, i));
        if (socialDict) {
            NSString* service = socialDict[(__bridge_transfer NSString*)kABPersonSocialProfileServiceKey];
            NSString* username = socialDict[(__bridge_transfer NSString*)kABPersonSocialProfileUsernameKey];
            
            if ([service isEqualToString:(__bridge_transfer NSString*)kABPersonSocialProfileServiceTwitter]) {
                if (self.twitterAccountsMutable == nil){
                    self.twitterAccountsMutable = [NSMutableSet new];
                }
                if (username != nil) {
                    [self.twitterAccountsMutable addObject:username];
                }
            }
            else if ([service isEqualToString:(__bridge_transfer NSString*)kABPersonSocialProfileServiceFacebook]) {
                if (self.facebookAccountsMutable == nil){
                    self.facebookAccountsMutable = [NSMutableSet new];
                }
                if (username != nil) {
                    [self.facebookAccountsMutable addObject:username];
                }
            }
        }
    }
}

#pragma mark - Getters

- (NSArray<NSNumber*>*)recordIds
{
    return [NSArray arrayWithArray:(self.recordIdsMutable).allObjects];
}

- (NSArray<NSString*>*)phoneNumbers
{
    return [NSArray arrayWithArray:(self.phoneNumbersMutable).allObjects];
}

- (NSArray<NSString*>*)emails
{
    return [NSArray arrayWithArray:(self.emailsMutable).allObjects];
}

- (NSArray<NSDictionary*>*)postalAddresses
{
    return [NSArray arrayWithArray:(self.postalAddressesMutable).allObjects];
}

- (NSArray<NSString*>*)websites
{
    return [NSArray arrayWithArray:(self.websitesMutable).allObjects];
}

- (NSArray<NSString*>*)twitterAccounts
{
    return [NSArray arrayWithArray:(self.twitterAccountsMutable).allObjects];
}

- (NSArray<NSString*>*)facebookAccounts
{
    return [NSArray arrayWithArray:(self.facebookAccountsMutable).allObjects];
}

#pragma mark - Postal address keys constants

NSString* const kVeePostalAddressStreetKey = @"Street";
NSString* const kVeePostalAddressCityKey = @"City";
NSString* const kVeePostalAddressStateKey = @"State";
NSString* const kVeePostalAddressPostalCodeKey = @"ZIP";
NSString* const kVeePostalAddressCountryKey = @"Country";

#pragma mark - Equality

- (BOOL)isEqual:(id)other
{
    if (other == self) {
        return YES;
    }
    if (!other || ![other isKindOfClass:[self class]]) {
        return NO;
    }
    return [self isEqualToVeeVeeABRecord:other];
}

- (BOOL)isEqualToVeeVeeABRecord:(VeeABRecord*)veeABRecord
{
    if (self == veeABRecord) {
        return YES;
    }
    NSArray<NSNumber*>* sortedRecordIds = [self.recordIds sortedArrayUsingSelector:@selector(compare:)];
    NSArray<NSNumber*>* veeABRecordsSortedRecordIds = [veeABRecord.recordIds sortedArrayUsingSelector:@selector(compare:)];
                                                     
    if ([sortedRecordIds isEqualToArray:veeABRecordsSortedRecordIds]) {
        return YES;
    }
    return NO;
}

- (NSUInteger)hash
{
    return self.recordIds.hash;
}

@end

NS_ASSUME_NONNULL_END
