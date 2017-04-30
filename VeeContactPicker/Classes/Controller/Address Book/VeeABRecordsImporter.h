@import Foundation;
@import AddressBook;
@class VeeABRecord;

NS_ASSUME_NONNULL_BEGIN

@interface VeeABRecordsImporter : NSObject
- (NSArray<VeeABRecord*>*)importVeeABRecordsFromAddressBook:(ABAddressBookRef)addressBook;
@end

NS_ASSUME_NONNULL_END
