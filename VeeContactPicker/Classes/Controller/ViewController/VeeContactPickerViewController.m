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

NS_ASSUME_NONNULL_BEGIN

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

    NSBundle *podBundle = [NSBundle bundleForClass:VeeContactPickerViewController.class];
    self = [[VeeContactPickerViewController alloc] initWithNibName:NSStringFromClass(self.class) bundle:podBundle];
    _veeContactPickerOptions = veeContactPickerOptions;
    _veeContacts = veeContacts;
    _veeAddressBook = [[VeeAddressBook alloc] init];
    _veeAddressBook.delegate = self;
    _veeContactCellConfiguration = [[VeeContactCellConfiguration alloc] initWithVeePickerOptions:_veeContactPickerOptions];
    return self;
}

#pragma mark - ViewController lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self loadStrings];
    [self loadPickerAppearance];
    self.addressBookRef = ABAddressBookCreate();
    [self loadVeeContacts];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - DidLoad Utils

- (void)loadStrings
{
    self.titleNavigationItem.title = (_veeContactPickerOptions.veeContactPickerStrings).navigationBarTitle;
    self.cancelBarButtonItem.title = (_veeContactPickerOptions.veeContactPickerStrings).cancelButtonTitle;
}

- (void)loadPickerAppearance
{
    self.cancelBarButtonItem.tintColor = [VeeContactPickerAppearanceConstants sharedInstance].cancelBarButtonItemTintColor;
    self.navigationBar.tintColor = [VeeContactPickerAppearanceConstants sharedInstance].navigationBarTintColor;
    self.navigationBar.barTintColor = [VeeContactPickerAppearanceConstants sharedInstance].navigationBarBarTintColor;
    self.navigationBar.translucent = [VeeContactPickerAppearanceConstants sharedInstance].navigationBarTranslucent;
    self.statusBarCoverView.backgroundColor = [VeeContactPickerAppearanceConstants sharedInstance].navigationBarBarTintColor;
    self.tableViewBottomMarginConstraint.constant = [VeeContactPickerAppearanceConstants sharedInstance].veeContactPickerTableViewBottomMargin;
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
    self.veeContacts = [[veeContactFactoryProt class] veeContactProtsFromAddressBook:_addressBookRef];
    self.veeContacts = [_veeContacts sortedArrayUsingSelector:@selector(compare:)];
    [self setupTableView];
}

- (void)setupTableView
{
    [self registerCellsForReuse];
    ConfigureCellBlock veeContactConfigureCellBlock = ^(VeeContactUITableViewCell* cell, id<VeeContactProt> veeContact) {
        [_veeContactCellConfiguration configureCell:cell forVeeContact:veeContact];
    };
    NSString* cellIdentifier = [VeeContactPickerAppearanceConstants sharedInstance].veeContactCellIdentifier;
    self.veeSectionedArrayDataSource = [[VeeSectionedArrayDataSource alloc] initWithItems:_veeContacts cellIdentifier:cellIdentifier allowedSortedSectionIdentifiers:_veeContactPickerOptions.sectionIdentifiers sectionIdentifierWildcard:_veeContactPickerOptions.sectionIdentifierWildcard configurationCellBlock:veeContactConfigureCellBlock];

    self.contactsTableView.dataSource = _veeSectionedArrayDataSource;
    self.contactsTableView.delegate = self;
    [self.contactsTableView reloadData];
    [self setupSearchDisplayController];
}

- (void)setupSearchDisplayController
{
    self.veeTableViewSearchDelegate = [[VeeTableViewSearchDelegate alloc] initWithSearchDisplayController:self.searchDisplayController dataToFiler:_veeContacts withPredicate:[self predicateToFilterVeeContactProt] andSearchResultsDelegate:self];

    (self.searchDisplayController).delegate = _veeTableViewSearchDelegate;
    [self setupSearchTableView];
}

- (NSPredicate*)predicateToFilterVeeContactProt
{
    if (_veeContacts.count > 0 == NO) {
        return nil;
    }
    NSPredicate* searchPredicate = [[_veeContacts.firstObject class] searchPredicateForSearchString];
    return searchPredicate;
}

- (void)setupSearchTableView
{
    self.searchDisplayController.searchResultsTableView.dataSource = _veeSectionedArrayDataSource;
    self.searchDisplayController.searchResultsTableView.delegate = self;
}

- (void)registerCellsForReuse
{
    NSString* cellIdentifier = [VeeContactPickerAppearanceConstants sharedInstance].veeContactCellIdentifier;
    [self.contactsTableView registerClass:[VeeContactUITableViewCell class] forCellReuseIdentifier:cellIdentifier];
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
    [self.contactPickerDelegate didFailToAccessAddressBook];
}

#pragma mark - UI

- (void)showEmptyView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.emptyViewLabel.hidden = NO;
        self.contactsTableView.hidden = YES;
        self.searchBar.hidden = YES;
    });
}

-(void)hideEmptyView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.emptyViewLabel.hidden = YES;
        self.contactsTableView.hidden = NO;
        self.searchBar.hidden = NO;
    });
}

#pragma mark - TableView delegate

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return [VeeContactPickerAppearanceConstants sharedInstance].veeContactCellHeight;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    id<VeeContactProt> veeContact = [_veeSectionedArrayDataSource tableView:tableView itemAtIndexPath:indexPath];
    if (self.contactPickerDelegate) {
        [self.contactPickerDelegate didSelectContact:veeContact];
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
    [self.contactPickerDelegate didCancelContactSelection];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

NS_ASSUME_NONNULL_END
