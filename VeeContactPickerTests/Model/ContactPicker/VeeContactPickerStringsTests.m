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

- (void)testDefaultEmptyViewTextShouldNotBeNil
{
    NSAssert([_veeContactPickerDefaultStrings emptyViewLabelText], @"EmptyViewLabelText should not be nil");
}

-(void)testCustomStringsAreSet
{
    NSString* navigationBarTitle = @"foo";
    NSString* cancelButtonTitle = @"bar";
    NSString* emptyViewTitle = @"lol";

    VeeContactPickerStrings* veeContactPickerCustomStrings = [[VeeContactPickerStrings alloc] initWithNavigationBarTitle:navigationBarTitle cancelButtonTitle:cancelButtonTitle emptyViewLabelText:emptyViewTitle];
    BOOL isNavigationBarTitleCorrect = [veeContactPickerCustomStrings.navigationBarTitle isEqualToString:navigationBarTitle];
    BOOL isCancelButtonTitleCorrect = [veeContactPickerCustomStrings.cancelButtonTitle isEqualToString:cancelButtonTitle];
    BOOL isEmptyViewTitleCorrect = [veeContactPickerCustomStrings.emptyViewLabelText isEqualToString:emptyViewTitle];

    NSAssert(isNavigationBarTitleCorrect && isCancelButtonTitleCorrect && isEmptyViewTitleCorrect, @"Custom strings are not set properly");
}

@end
