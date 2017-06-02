//
//  Created by Andrea Cipriani on 16/03/16.
//  Copyright © 2016 Code Atlas SRL. All rights reserved.
//

#import "VeeContactPickerViewController.h"
#import <XCTest/XCTest.h>
#import "XCTest+VeeCommons.h"
#import "OCMock.h"
#import "VeeContactPickerOptions.h"
#import "VeeContactPickerStrings.h"
#import "VeeABDelegate.h"
#import "VeeAddressBook.h"
#import "VeeContactFactory.h"
#import "VeeContactPickerAppearanceConstants.h"
#import "VeeContactPickerDelegate.h"
#import "VeeContactsForTestingFactory.h"

#define NUMBER_OF_RANDOM_VEECONTACTS 100

@interface VeeContactPickerViewControllerTests : XCTestCase

@property (nonatomic, strong) VeeContactPickerViewController* veeContactPickerVCWithDefaultOptions;
@property (nonatomic, strong) VeeContactPickerViewController* veeContactPickerVCWithCustomVeeContacts;

@property (nonatomic, strong) VeeContactPickerOptions* veeContactPickerDefaultOptions;
@property (nonatomic, strong) VeeContactPickerOptions* veeContactPickerCustomOptions;
@end

static NSArray<id<VeeContactProt> >* customVeeContacts;

@implementation VeeContactPickerViewControllerTests

#pragma mark - Class setup

+ (void)setUp
{
    customVeeContacts = [VeeContactsForTestingFactory createRandomVeeContacts:NUMBER_OF_RANDOM_VEECONTACTS];
}

#pragma mark - Methods setup

- (void)setUp
{
    [super setUp];
    self.veeContactPickerDefaultOptions = [VeeContactPickerOptions defaultOptions];
    self.veeContactPickerCustomOptions = self.veeContactPickerCustomOptions;
    self.veeContactPickerVCWithDefaultOptions = [self veeContactPickerWithDefaultConfAndViewLoaded];
    self.veeContactPickerVCWithCustomVeeContacts = [[VeeContactPickerViewController alloc] initWithVeeContacts:customVeeContacts];
}

- (void)tearDown
{
    [super tearDown];
}

#pragma mark - Init

- (void)testInitsShouldSetVeeAddressBook
{
    BOOL isVeeABSetForInitWithDefaultConfiguration = [_veeContactPickerVCWithDefaultOptions valueForKey:@"veeAddressBook"] != nil;
    BOOL isVeeABBookSetForInitWithCustomVeeContacts = [_veeContactPickerVCWithCustomVeeContacts valueForKey:@"veeAddressBook"] != nil;

    NSAssert(isVeeABSetForInitWithDefaultConfiguration, @"VeeAddressBook should be set in init with default configuration");
    NSAssert(isVeeABBookSetForInitWithCustomVeeContacts, @"VeeAddressBook should be set in init with custom veecontacts");
}

- (void)testInitWithCustomVeecontacts
{
    [self.veeContactPickerVCWithCustomVeeContacts loadView];
    NSUInteger numberOfVeeContactsLoaded = [[_veeContactPickerVCWithCustomVeeContacts valueForKey:@"veeContacts"] count];
    BOOL isNumberOfCustomVeeContactsCorrect = numberOfVeeContactsLoaded == NUMBER_OF_RANDOM_VEECONTACTS;
    NSAssert(isNumberOfCustomVeeContactsCorrect, @"Init with %zd custom veecontacts but there are %zd veecontacts loaded", NUMBER_OF_RANDOM_VEECONTACTS, numberOfVeeContactsLoaded);
}

#pragma mark - Outlets

- (void)testContactsTableViewOutletShouldBeConnected
{
    NSAssert(self.veeContactPickerVCWithDefaultOptions.contactsTableView, @"TableView outlet is not connected");
}

- (void)testCancelBarButtonItemOutletShouldBeConnected
{
    NSAssert(self.veeContactPickerVCWithDefaultOptions.cancelBarButtonItem, @"CancelBarButtonItem outlet is not connected");
}

- (void)testTitleNavigationItemOutletShouldBeConnected
{
    NSAssert(self.veeContactPickerVCWithDefaultOptions.titleNavigationItem, @"TitleNavigationItem outlet is not connected");
}

#pragma mark - Actions

- (void)testCancelBarButtonItemPressedAction
{
    BOOL isActionCorrect = (_veeContactPickerVCWithDefaultOptions.cancelBarButtonItem).action == @selector(cancelBarButtonItemPressed:);
    NSAssert(isActionCorrect, @"CancelBarButtonItem action is not cancelBarButtonItemPressed:");
}

#pragma mark - Strings

- (void)testTitleNavigationItemTitleShouldBeInitialized
{
    BOOL isTitleCorrect = [_veeContactPickerVCWithDefaultOptions.titleNavigationItem.title isEqualToString:_veeContactPickerDefaultOptions.veeContactPickerStrings.navigationBarTitle];
    NSAssert(isTitleCorrect, @"TitleNavigationItem title is %@ but should be %@", _veeContactPickerVCWithDefaultOptions.titleNavigationItem.title, self.veeContactPickerDefaultOptions.veeContactPickerStrings.navigationBarTitle);
}

