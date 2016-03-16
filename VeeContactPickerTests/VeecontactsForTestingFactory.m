//  Created by Andrea Cipriani on 16/03/16.
//  Copyright © 2016 Code Atlas SRL. All rights reserved.
//

#import "VeeAddressBookForTesting.h"
#import "VeeContact.h"
#import "VeecontactsForTestingFactory.h"

@interface VeecontactsForTestingFactory ()

@property (nonatomic, strong) VeeAddressBookForTesting* veeAddressBookForTesting;

@end

@implementation VeecontactsForTestingFactory

- (instancetype)initWithAddressBookForTesting:(VeeAddressBookForTesting*)veeAddressBookForTesting
{
    self = [super init];
    if (self) {
        _veeAddressBookForTesting = veeAddressBookForTesting;
    }
    return self;
}

#pragma mark - Public methods

- (VeeContact*)veeContactComplete
{
    VeeContact* veeContactComplete = [[VeeContact alloc] initWithLinkedPeopleOfABRecord:[_veeAddressBookForTesting veeContactCompleteRecord]];
    return veeContactComplete;
}

- (VeeContact*)veeContactUnified
{
    VeeContact* veeContactUnified = [[VeeContact alloc] initWithLinkedPeopleOfABRecord:[_veeAddressBookForTesting veeContactUnifiedRecord]];
    return veeContactUnified;
}

- (NSArray*)veeContactsFromAddressBookForTesting
{
    NSMutableArray* veeContactsFromABForTestingMutable = [NSMutableArray new];
    for (id abRecordRefBoxed in [_veeAddressBookForTesting recordRefsOfAddressBookForTesting]) {
        VeeContact* veeContact = [[VeeContact alloc] initWithLinkedPeopleOfABRecord:(__bridge ABRecordRef)(abRecordRefBoxed)];
        [veeContactsFromABForTestingMutable addObject:veeContact];
    }
    return [NSArray arrayWithArray:veeContactsFromABForTestingMutable];
}

@end
