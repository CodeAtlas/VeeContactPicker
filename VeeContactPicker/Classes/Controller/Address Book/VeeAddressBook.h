@import Foundation;
@import AddressBook;
#import "VeeABDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface VeeAddressBook : NSObject

@property (nonatomic,strong) id<VeeABDelegate> delegate;
- (void)askABPermissionsWithDelegate:(ABAddressBookRef)addressBookRef;
+ (BOOL)hasABPermissions;
+ (BOOL)isABSortOrderingByFirstName;

@end

NS_ASSUME_NONNULL_END
