//
//  Created by Andrea Cipriani on 30/03/16.
//  Copyright © 2016 Code Atlas SRL. All rights reserved.
//

#import "VeePostalAddress.h"
#import <XCTest/XCTest.h>

@interface VeePostalAddressTests : XCTestCase

@end

@implementation VeePostalAddressTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testCompleteUnifiedAddres
{
    VeePostalAddress * veePostalAddress = [[VeePostalAddress alloc] initWithStreet:@"Campo dei Fiori" city:@"Roma" state:@"Lazio" postal:@"20123" country:@"Italy"];
    NSString* expectedUnifiedAddress = @"Campo dei Fiori, Roma, Lazio, 20123, Italy";
    BOOL isUnifiedAddressCorrect = [expectedUnifiedAddress isEqualToString:[veePostalAddress unifiedAddress]];
    NSAssert(isUnifiedAddressCorrect, @"Unified address is %@ but should be %@",[veePostalAddress unifiedAddress], expectedUnifiedAddress);
}

- (void)testUnifiedAddresWithOnlyCity
{
    VeePostalAddress * veePostalAddress = [[VeePostalAddress alloc] initWithStreet:nil city:@"Roma" state:nil postal:nil country:nil];
    NSString* expectedUnifiedAddress = @"Roma";
    BOOL isUnifiedAddressCorrect = [expectedUnifiedAddress isEqualToString:[veePostalAddress unifiedAddress]];
    NSAssert(isUnifiedAddressCorrect, @"Unified address is %@ but should be %@",[veePostalAddress unifiedAddress], expectedUnifiedAddress);
}

- (void)testUnifiedAddresWithoutParametersShouldBeEmpty
{
    VeePostalAddress * veePostalAddress = [[VeePostalAddress alloc] initWithStreet:nil city:nil state:nil postal:nil country:nil];
    NSString* expectedUnifiedAddress = @"";
    BOOL isUnifiedAddressCorrect = [expectedUnifiedAddress isEqualToString:[veePostalAddress unifiedAddress]];
    NSAssert(isUnifiedAddressCorrect, @"Unified address is %@ but should be %@",[veePostalAddress unifiedAddress], expectedUnifiedAddress);
}


@end
