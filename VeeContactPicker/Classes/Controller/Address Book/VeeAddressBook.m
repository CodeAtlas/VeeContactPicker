#import "VeeAddressBook.h"

NS_ASSUME_NONNULL_BEGIN

@implementation VeeAddressBook

- (instancetype)initWithVeeABDelegate:(id<VeeABDelegate>)delegate
{
    self = [super init];
    if (self) {
        _delegate = delegate;
    }
    return self;
}

- (void)askABPermissionsWithDelegate:(ABAddressBookRef)addressBookRef
{
    ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
        if (granted){
            [_delegate abPermissionsGranted];
        }
        else{
            [_delegate abPermissionsNotGranted];
        }
    });
}

+ (BOOL)hasABPermissions
{
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        return YES;
    }
    return NO;
}

+ (BOOL)isABSortOrderingByFirstName
{
    return ABPersonGetSortOrdering() == kABPersonSortByFirstName;
}

@end

NS_ASSUME_NONNULL_END
