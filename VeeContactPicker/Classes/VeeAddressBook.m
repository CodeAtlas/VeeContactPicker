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

- (BOOL)askABPermissionsIfNeeded:(ABAddressBookRef)addressBookRef
{
    CFErrorRef error = NULL;
    if (error) {
        NSLog(@"Warning - ABAddressBookCreateWithOptions error: %@", CFBridgingRelease(error));
    }

    if ([VeeAddressBook hasABPermissions] == NO) {
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
            [_delegate abPermissionsGranted:granted];
        });
        return YES;
    }
    else{
        return NO;
    }
}

@end
