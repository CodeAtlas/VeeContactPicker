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
