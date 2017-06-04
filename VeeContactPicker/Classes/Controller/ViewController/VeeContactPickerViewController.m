#import "VeeContactPickerViewController.h"

#import "VeeContactPickerAppearanceConstants.h"
#import "VeeContactPickerOptions.h"
#import "VeeContactPickerStrings.h"

#import "VeeAddressBook.h"
#import "VeeCommons.h"

#import "VeeContactProtFactoryProducer.h"

#import "VeeContactCellConfiguration.h"
#import "VeeContactProtFactoryProducer.h"
#import "VeeContactTableViewCell.h"
#import "VeeSectionedArrayDataSource.h"
#import "NSBundle+VeeContactPicker.h"

NS_ASSUME_NONNULL_BEGIN

@interface VeeContactPickerViewController () <UISearchResultsUpdating, UISearchBarDelegate>

#pragma mark - Outlets

@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UIView *statusBarCoverView;
@property (nonatomic, strong) UISearchController *searchController;

#pragma mark - Constraints

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewBottomMarginConstraint;

#pragma mark - Dependencies

@property (nonatomic, strong) VeeContactPickerOptions *veeContactPickerOptions;
@property (nonatomic) ABAddressBookRef addressBookRef;
@property (nonatomic, strong) VeeAddressBook *veeAddressBook;

#pragma mark - Model

@property (nonatomic, strong) NSArray<id<VeeContactProt>>  *veeContacts;
@property (nonatomic, strong) VeeSectionedArrayDataSource *veeSectionedArrayDataSource;
@property (nonatomic, strong) NSMutableArray<id<VeeContactProt>> *selectedVeeContacts;

#pragma mark - Style

@property (nonatomic, strong) VeeContactCellConfiguration *veeContactCellConfiguration;

@end

@implementation VeeContactPickerViewController

#pragma mark - Initializers

- (instancetype)initWithDefaultConfiguration
{
    self = [self initWithOptions:[VeeContactPickerOptions defaultOptions]];
    return self;
}

- (instancetype)initWithOptions:(VeeContactPickerOptions*)veeContactPickerOptions {
    self = [super init];
    if (!self) {
        return nil;
    }

    self = [[VeeContactPickerViewController alloc] initWithNibName:NSStringFromClass(self.class) bundle:[NSBundle veeContactPickerBundle]];
    _veeContactPickerOptions = veeContactPickerOptions;
    _veeAddressBook = [[VeeAddressBook alloc] init];
    _veeAddressBook.delegate = self;
    _veeContactCellConfiguration = [[VeeContactCellConfiguration alloc] initWithVeePickerOptions:_veeContactPickerOptions];
    _multipleSelection = NO;
    return self;
}

- (instancetype)initWithVeeContacts:(NSArray<id<VeeContactProt>>*)veeContacts {
    self = [self initWithOptions:[VeeContactPickerOptions defaultOptions] veeContacts:veeContacts];
    return self;
}

