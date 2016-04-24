//
//  Created by Andrea Cipriani on 21/03/16.
//  Copyright © 2016 Code Atlas SRL. All rights reserved.
//

#import "VeeCommons.h"
#import <XCTest/XCTest.h>

@interface VeeCommonsTests : XCTestCase

@end

@implementation VeeCommonsTests

- (void)testIsEmpty
{
    NSAssert([VeeCommons vee_isEmpty:nil] == YES, @"nil should be empty");
    NSAssert([VeeCommons vee_isEmpty:@""] == YES, @"an empty string should be empty");
    NSAssert([VeeCommons vee_isEmpty:@"foo"] == NO, @"foo should not be empty");
}

- (void)testIsNotEmpty
{
    NSAssert([VeeCommons vee_isNotEmpty:nil] == NO, @"nil should be empty");
    NSAssert([VeeCommons vee_isNotEmpty:@""] == NO, @"an empty string should be empty");
    NSAssert([VeeCommons vee_isNotEmpty:@"foo"] == YES, @"foo should not be empty");
}

@end
