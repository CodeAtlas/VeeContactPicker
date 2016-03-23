//
//  Created by Andrea Cipriani on 14/12/15.
//  Copyright © 2015 Code Atlas SRL. All rights reserved.
//

#import "VeeContactPickerViewController.h"

#import "VeeContactPickerConstants.h"
#import "VeeContactPickerOptions.h"
#import "VeeContactPickerStrings.h"
#import "VeeContactColors.h"

#import "VeeContact.h"

#import "UIImageView+Letters.h"
#import "UILabel+Boldify.h"
#import "VeeIsEmpty.h"

#import "VeeAddressBook.h"

#import "VeeSectionedArrayDataSource.h"
#import "VeeContactUITableViewCell.h"
#import "VeeContactFactory.h"


@interface VeeContactPickerViewController ()

@property (nonatomic, strong) VeeContactPickerOptions* veeContactPickerOptions;
@property (nonatomic, strong) VeeAddressBook* veeAddressBook;
@property (nonatomic,strong) NSArray<id<VeeContactProt>>* veeContacts;
@property (nonatomic,strong) VeeSectionedArrayDataSource* veeSectionedArrayDataSource;

@property (nonatomic) ABAddressBookRef addressBookRef;

@property (nonatomic, strong) NSDictionary<NSString*,NSArray<VeeContact*>*>* veecontactsSectioned;
@property (nonatomic, strong) NSDictionary<NSString*,NSArray<VeeContact*>*>* veecontactsSearchResultsSectioned;
@property (nonatomic, strong) NSArray<NSString*>* veecontactsNonEmptySortedSectionIdentifiers;
@property (nonatomic, strong) NSArray<NSString*>* veecontactsNonEmptySortedSectionIdentifiersSearchResults;

@end

@implementation VeeContactPickerViewController

#pragma mark - Initializers

-(instancetype)initWithDefaultConfiguration
{
    self = [[VeeContactPickerViewController alloc] initWithNibName:NSStringFromClass([self class]) bundle:nil];
    if (self) {
        _veeContactPickerOptions = [VeeContactPickerOptions defaultOptions];
        _veeAddressBook = [[VeeAddressBook alloc] initWithVeeABDelegate:self];
    }
    return self;
}

- (instancetype)initWithOptions:(VeeContactPickerOptions *)veeContactPickerOptions{
    self = [self initWithDefaultConfiguration];
    if (self) {
        if (veeContactPickerOptions){
            _veeContactPickerOptions = veeContactPickerOptions;
        }
    }
    return self;
}

- (instancetype)initWithVeeContacts:(NSArray<id<VeeContactProt>>*)veeContacts
{
    self = [self initWithDefaultConfiguration];
    if (self) {
        if (veeContacts){
            _veeContacts = veeContacts;
        }
    }
    return self;
}

