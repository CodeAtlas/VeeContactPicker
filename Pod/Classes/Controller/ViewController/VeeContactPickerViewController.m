//
//  Created by Andrea Cipriani on 14/12/15.
//  Copyright © 2015 Code Atlas SRL. All rights reserved.
//

#import "VeeContactPickerViewController.h"

#import "VeeContactPickerConstants.h"
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
    [self loadBundleOfPod];
    NSAssert(_podBundle,@"Bundle can't be nil");
    
    self = [[VeeContactPickerViewController alloc] initWithNibName:NSStringFromClass([self class]) bundle:_podBundle];
    if (self) {
        _veeContactPickerOptions = [VeeContactPickerOptions defaultOptions];
        _veeAddressBook = [[VeeAddressBook alloc] initWithVeeABDelegate:self];
        _veeContactCellConfiguration = [[VeeContactCellConfiguration alloc] initWithVeePickerOptions:_veeContactPickerOptions];
    }
    return self;
}

-(void)loadBundleOfPod
{
    NSBundle* bundle = [NSBundle bundleForClass:self.class];
    NSURL* bundleURL = [bundle URLForResource:@"VeeContactPicker" withExtension:@"bundle"];
    _podBundle = [NSBundle bundleWithURL:bundleURL];
    if ([_podBundle isLoaded] == NO){
        [_podBundle load];
    }
    NSLog(@"Bundle loaded: %@",_podBundle);
    [self printContentsOfBundle];
}

- (void)printContentsOfBundle
{
    NSString *bundleRoot = [_podBundle bundlePath];
    NSArray *paths = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:bundleRoot error:nil];
    NSLog(@"%@",paths);
}

- (instancetype)initWithOptions:(VeeContactPickerOptions*)veeContactPickerOptions
{
    self = [self initWithDefaultConfiguration];
    if (self) {
        if (veeContactPickerOptions) {
            _veeContactPickerOptions = veeContactPickerOptions;
        }
    }
    return self;
}

- (instancetype)initWithVeeContacts:(NSArray<id<VeeContactProt> >*)veeContacts
{
    self = [self initWithDefaultConfiguration];
    if (self) {
        if (veeContacts) {
            _veeContacts = veeContacts;
        }
    }
    return self;
}

- (instancetype)initWithOptions:(VeeContactPickerOptions*)veeContactPickerOptions andVeeContacts:(NSArray<id<VeeContactProt> >*)veeContacts
{
    self = [self initWithOptions:veeContactPickerOptions];
    if (self) {
        if (veeContacts) {
            _veeContacts = veeContacts;
        }
    }
    return self;
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
    _cancelBarButtonItem.tintColor = [[VeeContactPickerConstants sharedInstance] cancelBarButtonItemTintColor];
    _navigationBar.tintColor = [[VeeContactPickerConstants sharedInstance] navigationBarTintColor];
    _navigationBar.barTintColor = [[VeeContactPickerConstants sharedInstance] navigationBarBarTintColor];
    _navigationBar.translucent = [[VeeContactPickerConstants sharedInstance] navigationBarTranslucent];
    _statusBarCoverView.backgroundColor = [[VeeContactPickerConstants sharedInstance] navigationBarBarTintColor];
    _tableViewBottomMarginConstraint.constant = [[VeeContactPickerConstants sharedInstance] veeContactPickerTableViewBottomMargin];
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
    if ([VeeCommons isEmpty:_veeContacts]) {
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
    [self registerNibsForCellReuse];
    ConfigureCellBlock veeContactConfigureCellBlock = ^(VeeContactUITableViewCell* cell, id<VeeContactProt> veeContact) {
        [_veeContactCellConfiguration configureCell:cell forVeeContact:veeContact];
    };
    NSString* cellIdentifier = [[VeeContactPickerConstants sharedInstance] veeContactCellIdentifier];
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

- (void)registerNibsForCellReuse
{
    NSString* cellIdentifier = [[VeeContactPickerConstants sharedInstance] veeContactCellIdentifier];
    NSString* cellNibName = [[VeeContactPickerConstants sharedInstance] veeContactCellNibName];
    UINib* cellNib = [UINib nibWithNibName:cellNibName bundle:_podBundle];
    NSAssert(cellNib, @"Couldn't find nib %@ in bundle %@",cellNib,_podBundle);
    [_contactsTableView registerNib:cellNib forCellReuseIdentifier:cellIdentifier];
    [self.searchDisplayController.searchResultsTableView registerNib:cellNib forCellReuseIdentifier:cellIdentifier];
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
    [_contactPickerDelegate didFailToAccessABContacts];
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
    return [[VeeContactPickerConstants sharedInstance] veeContactCellHeight];
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    id<VeeContactProt> veeContact = [_veeSectionedArrayDataSource tableView:tableView itemAtIndexPath:indexPath];
    if (_contactPickerDelegate) {
        [_contactPickerDelegate didSelectABContact:veeContact];
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
    [_contactPickerDelegate didCancelABContactSelection];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
