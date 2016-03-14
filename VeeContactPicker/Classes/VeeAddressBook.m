//
//  Created by Andrea Cipriani on 14/03/16.
//  Copyright © 2016 Code Atlas SRL. All rights reserved.
//

#import "VeeAddressBook.h"

@implementation VeeAddressBook

+ (BOOL)hasABPermissions
{
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        return YES;
    }
    return NO;
}

+ (void)askABPermissionsIfNeeded:(ABAddressBookRef)addressBookRef
{
    CFErrorRef error = NULL;
    if (error) {
        NSLog(@"Warning - ABAddressBookCreateWithOptions error: %@", CFBridgingRelease(error));
    }

    if ([self hasABPermissions] == NO) {
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
            if (!granted) {
                NSLog(@"Warning - ABAddressBookRequestAccessWithCompletion not granted");
                //TODO: empty view
            }
            else {
                [self performSelectorOnMainThread:@selector(loadDataSource) withObject:nil waitUntilDone:YES];
            TODO: complection come parametro?
            }
        });
    }
}

@end