- (instancetype)initWithOptions:(VeeContactPickerOptions*)veeContactPickerOptions veeContacts:(NSArray<id<VeeContactProt> >*)veeContacts
{
    self = [super init];
    if (!self) {
        return nil;
    }

    self = [[VeeContactPickerViewController alloc] initWithNibName:NSStringFromClass(self.class) bundle:[NSBundle veeContactPickerBundle]];
    _veeContactPickerOptions = veeContactPickerOptions;
    _veeContacts = veeContacts;
    _veeAddressBook = [[VeeAddressBook alloc] init];
    _veeAddressBook.delegate = self;
    _veeContactCellConfiguration = [[VeeContactCellConfiguration alloc] initWithVeePickerOptions:_veeContactPickerOptions];
    _multipleSelection = NO;
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
    if (self.multipleSelection) {
        self.titleNavigationItem.title = (_veeContactPickerOptions.veeContactPickerStrings).navigationBarTitleForMultipleContacts;
    } else {
        self.titleNavigationItem.title = (_veeContactPickerOptions.veeContactPickerStrings).navigationBarTitle;
    }
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
    BOOL shouldLoadVeecontactsFromAB = self.veeContacts == nil;
    if (shouldLoadVeecontactsFromAB) {
        BOOL hasAlreadyABPermission = [VeeAddressBook hasABPermissions];
        if (hasAlreadyABPermission == YES) {
            [self loadVeeContactsFromAddressBook];
        }
        else {
            [self.veeAddressBook askABPermissionsWithDelegate:_addressBookRef];
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
        self.veeContacts = [_veeContacts sortedArrayUsingSelector:@selector(compare:)];
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
    [self setupSearchController];
    [self registerCellsForReuse];
    ConfigureCellBlock veeContactConfigureCellBlock = ^(VeeContactTableViewCell* cell, id<VeeContactProt> veeContact) {
        [self.veeContactCellConfiguration configureCell:cell forVeeContact:veeContact];
    };
    NSString* cellIdentifier = [VeeContactPickerAppearanceConstants sharedInstance].veeContactCellIdentifier;
    self.veeSectionedArrayDataSource = [[VeeSectionedArrayDataSource alloc] initWithItems:self.veeContacts
                                                                           cellIdentifier:cellIdentifier
                                                          allowedSortedSectionIdentifiers:self.veeContactPickerOptions.sectionIdentifiers
                                                                sectionIdentifierWildcard:self.veeContactPickerOptions.sectionIdentifierWildcard
                                                                         searchController:self.searchController
                                                                   configurationCellBlock:veeContactConfigureCellBlock];
    self.contactsTableView.allowsMultipleSelection = self.multipleSelection;
    self.contactsTableView.dataSource = _veeSectionedArrayDataSource;
    self.contactsTableView.delegate = self;
    [self.contactsTableView reloadData];
}

- (void)setupSearchController
{
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.definesPresentationContext = NO;
    self.searchController.searchBar.delegate = self;
    self.searchController.searchResultsUpdater = self;
    [self.searchController.searchBar sizeToFit];
    self.contactsTableView.tableHeaderView = self.searchController.searchBar;
}

- (void)registerCellsForReuse
{
    NSString *cellIdentifier = [VeeContactPickerAppearanceConstants sharedInstance].veeContactCellIdentifier;
    UINib *cellNib = [UINib nibWithNibName:cellIdentifier bundle:[NSBundle veeContactPickerBundle]];
    [self.contactsTableView registerNib:cellNib forCellReuseIdentifier:cellIdentifier];
}

#pragma mark - VeeABDelegate

- (void)abPermissionsGranted
{
    [self performSelectorOnMainThread:@selector(loadVeeContactsFromAddressBook) withObject:nil waitUntilDone:YES];
}

-(void)abPermissionsNotGranted
{
    [self showEmptyView];
    [self.contactPickerDelegate didFailToAccessAddressBook];
}

#pragma mark - UI

- (void)showEmptyView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.emptyViewLabel.hidden = NO;
        self.contactsTableView.hidden = YES;
    });
}

-(void)hideEmptyView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.emptyViewLabel.hidden = YES;
        self.contactsTableView.hidden = NO;
    });
}

#pragma mark - TableView delegate

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return [VeeContactPickerAppearanceConstants sharedInstance].veeContactCellHeight;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    id<VeeContactProt> veeContact = [self.veeSectionedArrayDataSource tableView:tableView itemAtIndexPath:indexPath];
    if (self.multipleSelection == YES) {
        [self handleMultipleSelectionWith:veeContact];
    } else {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self handleSingleSelection:veeContact];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    id<VeeContactProt> veeContact = [self.veeSectionedArrayDataSource tableView:tableView itemAtIndexPath:indexPath];
    if (self.multipleSelection == YES) {
        [self handleMultipleSelectionWith:veeContact];
    }
}

- (void)handleSingleSelection:(id<VeeContactProt>)veeContact
{
    if (self.contactPickerDelegate) {
        [self.contactPickerDelegate didSelectContact:veeContact];
    }
    if (_contactSelectionHandler) {
        self.contactSelectionHandler(veeContact);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)handleMultipleSelectionWith:(id<VeeContactProt>)veeContact
{
    if (self.selectedVeeContacts == nil) {
        self.selectedVeeContacts = [[NSMutableArray alloc] init];
    }
    if ([self.selectedVeeContacts containsObject:veeContact]) {
        [self.selectedVeeContacts removeObject:veeContact];
    } else {
        [self.selectedVeeContacts addObject:veeContact];
    }
}

- (void)completeMultipleSelection
{
    if (self.contactPickerDelegate) {
        [self.contactPickerDelegate didSelectContacts:self.selectedVeeContacts];
    }
    if (self.searchController.isActive){
        [self dismissViewControllerAnimated:NO completion:nil];
    }
    [self dismissViewControllerAnimated:YES completion:^{
        [self.selectedVeeContacts removeAllObjects];
    }];
}

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *searchText = searchController.searchBar.text;
    [self.veeSectionedArrayDataSource updateForSearchText:searchText selectedVeeContacts:self.selectedVeeContacts];
    [self.contactsTableView reloadData];
}

#pragma mark - IBActions

- (IBAction)cancelBarButtonItemPressed:(id)sender
{
    [self.contactPickerDelegate didCancelContactSelection];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)multipleSelectionDoneButtonItemPressed:(id)sender {

    [self completeMultipleSelection];
}

@end

 NS_ASSUME_NONNULL_END
