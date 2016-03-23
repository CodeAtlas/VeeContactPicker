//
//  Created by Andrea Cipriani on 16/03/16.
//  Copyright © 2016 Code Atlas SRL. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "VeeContactPickerViewController.h"
#import "VeeContactPickerStrings.h"
#import "VeeContactColors.h"
#import "VeeContactPickerOptions.h"
#import "VeeABDelegate.h"
#import "VeeContactsForTestingFactory.h"
#import "VeeAddressBookForTesting.h"
#import "OCMock.h"
#import "VeeAddressBook.h"
#import "VeeContactFactory.h"

#define NUMBER_OF_RANDOM_VEECONTACTS 100

@interface VeeContactPickerViewControllerTests : XCTestCase

@property (nonatomic, strong) VeeContactPickerViewController* veeContactPickerVCWithDefaultOptions;
@property (nonatomic, strong) VeeContactPickerViewController* veeContactPickerVCWithNilOptions;
@property (nonatomic, strong) VeeContactPickerViewController* veeContactPickerVCWithCustomOptions;
@property (nonatomic, strong) VeeContactPickerViewController* veeContactPickerVCWithNilVeeContacts;
@property (nonatomic, strong) VeeContactPickerViewController* veeContactPickerVCWithCustomVeeContacts;
@property (nonatomic, strong) VeeContactPickerViewController* veeContactPickerVCWithCustomVeeContactsAndCustomOptions;

@property (nonatomic, strong) VeeContactPickerOptions* veeContactPickerDefaultOptions;
@property (nonatomic, strong) VeeContactPickerOptions* veeContactPickerCustomOptions;
@end

static NSArray<id<VeeContactProt>>* customVeeContacts;

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
    _veeContactPickerVCWithNilOptions = [[VeeContactPickerViewController alloc] initWithOptions:nil];
    _veeContactPickerVCWithCustomOptions = [[VeeContactPickerViewController alloc] initWithOptions:_veeContactPickerCustomOptions];
    _veeContactPickerVCWithNilVeeContacts = [[VeeContactPickerViewController alloc] initWithVeeContacts:nil];
    _veeContactPickerVCWithCustomVeeContacts = [[VeeContactPickerViewController alloc] initWithVeeContacts:customVeeContacts];
    _veeContactPickerVCWithCustomVeeContactsAndCustomOptions = [[VeeContactPickerViewController alloc] initWithOptions:_veeContactPickerCustomOptions andVeeContacts:customVeeContacts];
}

- (void)tearDown
{
    [super tearDown];
}

#pragma mark - Init

-(void)testInitWithDefaultConfigurationShouldUseDefaultOptions
{
    BOOL optionsAreDefault = [[_veeContactPickerVCWithDefaultOptions valueForKey:@"veeContactPickerOptions"] isEqual:_veeContactPickerDefaultOptions];
    NSAssert(optionsAreDefault, @"VeeContactPickerOptions are not default one");
}

-(void)testInitWithNilOptionsShouldUseDefaults
{
    BOOL pickerOptionsAreDefault = [[_veeContactPickerVCWithNilOptions valueForKey:@"veeContactPickerOptions"] isEqual:_veeContactPickerDefaultOptions];
    NSAssert(pickerOptionsAreDefault, @"VeeContactPickerOptions are not default one");
}

