//
//  VeecontactsForTestingFactory.h
//  VeeContactPicker
//
//  Created by Andrea Cipriani on 16/03/16.
//  Copyright © 2016 Code Atlas SRL. All rights reserved.
//

#import <Foundation/Foundation.h>
@class VeeAddressBookForTesting;

@interface VeecontactsForTestingFactory : NSObject

- (instancetype)initWithAddressBookForTesting:(VeeAddressBookForTesting*)veeAddressBookForTesting;

- (VeeContact*)veeContactComplete;
- (VeeContact*)veeContactUnified;
- (NSArray*)veeContactsFromAddressBookForTesting;

@end
