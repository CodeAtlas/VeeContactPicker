//
//  Created by Andrea Cipriani on 16/03/16.
//  Copyright © 2016 Code Atlas SRL. All rights reserved.
//

#import "VeeContactPickerViewController.h"
#import <XCTest/XCTest.h>

#import "VeeContactPickerOptions.h"
#import "VeeContactPickerStrings.h"

#import "OCMock.h"
#import "VeeABDelegate.h"
#import "VeeAddressBook.h"
#import "VeeContactFactory.h"
#import "VeeContactPickerConstants.h"
#import "VeeContactPickerDelegate.h"
#import "VeeContactsForTestingFactory.h"
#import "XCTest+VeeCommons.h"

#define NUMBER_OF_RANDOM_VEECONTACTS 100

@interface VeeContactPickerViewControllerTests : XCTestCase

@property (nonatomic, strong) VeeContactPickerViewController* veeContactPickerVCWithDefaultOptions;
@property (nonatomic, strong) VeeContactPickerViewController* veeContactPickerVCWithNilVeeContacts;
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
    _veeContactPickerDefaultOptions = [VeeContactPickerOptions defaultOptions];
    _veeContactPickerCustomOptions = [self veeContactPickerCustomOptions];
    _veeContactPickerVCWithDefaultOptions = [self veeContactPickerWithDefaultConfAndViewLoaded];
    _veeContactPickerVCWithNilVeeContacts = [[VeeContactPickerViewController alloc] initWithVeeContacts:nil];
    _veeContactPickerVCWithCustomVeeContacts = [[VeeContactPickerViewController alloc] initWithVeeContacts:customVeeContacts];
}

- (void)tearDown
{
    [super tearDown];
}

#pragma mark - Init

- (void)testInitsShouldSetVeeAddressBook
{
    BOOL isVeeABSetForInitWithDefaultConfiguration = [_veeContactPickerVCWithDefaultOptions valueForKey:@"veeAddressBook"];
    BOOL isVeeABBookSetForInitWithVeeNilContacts = [_veeContactPickerVCWithNilVeeContacts valueForKey:@"veeAddressBook"];
    BOOL isVeeABBookSetForInitWithCustomVeeContacts = [_veeContactPickerVCWithCustomVeeContacts valueForKey:@"veeAddressBook"];

    NSAssert(isVeeABSetForInitWithDefaultConfiguration, @"VeeAddressBook should be set in init with default configuration");
    NSAssert(isVeeABBookSetForInitWithVeeNilContacts, @"VeeAddressBook should be set in init with nil veecontacts");
    NSAssert(isVeeABBookSetForInitWithCustomVeeContacts, @"VeeAddressBook should be set in init with custom veecontacts");
}

- (void)testInitWithNilVeeContactsShouldHaveNilVeeContactsBeforeLoadingView
{
    BOOL veeContactsAreNil = [_veeContactPickerVCWithNilVeeContacts valueForKey:@"veeContacts"] == nil;
    NSAssert(veeContactsAreNil, @"Init with nil VeeContacts should have nil veeContactss");
}

- (void)testInitWithNilVeeContactsShouldUseVeeContactsFromAB
{
    id veeAB = OCMClassMock([VeeAddressBook class]);
    OCMStub([veeAB askABPermissionsWithDelegateCallback:[OCMArg anyPointer]]).andReturn(YES);

    id veeContactFactoryMock = OCMClassMock([VeeContactFactory class]);
    OCMStub([veeContactFactoryMock veeContactProtsFromAddressBook:[OCMArg anyPointer]]).andReturn(customVeeContacts);

    [_veeContactPickerVCWithNilVeeContacts view];

    NSUInteger numberOfVeeContactsLoaded = [[_veeContactPickerVCWithNilVeeContacts valueForKey:@"veeContacts"] count];
    BOOL isNumberOfVeeContactsCorrect = numberOfVeeContactsLoaded == NUMBER_OF_RANDOM_VEECONTACTS;
    NSAssert(isNumberOfVeeContactsCorrect, @"There are %zd veeContacts in the Address Book but there are %zd veecontacts laded", NUMBER_OF_RANDOM_VEECONTACTS, numberOfVeeContactsLoaded);
}