-(void)testInitsShouldSetVeeAddressBook
{
    BOOL isVeeABSetForInitWithDefaultConfiguration = [_veeContactPickerVCWithDefaultOptions valueForKey:@"veeAddressBook"];
    BOOL isVeeABBookSetForInitWithNilOptions = [_veeContactPickerVCWithNilOptions valueForKey:@"veeAddressBook"];
    BOOL isVeeABBookSetForInitWithVeeNilContacts = [_veeContactPickerVCWithNilVeeContacts valueForKey:@"veeAddressBook"];
    BOOL isVeeABBookSetForInitWithCustomVeeContacts = [_veeContactPickerVCWithCustomVeeContacts valueForKey:@"veeAddressBook"];
    BOOL isVeeABBookSetForInitWithCustomVeeContactsAndOptions = [_veeContactPickerVCWithCustomVeeContactsAndCustomOptions valueForKey:@"veeAddressBook"];

    NSAssert(isVeeABSetForInitWithDefaultConfiguration, @"VeeAddressBook should be set in init with default configuration");
    NSAssert(isVeeABBookSetForInitWithNilOptions, @"VeeAddressBook should be set in init with nil options");
    NSAssert(isVeeABBookSetForInitWithVeeNilContacts, @"VeeAddressBook should be set in init with nil veecontacts");
    NSAssert(isVeeABBookSetForInitWithCustomVeeContacts, @"VeeAddressBook should be set in init with custom veecontacts");
    NSAssert(isVeeABBookSetForInitWithCustomVeeContactsAndOptions, @"VeeAddressBook should be set in init with custom veecontacts and custom options");
}

-(void)testInitWithNilVeeContactsShouldHaveNilVeeContactsBeforeLoadingView
{
    BOOL veeContactsAreNil = [_veeContactPickerVCWithNilVeeContacts valueForKey:@"veeContacts"] == nil;
    NSAssert(veeContactsAreNil, @"Init with nil VeeContacts should have nil veeContactss");
}

-(void)testInitWithNilVeeContactsShouldUseVeeContactsFromAB
{
    id veeAB = OCMClassMock([VeeAddressBook class]);
    OCMStub([veeAB askABPermissionsIfNeeded:[OCMArg anyPointer]]).andReturn(YES);
    
    id veeContactFactoryMock = OCMClassMock([VeeContactFactory class]);
    OCMStub([veeContactFactoryMock veeContactsFromAddressBook:[OCMArg anyPointer]]).andReturn(customVeeContacts);
   
    [_veeContactPickerVCWithNilVeeContacts view];
    
    NSUInteger numberOfVeeContactsLoaded = [[_veeContactPickerVCWithNilVeeContacts valueForKey:@"veeContacts"] count];
    BOOL isNumberOfVeeContactsCorrect = numberOfVeeContactsLoaded == NUMBER_OF_RANDOM_VEECONTACTS;
    NSAssert(isNumberOfVeeContactsCorrect, @"There are %zd veeContacts in the Address Book but there are %zd veecontacts laded",NUMBER_OF_RANDOM_VEECONTACTS,numberOfVeeContactsLoaded);
}

-(void)testInitWithCustomVeecontacts
{
    [_veeContactPickerVCWithCustomVeeContacts view];
    NSUInteger numberOfVeeContactsLoaded = [[_veeContactPickerVCWithCustomVeeContacts valueForKey:@"veeContacts"] count];
    BOOL isNumberOfCustomVeeContactsCorrect =  numberOfVeeContactsLoaded == NUMBER_OF_RANDOM_VEECONTACTS;
    NSAssert(isNumberOfCustomVeeContactsCorrect, @"Init with %zd custom veecontacts but there are %zd veecontacts loaded",NUMBER_OF_RANDOM_VEECONTACTS,numberOfVeeContactsLoaded);
}

#pragma mark - Outlets

-(void)testContactsTableViewOutletShouldBeConnected
{
    NSAssert(_veeContactPickerVCWithDefaultOptions.contactsTableView, @"TableView outlet is not connected");
}

-(void)testCancelBarButtonItemOutletShouldBeConnected
{
    NSAssert(_veeContactPickerVCWithDefaultOptions.cancelBarButtonItem, @"CancelBarButtonItem outlet is not connected");
}

-(void)testTitleNavigationItemOutletShouldBeConnected
{
    NSAssert(_veeContactPickerVCWithDefaultOptions.titleNavigationItem, @"TitleNavigationItem outlet is not connected");
}

#pragma mark - Actions

-(void)testCancelBarButtonItemPressedAction
{
    BOOL isActionCorrect = [_veeContactPickerVCWithDefaultOptions.cancelBarButtonItem action] == @selector(cancelBarButtonItemPressed:);
    NSAssert(isActionCorrect, @"CancelBarButtonItem action is not cancelBarButtonItemPressed:");
}