- (instancetype)initWithOptions:(VeeContactPickerOptions*)veeContactPickerOptions andVeeContacts:(NSArray<id<VeeContactProt>>*)veeContacts
{
    self = [self initWithOptions:veeContactPickerOptions];
    if (self) {
        if (veeContacts){
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
    _addressBookRef = ABAddressBookCreate();
    [self loadVeeContacts];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - DidLoad Utils

-(void)loadStrings
{
    _titleNavigationItem.title = [_veeContactPickerOptions.veeContactPickerStrings navigationBarTitle];
    _cancelBarButtonItem.title = [_veeContactPickerOptions.veeContactPickerStrings cancelButtonTitle];
}

-(void)loadVeeContacts
{
    BOOL shouldLoadVeecontactsFromAB = _veeContacts == nil;
    if (shouldLoadVeecontactsFromAB){
        BOOL hasAlreadyABPermission = [VeeAddressBook hasABPermissions];
        if (hasAlreadyABPermission){
            [self loadVeeContactsFromAddressBook];
        }
        else{
            [self askABPermissionsWithDelegateCallback];
        }
    }
    else{
        [self loadCustomVeecontacts];
    }
}

-(void)askABPermissionsWithDelegateCallback
{
    [_veeAddressBook askABPermissionsWithDelegateCallback:_addressBookRef];
}

-(void)loadCustomVeecontacts
{
    if (!_veeContacts){
        [self showEmptyView];
    }
    else{
        _veeContacts = [_veeContacts sortedArrayUsingSelector:@selector(compare:)];
        [self setupTableView];
    }
}

-(void)loadVeeContactsFromAddressBook
{
    _veeContacts = [VeeContactFactory veeContactsFromAddressBook:_addressBookRef];
    _veeContacts = [_veeContacts sortedArrayUsingSelector:@selector(compare:)];
    [self setupTableView];
}

- (void)setupTableView
{
    [self registerNibsForCellReuse];
    
    ConfigureCellBlock veeContactConfigureCellBlock = ^(VeeContactUITableViewCell *cell, VeeContact *veeContact) {
        [self coinfigureCell:cell forVeeContact:veeContact];
    };
    
    _veeSectionedArrayDataSource = [[VeeSectionedArrayDataSource alloc] initWithItems:_veeContacts cellIdentifier:kVeeContactCellIdentifier allowedSortedSectionIdentifiers:_veeContactPickerOptions.sectionIdentifiers sectionIdentifierWildcard:_veeContactPickerOptions.sectionIdentifierWildcard configurationCellBlock:veeContactConfigureCellBlock];

    _contactsTableView.dataSource = _veeSectionedArrayDataSource;
    _contactsTableView.delegate = self;
    [_contactsTableView reloadData];
    
    [self setupSearchTableView];
}

-(void)setupSearchTableView
{
    self.searchDisplayController.searchResultsTableView.dataSource = _veeSectionedArrayDataSource;
    self.searchDisplayController.searchResultsTableView.delegate = self;
}

-(void)registerNibsForCellReuse
{
    [_contactsTableView registerNib:[UINib nibWithNibName:kVeeContactCellNibName bundle:nil] forCellReuseIdentifier:kVeeContactCellIdentifier];
    [self.searchDisplayController.searchResultsTableView registerNib:[UINib nibWithNibName:kVeeContactCellNibName bundle:nil] forCellReuseIdentifier:kVeeContactCellIdentifier];
}

#pragma mark - VeeABDelegate

-(void)abPermissionsGranted:(BOOL)granted
{
    if (granted){
        [self performSelectorOnMainThread:@selector(loadVeeContactsFromAddressBook) withObject:nil waitUntilDone:YES];
    }
    else{
        NSLog(@"Warning - address book permissions not granted");
        [self showEmptyView];
    }
}

#pragma mark - UI

-(void)showEmptyView
{
    //TODO:
}

#pragma mark - TableView cell configuration

-(void)coinfigureCell:(VeeContactUITableViewCell*)veeContactUITableViewCell forVeeContact:(id<VeeContactProt>)veeContact
{
    [self configureCellInitialValues:veeContactUITableViewCell];
    [self configureCellLabels:veeContactUITableViewCell forVeeContact:veeContact];
    [self configureCellImage:veeContactUITableViewCell forVeeContact:veeContact];
}

-(void)configureCellInitialValues:(VeeContactUITableViewCell*)veeContactUITableViewCell
{
    veeContactUITableViewCell.primaryLabelCenterYAlignmentConstraint.constant = 0;
    veeContactUITableViewCell.secondaryLabel.hidden = YES;
    veeContactUITableViewCell.primaryLabel.text = @"";
    veeContactUITableViewCell.secondaryLabel.text = @"";
    veeContactUITableViewCell.contactImageView.image = nil;
}

-(void)configureCellLabels:(VeeContactUITableViewCell*)veeContactUITableViewCell forVeeContact:(id<VeeContactProt>)veeContact
{
    veeContactUITableViewCell.primaryLabel.text = [veeContact displayName];
    NSArray* nameComponentes = [[veeContact displayName] componentsSeparatedByString:@" "];
    if ([nameComponentes count] > 0){
        [veeContactUITableViewCell.primaryLabel boldSubstring:[nameComponentes firstObject]];
    }
    else{
        [veeContactUITableViewCell.primaryLabel boldSubstring:[veeContact displayName]];
    }
}

-(void)configureCellImage:(VeeContactUITableViewCell*)veeContactUITableViewCell forVeeContact:(id<VeeContactProt>)veeContact
{
    if ([veeContact thumbnailImage]) {
        veeContactUITableViewCell.contactImageView.image = [veeContact thumbnailImage];
    }
    else {
        if (_veeContactPickerOptions.showLettersWhenContactImageIsMissing){
            [veeContactUITableViewCell.contactImageView setImageWithString:[veeContact displayName] color:[_veeContactPickerOptions.veeContactColors colorForVeeContact:veeContact]];
        }
        else{
            [veeContactUITableViewCell.contactImageView setImage:_veeContactPickerOptions.contactThumbnailImagePlaceholder];
        }
    }
}

#pragma mark - TableView delegate

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return kVeeContactCellHeight;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    id<VeeContactProt> veeContact = [_veeSectionedArrayDataSource tableView:tableView itemAtIndexPath:indexPath];
    
    if (_contactPickerDelegate) {
        [_contactPickerDelegate didSelectABContact:veeContact];
    }
    if (_completionHandler) {
        _completionHandler(veeContact);
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - IBActions

- (IBAction)cancelBarButtonItemPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Search

- (BOOL)searchDisplayController:(UISearchDisplayController*)controller shouldReloadTableForSearchString:(NSString*)searchString
{
    [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    return YES;
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
    [_veeSectionedArrayDataSource setSearchResults:nil forSearchTableView:self.searchDisplayController.searchResultsTableView];
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    [_veeSectionedArrayDataSource setSearchResults:[self searchResultsForText:searchText] forSearchTableView:self.searchDisplayController.searchResultsTableView];
}

-(NSArray<id<VeeContactProt>>*)searchResultsForText:(NSString*)searchText
{
    NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"displayName contains[c] %@ || ANY emails contains[c] %@ || ANY phoneNumbers contains[c] %@", searchText, searchText, searchText];
    ;
    NSArray<id<VeeContactProt>>* veeContactsSearchResult = [_veeContacts filteredArrayUsingPredicate:searchPredicate];
    return veeContactsSearchResult;
}

@end
