//
//  Created by Andrea Cipriani on 21/03/16.
//  Copyright © 2016 Code Atlas SRL. All rights reserved.
//

#import "VeeIsEmpty.h"
#import <XCTest/XCTest.h>

@interface VeeIsEmptyTests : XCTestCase

@end

@implementation VeeIsEmptyTests

- (void)testExample
{
    NSAssert([VeeIsEmpty isEmpty:nil] == YES, @"nil should be empty");
    NSAssert([VeeIsEmpty isEmpty:@""] == YES, @"an empty string should be empty");
    NSAssert([VeeIsEmpty isEmpty:@"foo"] == NO, @"foo should not be empty");
}

@end
