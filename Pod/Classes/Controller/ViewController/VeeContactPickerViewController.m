//
//  Created by Andrea Cipriani on 14/12/15.
//  Copyright © 2015 Code Atlas SRL. All rights reserved.
//

#import "VeeContactPickerViewController.h"

#import "VeeContactPickerAppearanceConstants.h"
#import "VeeContactPickerOptions.h"
#import "VeeContactPickerStrings.h"

#import "VeeAddressBook.h"
#import "VeeCommons.h"

#import "VeeContactProtFactoryProducer.h"

#import "VeeContactCellConfiguration.h"
#import "VeeContactProtFactoryProducer.h"
#import "VeeContactUITableViewCell.h"
#import "VeeSectionedArrayDataSource.h"
#import "VeeTableViewSearchDelegate.h"

@interface VeeContactPickerViewController ()

#pragma mark - Outlets

@property (weak, nonatomic) IBOutlet UINavigationBar* navigationBar;
@property (weak, nonatomic) IBOutlet UIView* statusBarCoverView;
@property (weak, nonatomic) IBOutlet UISearchBar* searchBar;

#pragma mark - Constraints

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewBottomMarginConstraint;

#pragma mark - Dependencies

@property (nonatomic, strong) VeeContactPickerOptions* veeContactPickerOptions;
@property (nonatomic) ABAddressBookRef addressBookRef;
@property (nonatomic, strong) VeeAddressBook* veeAddressBook;

#pragma mark - Model

@property (nonatomic, strong) NSArray<id<VeeContactProt> >* veeContacts;
@property (nonatomic, strong) VeeSectionedArrayDataSource* veeSectionedArrayDataSource;

#pragma mark - Search

@property (nonatomic, strong) VeeTableViewSearchDelegate* veeTableViewSearchDelegate;

#pragma mark - Style

@property (nonatomic, strong) VeeContactCellConfiguration* veeContactCellConfiguration;

#pragma mark - Bundle

@property (nonatomic, strong) NSBundle * podBundle;

@end

@implementation VeeContactPickerViewController

#pragma mark - Initializers

- (instancetype)initWithDefaultConfiguration
{
    self = [self initWithOptions:[VeeContactPickerOptions defaultOptions] andVeeContacts:nil];
    return self;
}

- (instancetype)initWithOptions:(VeeContactPickerOptions*)veeContactPickerOptions
{
    self = [self initWithOptions:veeContactPickerOptions andVeeContacts:nil];
    return self;
}

- (instancetype)initWithVeeContacts:(NSArray<id<VeeContactProt> >*)veeContacts
{
    self = [self initWithOptions:[VeeContactPickerOptions defaultOptions] andVeeContacts:veeContacts];
    return self;
}

- (instancetype)initWithOptions:(VeeContactPickerOptions*)veeContactPickerOptions andVeeContacts:(NSArray<id<VeeContactProt> >*)veeContacts
{
    self = [super init];
    if (!self) {
        return nil;
    }
    [self loadBundleOfPod];
    NSAssert(_podBundle,@"Bundle can't be nil");

    self = [[VeeContactPickerViewController alloc] initWithNibName:NSStringFromClass(self.class) bundle:_podBundle];
    _veeContactPickerOptions = veeContactPickerOptions;
    _veeContacts = veeContacts;
    _veeAddressBook = [[VeeAddressBook alloc] initWithVeeABDelegate:self];
    _veeContactCellConfiguration = [[VeeContactCellConfiguration alloc] initWithVeePickerOptions:_veeContactPickerOptions];
    return self;
}

-(void)loadBundleOfPod
{
    NSString *bundlePath = [[NSBundle bundleForClass:[VeeContactPickerViewController class]] pathForResource:@"VeeContactPicker" ofType:@"bundle"];
    _podBundle = [NSBundle bundleWithPath:bundlePath];
    if ([_podBundle isLoaded] == NO){
        [_podBundle load];
    }
}

#pragma mark - ViewController lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self loadStrings];
    [self loadPickerAppearance];
    _addressBookRef = ABAddressBookCreate();
    [self loadVeeContacts];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - DidLoad Utils

- (void)loadStrings
{
    _titleNavigationItem.title = [_veeContactPickerOptions.veeContactPickerStrings navigationBarTitle];
    _cancelBarButtonItem.title = [_veeContactPickerOptions.veeContactPickerStrings cancelButtonTitle];
}

- (void)loadPickerAppearance
{
    _cancelBarButtonItem.tintColor = [[VeeContactPickerAppearanceConstants sharedInstance] cancelBarButtonItemTintColor];
    _navigationBar.tintColor = [[VeeContactPickerAppearanceConstants sharedInstance] navigationBarTintColor];
    _navigationBar.barTintColor = [[VeeContactPickerAppearanceConstants sharedInstance] navigationBarBarTintColor];
    _navigationBar.translucent = [[VeeContactPickerAppearanceConstants sharedInstance] navigationBarTranslucent];
    _statusBarCoverView.backgroundColor = [[VeeContactPickerAppearanceConstants sharedInstance] navigationBarBarTintColor];
    _tableViewBottomMarginConstraint.constant = [[VeeContactPickerAppearanceConstants sharedInstance] veeContactPickerTableViewBottomMargin];
    [self hideEmptyView];
}

