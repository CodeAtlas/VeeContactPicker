//
//  VeeContactPickerStringsTests.m
//  VeeContactPicker
//
//  Created by Andrea Cipriani on 16/03/16.
//  Copyright © 2016 Code Atlas SRL. All rights reserved.
//

#import "VeeContactPickerStrings.h"
#import <XCTest/XCTest.h>

@interface VeeContactPickerStringsTests : XCTestCase

@property (nonatomic, strong) VeeContactPickerStrings* veeContactPickerDefaultStrings;

@end

@implementation VeeContactPickerStringsTests

- (void)setUp
{
    [super setUp];
    _veeContactPickerDefaultStrings = [[VeeContactPickerStrings alloc] initWithDefaultStrings];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testDefaultNavigationBarTitleShouldNotBeNil
{
    NSAssert([_veeContactPickerDefaultStrings navigationBarTitle], @"NavigationBarTitle should not be nil");
}

- (void)testDefaultCancelButtonShouldNotBeNil
{
    NSAssert([_veeContactPickerDefaultStrings cancelButtonTitle], @"CancelButtonTitle should not be nil");
}

-(void)testCustomStrings
{
    NSString* navigationBarTitle = @"foo";
    NSString* cancelButtonTitle = @"bar";
    VeeContactPickerStrings* veeContactPickerCustomStrings = [[VeeContactPickerStrings alloc] initWithNavigationBarTitle:navigationBarTitle andCancelButtonTitle:cancelButtonTitle];
    BOOL isNavigationBarTitleCorrect = [veeContactPickerCustomStrings.navigationBarTitle isEqualToString:navigationBarTitle];
    BOOL isCancelButtonTitleCorrect = [veeContactPickerCustomStrings.cancelButtonTitle isEqualToString:cancelButtonTitle];
    NSAssert(isNavigationBarTitleCorrect && isCancelButtonTitleCorrect, @"Custom strings are not set properly");
}

@end