#pragma mark - Strings

-(void)testTitleNavigationItemTitleShouldBeInitialized
{
    BOOL isTitleCorrect = [_veeContactPickerVCWithDefaultOptions.titleNavigationItem.title isEqualToString:_veeContactPickerDefaultOptions.veeContactPickerStrings.navigationBarTitle];
    NSAssert(isTitleCorrect, @"TitleNavigationItem title is %@ but should be %@",_veeContactPickerVCWithDefaultOptions.titleNavigationItem.title,_veeContactPickerDefaultOptions.veeContactPickerStrings.navigationBarTitle);
}

-(void)testCancelBarButtomItemTitleShouldBeInitialized
{
    BOOL isTitleCorrect = [_veeContactPickerVCWithDefaultOptions.cancelBarButtonItem.title isEqualToString:_veeContactPickerDefaultOptions.veeContactPickerStrings.cancelButtonTitle];
    NSAssert(isTitleCorrect, @"CancelBarButtomItem title is %@ but should be %@",_veeContactPickerVCWithDefaultOptions.cancelBarButtonItem.title,_veeContactPickerDefaultOptions.veeContactPickerStrings.cancelButtonTitle);
}

#pragma mark - Delegates

-(void)testConformsToVeeABDelegate
{
    BOOL conformsToVeeABDelegate = [VeeContactPickerViewController conformsToProtocol:@protocol(VeeABDelegate)];
    NSAssert(conformsToVeeABDelegate, @"Picker should conforms to VeeABDelegate protocol ");
}

#pragma mark - Table View

-(void)testTableViewDataSourceIsNotNil
{
    BOOL isDataSourceSet = _veeContactPickerVCWithDefaultOptions.contactsTableView.dataSource;
    NSAssert(isDataSourceSet, @"Table view has no data source");
}

-(void)testTableViewDelegateIsNotNil
{
    BOOL isDelegateSet = _veeContactPickerVCWithDefaultOptions.contactsTableView.delegate;
    NSAssert(isDelegateSet, @"Table view has no delegates");
}

#pragma mark - Private utils

-(VeeContactPickerViewController*)veeContactPickerWithDefaultConfAndViewLoaded
{
    VeeContactPickerViewController *veeContactPickerVC = [[VeeContactPickerViewController alloc] initWithDefaultConfiguration];
    [veeContactPickerVC view];
    return veeContactPickerVC;
}

-(VeeContactPickerOptions*)veeContactPickerCustomOptions
{
    if(!_veeContactPickerCustomOptions){
        _veeContactPickerCustomOptions = [VeeContactPickerOptions new];
    _veeContactPickerCustomOptions.veeContactColors = [[VeeContactColors alloc] initWithVeeContactsColorPalette:@[[UIColor purpleColor]]];
    _veeContactPickerCustomOptions.veeContactPickerStrings = [[VeeContactPickerStrings alloc] initWithNavigationBarTitle:@"foo" andCancelButtonTitle:@"bar"];
    _veeContactPickerCustomOptions.sectionIdentifiers = @[@"A",@"B",@"C"];
    _veeContactPickerCustomOptions.sectionIdentifierWildcard = @"$";
    _veeContactPickerCustomOptions.showLettersWhenContactImageIsMissing = NO;
    _veeContactPickerCustomOptions.contactThumbnailImagePlaceholder = [self codeAtasTestImage];
    }
    return _veeContactPickerCustomOptions;
}

-(UIImage*)codeAtasTestImage
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *imagePath = [bundle pathForResource:@"codeatlas" ofType:@"png"];
    UIImage *codeAtlasImage = [UIImage imageWithContentsOfFile:imagePath];
    NSAssert(codeAtlasImage, @"codeatlas image not found");
    return codeAtlasImage;
}

//testContactsAreLoadedFromABIfNil
//testEmptyView
//testContactsAreShown
//testSearch
//test delegate

@end