- (void)testInitWithCustomVeecontacts
{
    [_veeContactPickerVCWithCustomVeeContacts view];
    NSUInteger numberOfVeeContactsLoaded = [[_veeContactPickerVCWithCustomVeeContacts valueForKey:@"veeContacts"] count];
    BOOL isNumberOfCustomVeeContactsCorrect = numberOfVeeContactsLoaded == NUMBER_OF_RANDOM_VEECONTACTS;
    NSAssert(isNumberOfCustomVeeContactsCorrect, @"Init with %zd custom veecontacts but there are %zd veecontacts loaded", NUMBER_OF_RANDOM_VEECONTACTS, numberOfVeeContactsLoaded);
}

#pragma mark - Outlets

- (void)testContactsTableViewOutletShouldBeConnected
{
    NSAssert(_veeContactPickerVCWithDefaultOptions.contactsTableView, @"TableView outlet is not connected");
}

- (void)testCancelBarButtonItemOutletShouldBeConnected
{
    NSAssert(_veeContactPickerVCWithDefaultOptions.cancelBarButtonItem, @"CancelBarButtonItem outlet is not connected");
}

- (void)testTitleNavigationItemOutletShouldBeConnected
{
    NSAssert(_veeContactPickerVCWithDefaultOptions.titleNavigationItem, @"TitleNavigationItem outlet is not connected");
}

#pragma mark - Actions

- (void)testCancelBarButtonItemPressedAction
{
    BOOL isActionCorrect = [_veeContactPickerVCWithDefaultOptions.cancelBarButtonItem action] == @selector(cancelBarButtonItemPressed:);
    NSAssert(isActionCorrect, @"CancelBarButtonItem action is not cancelBarButtonItemPressed:");
}

#pragma mark - Strings

- (void)testTitleNavigationItemTitleShouldBeInitialized
{
    BOOL isTitleCorrect = [_veeContactPickerVCWithDefaultOptions.titleNavigationItem.title isEqualToString:_veeContactPickerDefaultOptions.veeContactPickerStrings.navigationBarTitle];
    NSAssert(isTitleCorrect, @"TitleNavigationItem title is %@ but should be %@", _veeContactPickerVCWithDefaultOptions.titleNavigationItem.title, _veeContactPickerDefaultOptions.veeContactPickerStrings.navigationBarTitle);
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

#pragma mark - Table View

- (void)testTableViewDataSourceIsNotNil
{
    BOOL isDataSourceSet = _veeContactPickerVCWithDefaultOptions.contactsTableView.dataSource;
    NSAssert(isDataSourceSet, @"Table view has no data source");
}

- (void)testTableViewDelegateIsNotNil
{
    BOOL isDelegateSet = _veeContactPickerVCWithDefaultOptions.contactsTableView.delegate;
    NSAssert(isDelegateSet, @"Table view has no delegates");
}

#pragma mark - Empty view

-(void)testEmptyViewIsNotShownWhenThereAreContacts
{
    VeeContactPickerViewController* defaultPickerViewController = [self veeContactPickerWithDefaultConfAndViewLoaded];
    BOOL tableViewShouldNotBeHidden = [defaultPickerViewController contactsTableView].hidden == NO;
    UISearchBar* searchBar = (UISearchBar*) [defaultPickerViewController valueForKey:@"searchBar"];
    BOOL searchBarShouldBeHidden = searchBar.hidden == NO;
    UILabel* emptyViewLabel = (UILabel*) [defaultPickerViewController valueForKey:@"emptyViewLabel"];
    BOOL emptyViewLabelShouldBeHidden = emptyViewLabel.hidden == YES;

    NSAssert(tableViewShouldNotBeHidden && searchBarShouldBeHidden && emptyViewLabelShouldBeHidden, @"Empty view should not be shown if there are contacts!");
}
 
-(void)testEmptyViewIsShownForNoContacts
{
    VeeContactPickerViewController* veeContactPickerWithNoVeeContacts = [[VeeContactPickerViewController alloc] initWithVeeContacts:@[]];
    [veeContactPickerWithNoVeeContacts view];
    
    NSDate *loopTimeout = [NSDate dateWithTimeIntervalSinceNow:10];
    BOOL isTableViewVisible = [veeContactPickerWithNoVeeContacts contactsTableView].hidden == NO;
    while (isTableViewVisible && [loopTimeout timeIntervalSinceNow] > 0) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:loopTimeout];
    }

    BOOL tableViewShouldBeHidden = [veeContactPickerWithNoVeeContacts contactsTableView].hidden == YES;
    UISearchBar* searchBar = (UISearchBar*) [veeContactPickerWithNoVeeContacts valueForKey:@"searchBar"];
    BOOL searchBarShouldBeHidden = searchBar.hidden == YES;
    UILabel* emptyViewLabel = (UILabel*) [veeContactPickerWithNoVeeContacts valueForKey:@"emptyViewLabel"];
    BOOL emptyViewLabelShouldNotBeHidden = emptyViewLabel.hidden == NO;
    
    NSAssert(tableViewShouldBeHidden && searchBarShouldBeHidden && emptyViewLabelShouldNotBeHidden, @"Empty view should be shown if there are no contacts!");
}