- (void)loadVeeContacts
{
    BOOL shouldLoadVeecontactsFromAB = _veeContacts == nil;
    if (shouldLoadVeecontactsFromAB) {
        BOOL hasAlreadyABPermission = [VeeAddressBook hasABPermissions];
        if (hasAlreadyABPermission == YES) {
            [self loadVeeContactsFromAddressBook];
        }
        else {
            [_veeAddressBook askABPermissionsWithDelegate:_addressBookRef];
        }
    }
    else {
        [self loadCustomVeecontacts];
    }
}

- (void)loadCustomVeecontacts
{
    if ([VeeCommons vee_isEmpty:_veeContacts]) {
        [self showEmptyView];
    }
    else {
        _veeContacts = [_veeContacts sortedArrayUsingSelector:@selector(compare:)];
        [self setupTableView];
    }
}

- (void)loadVeeContactsFromAddressBook
{
    id<VeeContactFactoryProt> veeContactFactoryProt = [VeeContactProtFactoryProducer veeContactProtFactory];
    _veeContacts = [[veeContactFactoryProt class] veeContactProtsFromAddressBook:_addressBookRef];
    _veeContacts = [_veeContacts sortedArrayUsingSelector:@selector(compare:)];
    [self setupTableView];
}

- (void)setupTableView
{
    [self registerCellsForReuse];
    ConfigureCellBlock veeContactConfigureCellBlock = ^(VeeContactUITableViewCell* cell, id<VeeContactProt> veeContact) {
        [_veeContactCellConfiguration configureCell:cell forVeeContact:veeContact];
    };
    NSString* cellIdentifier = [[VeeContactPickerAppearanceConstants sharedInstance] veeContactCellIdentifier];
    _veeSectionedArrayDataSource = [[VeeSectionedArrayDataSource alloc] initWithItems:_veeContacts cellIdentifier:cellIdentifier allowedSortedSectionIdentifiers:_veeContactPickerOptions.sectionIdentifiers sectionIdentifierWildcard:_veeContactPickerOptions.sectionIdentifierWildcard configurationCellBlock:veeContactConfigureCellBlock];

    _contactsTableView.dataSource = _veeSectionedArrayDataSource;
    _contactsTableView.delegate = self;
    [_contactsTableView reloadData];
    [self setupSearchDisplayController];
}

- (void)setupSearchDisplayController
{
    _veeTableViewSearchDelegate = [[VeeTableViewSearchDelegate alloc] initWithSearchDisplayController:self.searchDisplayController dataToFiler:_veeContacts withPredicate:[self predicateToFilterVeeContactProt] andSearchResultsDelegate:self];

    [self.searchDisplayController setDelegate:_veeTableViewSearchDelegate];
    [self setupSearchTableView];
}

- (NSPredicate*)predicateToFilterVeeContactProt
{
    if ([_veeContacts count] > 0 == NO) {
        return nil;
    }
    NSPredicate* searchPredicate = [[[_veeContacts firstObject] class] searchPredicateForSearchString];
    return searchPredicate;
}

- (void)setupSearchTableView
{
    self.searchDisplayController.searchResultsTableView.dataSource = _veeSectionedArrayDataSource;
    self.searchDisplayController.searchResultsTableView.delegate = self;
}

- (void)registerCellsForReuse
{
    NSString* cellIdentifier = [[VeeContactPickerAppearanceConstants sharedInstance] veeContactCellIdentifier];
    [_contactsTableView registerClass:[VeeContactUITableViewCell class] forCellReuseIdentifier:cellIdentifier];
    [self.searchDisplayController.searchResultsTableView registerClass:[VeeContactUITableViewCell class] forCellReuseIdentifier:cellIdentifier];
}

#pragma mark - VeeABDelegate

- (void)abPermissionsGranted
{
    [self performSelectorOnMainThread:@selector(loadVeeContactsFromAddressBook) withObject:nil waitUntilDone:YES];
}

-(void)abPermissionsNotGranted
{
    NSLog(@"Warning - address book permissions not granted");
    [self showEmptyView];
    [_contactPickerDelegate didFailToAccessAddressBook];
}

#pragma mark - UI

- (void)showEmptyView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        _emptyViewLabel.hidden = NO;
        _contactsTableView.hidden = YES;
        _searchBar.hidden = YES;
    });
}

-(void)hideEmptyView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        _emptyViewLabel.hidden = YES;
        _contactsTableView.hidden = NO;
        _searchBar.hidden = NO;
        
    });
}

#pragma mark - TableView delegate

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return [[VeeContactPickerAppearanceConstants sharedInstance] veeContactCellHeight];
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    id<VeeContactProt> veeContact = [_veeSectionedArrayDataSource tableView:tableView itemAtIndexPath:indexPath];
    if (_contactPickerDelegate) {
        [_contactPickerDelegate didSelectContact:veeContact];
    }
    if (_contactSelectionHandler) {
        _contactSelectionHandler(veeContact);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - VeeSearchResultDelegate

- (void)handleSearchResults:(NSArray*)searchResults forSearchTableView:(UITableView*)searchTableView
{
    [_veeSectionedArrayDataSource setSearchResults:searchResults forSearchTableView:searchTableView];
}

#pragma mark - IBActions

- (IBAction)cancelBarButtonItemPressed:(id)sender
{
    [_contactPickerDelegate didCancelContactSelection];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
