//
//  Created by Andrea Cipriani on 14/03/16.
//  Copyright © 2016 Code Atlas SRL. All rights reserved.
//

#import "VeeAddressBook.h"

@implementation VeeAddressBook

- (instancetype)initWithVeeABDelegate:(id<VeeABDelegate>)delegate
{
    self = [super init];
    if (self) {
        _delegate = delegate;
    }
    return self;
}

+ (BOOL)hasABPermissions
{
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        return YES;
    }
    return NO;
}

- (void)askABPermissionsWithDelegateCallback:(ABAddressBookRef)addressBookRef
{
    ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
            [_delegate abPermissionsGranted:granted];
    });
}

+(BOOL)isABSortOrderingByFirstName
{
    return ABPersonGetSortOrdering() == kABPersonSortByFirstName;
}

@end