#pragma mark - VeeContactPickerDelegate

- (void)testContactPickerDelegateDidSelectContact
{
    id mockContactDelegate = OCMProtocolMock(@protocol(VeeContactPickerDelegate));
    VeeContactPickerViewController* veeContactPicker = _veeContactPickerVCWithCustomVeeContacts;
    veeContactPicker.contactPickerDelegate = mockContactDelegate;
    [veeContactPicker view];
    id mockedTableView = OCMClassMock([UITableView class]);
    [veeContactPicker tableView:mockedTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];

    OCMVerify([mockContactDelegate didSelectABContact:[OCMArg any]]);
}

- (void)testContactPickerDelegateDidCancel
{
    id mockContactDelegate = OCMProtocolMock(@protocol(VeeContactPickerDelegate));
    VeeContactPickerViewController* veeContactPicker = _veeContactPickerVCWithCustomVeeContacts;
    veeContactPicker.contactPickerDelegate = mockContactDelegate;
    [veeContactPicker view];
    [veeContactPicker cancelBarButtonItemPressed:nil];
    OCMVerify([mockContactDelegate didCancelABContactSelection]);
}

- (void)testContactPickerDelegateDidFailToAccessAddressBook
{
    id mockContactDelegate = OCMProtocolMock(@protocol(VeeContactPickerDelegate));
    VeeContactPickerViewController* veeContactPicker = _veeContactPickerVCWithCustomVeeContacts;
    veeContactPicker.contactPickerDelegate = mockContactDelegate;
    [veeContactPicker view];
    [veeContactPicker abPermissionsGranted:NO];

    OCMVerify([mockContactDelegate didFailToAccessABContacts]);
}

#pragma mark - Completion handler

- (void)testContactSelectionHandlerIsCalled
{
    VeeContactPickerViewController* veeContactPicker = _veeContactPickerVCWithCustomVeeContacts;
    __block BOOL isBlockInvoked = NO;
    veeContactPicker.contactSelectionHandler = ^void(id<VeeContactProt> selectedVeeContact) {
        isBlockInvoked = YES;
    };

    [veeContactPicker view];
    id mockedTableView = OCMClassMock([UITableView class]);
    [veeContactPicker tableView:mockedTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];

    NSAssert(isBlockInvoked, @"Contact selection handler should be invoked");
}

#pragma mark - Private utils

- (VeeContactPickerViewController*)veeContactPickerWithDefaultConfAndViewLoaded
{
    VeeContactPickerViewController* veeContactPickerVC = [[VeeContactPickerViewController alloc] initWithDefaultConfiguration];
    [veeContactPickerVC view];
    return veeContactPickerVC;
}

- (VeeContactPickerOptions*)veeContactPickerCustomOptions
{
    if (!_veeContactPickerCustomOptions) {
        _veeContactPickerCustomOptions = [VeeContactPickerOptions new];
        _veeContactPickerCustomOptions.veeContactPickerStrings = [[VeeContactPickerStrings alloc] initWithNavigationBarTitle:@"foo" cancelButtonTitle:@"bar" emptyViewLabelText:@"empty"];
        _veeContactPickerCustomOptions.sectionIdentifiers = @[ @"A", @"B", @"C" ];
        _veeContactPickerCustomOptions.sectionIdentifierWildcard = @"$";
        _veeContactPickerCustomOptions.showLettersWhenContactImageIsMissing = NO;
        _veeContactPickerCustomOptions.contactThumbnailImagePlaceholder = [self codeAtasTestImage];
    }
    return _veeContactPickerCustomOptions;
}

@end