- (void)testCancelBarButtomItemTitleShouldBeInitialized
{
    BOOL isTitleCorrect = [_veeContactPickerVCWithDefaultOptions.cancelBarButtonItem.title isEqualToString:_veeContactPickerDefaultOptions.veeContactPickerStrings.cancelButtonTitle];
    NSAssert(isTitleCorrect, @"CancelBarButtomItem title is %@ but should be %@", _veeContactPickerVCWithDefaultOptions.cancelBarButtonItem.title, _veeContactPickerDefaultOptions.veeContactPickerStrings.cancelButtonTitle);
}

#pragma mark - Delegates

- (void)testConformsToVeeABDelegate
{
    BOOL conformsToVeeABDelegate = [VeeContactPickerViewController conformsToProtocol:@protocol(VeeABDelegate)];
    NSAssert(conformsToVeeABDelegate, @"Picker should conforms to VeeABDelegate protocol ");
}

#pragma mark - Empty view

-(void)testEmptyViewIsNotShownWhenThereAreContacts
{
    VeeContactPickerViewController* defaultPickerViewController = [self veeContactPickerWithDefaultConfAndViewLoaded];
    BOOL tableViewShouldNotBeHidden = defaultPickerViewController.contactsTableView.hidden == NO;
    UILabel* emptyViewLabel = (UILabel*) [defaultPickerViewController valueForKey:@"emptyViewLabel"];
    BOOL emptyViewLabelShouldBeHidden = emptyViewLabel.hidden == YES;

    NSAssert(tableViewShouldNotBeHidden && emptyViewLabelShouldBeHidden, @"Empty view should not be shown if there are contacts!");
}


#pragma mark - VeeContactPickerDelegate

- (void)testContactPickerDelegateDidSelectContact
{
    id mockContactDelegate = OCMProtocolMock(@protocol(VeeContactPickerDelegate));
    VeeContactPickerViewController* veeContactPicker = _veeContactPickerVCWithCustomVeeContacts;
    veeContactPicker.contactPickerDelegate = mockContactDelegate;
    [veeContactPicker loadView];
    id mockedTableView = OCMClassMock([UITableView class]);
    [veeContactPicker tableView:mockedTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];

    OCMVerify([mockContactDelegate didSelectContact:[OCMArg any]]);
}

- (void)testContactPickerDelegateDidCancel
{
    id mockContactDelegate = OCMProtocolMock(@protocol(VeeContactPickerDelegate));
    VeeContactPickerViewController* veeContactPicker = _veeContactPickerVCWithCustomVeeContacts;
    veeContactPicker.contactPickerDelegate = mockContactDelegate;
    [veeContactPicker loadView];
    [veeContactPicker cancelBarButtonItemPressed:self];
    OCMVerify([mockContactDelegate didCancelContactSelection]);
}

- (void)testContactPickerDelegateDidFailToAccessAddressBook
{
    id mockContactDelegate = OCMProtocolMock(@protocol(VeeContactPickerDelegate));
    VeeContactPickerViewController* veeContactPicker = _veeContactPickerVCWithCustomVeeContacts;
    veeContactPicker.contactPickerDelegate = mockContactDelegate;
    [veeContactPicker loadView];
    [veeContactPicker abPermissionsNotGranted];

    OCMVerify([mockContactDelegate didFailToAccessAddressBook]);
}

#pragma mark - Completion handler

- (void)testContactSelectionHandlerIsCalled
{
    VeeContactPickerViewController* veeContactPicker = _veeContactPickerVCWithCustomVeeContacts;
    __block BOOL isBlockInvoked = NO;
    veeContactPicker.contactSelectionHandler = ^void(id<VeeContactProt> selectedVeeContact) {
        isBlockInvoked = YES;
    };

    [veeContactPicker loadView];
    id mockedTableView = OCMClassMock([UITableView class]);
    [veeContactPicker tableView:mockedTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];

    NSAssert(isBlockInvoked, @"Contact selection handler should be invoked");
}

#pragma mark - Private utils

- (VeeContactPickerViewController*)veeContactPickerWithDefaultConfAndViewLoaded
{
    VeeContactPickerViewController* veeContactPickerVC = [[VeeContactPickerViewController alloc] initWithDefaultConfiguration];
    [veeContactPickerVC loadView];
    return veeContactPickerVC;
}

- (VeeContactPickerOptions*)veeContactPickerCustomOptions
{
    if (!_veeContactPickerCustomOptions) {
        _veeContactPickerCustomOptions = [VeeContactPickerOptions new];
        _veeContactPickerCustomOptions.veeContactPickerStrings = [[VeeContactPickerStrings alloc] initWithNavigationBarTitle:@"foo" cancelButtonTitle:@"bar" emptyViewLabelText:@"empty"];
        _veeContactPickerCustomOptions.sectionIdentifiers = @[ @"A", @"B", @"C" ];
        _veeContactPickerCustomOptions.sectionIdentifierWildcard = @"$";
        _veeContactPickerCustomOptions.showInitialsPlaceholder = NO;
        _veeContactPickerCustomOptions.contactThumbnailImagePlaceholder = [self veeTestImage];
    }
    return _veeContactPickerCustomOptions;
}

@end
