//
//  VeeContactPicker.m
//  VeeContactPicker
//
//  Created by Andrea Cipriani on 14/12/15.
//  Copyright © 2015 Code Atlas SRL. All rights reserved.
//

#import "VeeContact.h"
#import "UIImageView+Letters.h"
#import "VeeContactPickerViewController.h"
#import "VeeContactUITableViewCell.h"
#import "UILabel+Boldify.h"
#import "VeeContactPickerConstants.h"
#import "VeeContactPickerOptions.h"
#import "NSObject+VeeIsEmpty.h"
#import "VeeContactPickerStrings.h"
#import "VeeAddressBook.h"
#import "VeeAddressBookRepository.h"
#import "VeeContactColors.h"

@interface VeeContactPickerViewController ()

@property (nonatomic, strong) VeeContactPickerOptions* veeContactPickerOptions;
@property (nonatomic, strong) VeeContactColors* veeContactColors;
@property (nonatomic, strong) VeeContactPickerStrings* veeContactPickerStrings;

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
        _veeContactColors = [[VeeContactColors alloc] initWithVeeContactsDefaultColorPalette];
        _veeContactPickerStrings = [[VeeContactPickerStrings alloc] initWithDefaultStrings];

    }
    return self;
}

- (instancetype)initWithOptions:(VeeContactPickerOptions *)veeContactPickerOptions
{
    self = [self initWithDefaultConfiguration];
    if (self){
        _veeContactPickerOptions = veeContactPickerOptions;
    }
    return self;
}

- (instancetype)initWithOptions:(VeeContactPickerOptions *)veeContactPickerOptions andColors:(VeeContactColors*)veeContactColors
{
    self = [self initWithOptions:veeContactPickerOptions];
    if (self) {
        _veeContactColors = veeContactColors;
    }
    return self;
}

- (instancetype)initWithOptions:(VeeContactPickerOptions *)veeContactPickerOptions andColors:(VeeContactColors*)veeContactColors andStrings:(VeeContactPickerStrings*)veeContactPickerStrings
{
    self = [self initWithOptions:veeContactPickerOptions andColors:veeContactColors];
    if (self) {
        _veeContactPickerStrings = veeContactPickerStrings;
    }
    return self;
}

#pragma mark - ViewController lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self loadStrings];
    [self registerNibsForCellReuse];
    [self askABPermissionsIfNeeded];
    [self loadDataSource];
    [self sortVeecontactsForAB];
    [_contactsTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - DidLoad Utils

-(void)loadStrings
{
    _titleNavigationItem.title = [_veeContactPickerStrings navigationBarTitle];
    _cancelBarButtonItem.title = [_veeContactPickerStrings cancelButtonTitle];
}

-(void)registerNibsForCellReuse
{
    [_contactsTableView registerNib:[UINib nibWithNibName:kVeeContactCellNibName bundle:nil] forCellReuseIdentifier:kVeeContactCellIdentifier];
}

-(void)askABPermissionsIfNeeded
{
    _addressBookRef = ABAddressBookCreate();
    [VeeAddressBook askABPermissionsIfNeeded:_addressBookRef];
}

-(void)loadDataSource
{
    BOOL shouldLoadVeecontactsFromAB = _veeContacts == nil;
    if (shouldLoadVeecontactsFromAB){
        _veeContacts = (NSArray<VeeContactProt>*)[[VeeAddressBookRepository sharedInstance] veeContactsForAddressBook:_addressBookRef];
    }
    _veecontactsSectioned = [self veeContactsSectioned:_veeContacts];
    _veecontactsNonEmptySortedSectionIdentifiers = [self veeContactsNonEmptySortedSectionIdentifiers:_veecontactsSectioned];
}

#pragma mark - Data source

- (NSDictionary<NSString*,NSArray<VeeContact*>*>*)veeContactsSectioned:(NSArray<VeeContact*>*)veeContacts
{
    NSMutableDictionary<NSString*,NSArray<VeeContact*>*>* veeContactsSectionedMutable = [NSMutableDictionary new];
    for (id<VeeContactProt> veeContact in veeContacts) {
        NSString* veeContactSectionIdentifier = [self sectionIdentifierForVeeContact:veeContact];
        NSArray* veeContactsForSectionIdentifier = [veeContactsSectionedMutable objectForKey:veeContactSectionIdentifier];
        if (veeContactsForSectionIdentifier == nil) {
            [veeContactsSectionedMutable setObject:[NSArray arrayWithObject:veeContact] forKey:veeContactSectionIdentifier];
        }
        else {
            [veeContactsSectionedMutable setObject:[veeContactsForSectionIdentifier arrayByAddingObject:veeContact] forKey:veeContactSectionIdentifier];
        }
    }
    return [NSDictionary dictionaryWithDictionary:veeContactsSectionedMutable];
}

-(NSString*)sectionIdentifierForVeeContact:(VeeContact*)veecontact
{
    NSString* sectionIdentifierForVeecontact;
    
    if ([veecontact.firstName veeIsEmpty] == NO) {
        sectionIdentifierForVeecontact = [[veecontact.firstName substringToIndex:1] uppercaseString];
    }
    else if ([veecontact.lastName veeIsEmpty] == NO) {
        sectionIdentifierForVeecontact = [[veecontact.lastName substringToIndex:1] uppercaseString];
    }
    else if ([veecontact.displayName veeIsEmpty] == NO) {
        sectionIdentifierForVeecontact = [[veecontact.displayName substringToIndex:1] uppercaseString];
    }
    else {
        sectionIdentifierForVeecontact = [_veeContactPickerOptions sectionIdentifierWildcard];
    }
    if ([[_veeContactPickerOptions sectionIdentifiers] containsObject:sectionIdentifierForVeecontact] == NO) {
        sectionIdentifierForVeecontact = [_veeContactPickerOptions sectionIdentifierWildcard];
    }
    return sectionIdentifierForVeecontact;
}

-(NSArray<NSString*>*)veeContactsNonEmptySortedSectionIdentifiers:(NSDictionary<NSString*,NSArray<VeeContact*>*>*)veecontactsSectioned
{
    return [self sortedSectionIdentifiers:[veecontactsSectioned allKeys]];
}

-(NSArray<NSString*>*)sortedSectionIdentifiers:(NSArray*)sectionIdentifiers
{
    return [sectionIdentifiers sortedArrayUsingComparator:^NSComparisonResult(NSString* firstKey, NSString* secondKey) {
        if ([firstKey isEqualToString:[_veeContactPickerOptions sectionIdentifierWildcard]]) {
            return NSOrderedDescending;
        }
        else if ([secondKey isEqualToString:[_veeContactPickerOptions sectionIdentifierWildcard]]) {
            return NSOrderedAscending;
        }
        else {
            return [firstKey caseInsensitiveCompare:secondKey];
        }
    }];
}

#pragma mark - VeeContacts sorting

-(void)sortVeecontactsForAB
{
    NSString* firstSortProperty = @"firstName";
    NSString* secondSortProperty = @"lastName";
    
    _veeContacts = (NSArray<VeeContactProt>*)[_veeContacts sortedArrayUsingComparator:^NSComparisonResult(id<VeeContactProt> firstContact, id<VeeContactProt> secondContact) {
        
        NSString* firstContactSortProperty = [self sortPropertyOfVeeContact:firstContact withFirstOption:firstSortProperty andSecondOption:secondSortProperty];
        NSString* secondContactSortProperty = [self sortPropertyOfVeeContact:secondContact withFirstOption:firstSortProperty andSecondOption:secondSortProperty];
        NSComparisonResult result = [firstContactSortProperty compare:secondContactSortProperty options:NSDiacriticInsensitiveSearch | NSCaseInsensitiveSearch];
        if (result == NSOrderedSame) {
            return [firstContact.displayName compare:secondContact.displayName options:NSDiacriticInsensitiveSearch | NSCaseInsensitiveSearch];
        }
        else {
            return result;
        }
    }];
}

-(NSString*)sortPropertyOfVeeContact:(id)veeContact withFirstOption:(NSString*)firstProperty andSecondOption:(NSString*)secondProperty
{
    if ([veeContact respondsToSelector:NSSelectorFromString(firstProperty)] == NO || [veeContact respondsToSelector:NSSelectorFromString(secondProperty)] == NO){
        NSLog(@"VeeContact doesn't respond to one of this selectors %@ %@",firstProperty,secondProperty);
        return [veeContact displayName];
    }
    
    if ([[veeContact valueForKey:firstProperty] veeIsEmpty]){
        if ([[veeContact valueForKey:secondProperty] veeIsEmpty]){
            return [veeContact displayName];
        }
        return [veeContact valueForKey:secondProperty];
    }
    return [veeContact valueForKey:firstProperty];
}

#pragma mark - TableView data source

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [[_veecontactsSearchResultsSectioned allKeys] count];
    }
    return [[_veecontactsSectioned allKeys] count];
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    BOOL isSearchTableView = tableView == self.searchDisplayController.searchResultsTableView;
    return [[self veeContactsForSection:section inSearchTableView:isSearchTableView] count];
}

- (NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section
{
    BOOL isSearchTableView = tableView == self.searchDisplayController.searchResultsTableView;
    return [self sectionIdentifierFromSection:section inSearchTableView:isSearchTableView];
}

- (NSArray<NSString*>*)sectionIndexTitlesForTableView:(UITableView*)tableView
{
    return [_veeContactPickerOptions sectionIdentifiers];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    VeeContactUITableViewCell* veeContactUITableViewCell = [tableView dequeueReusableCellWithIdentifier:kVeeContactCellIdentifier];
    if (!veeContactUITableViewCell) {
        veeContactUITableViewCell = [[[NSBundle mainBundle] loadNibNamed:kVeeContactCellNibName owner:self options:nil] objectAtIndex:0];
    }

    BOOL isSearchTableView = tableView == self.searchDisplayController.searchResultsTableView;
    id<VeeContactProt> veeContact = [self veeContactForIndexPath:indexPath inSearchTableView:isSearchTableView];
    [self customizeTableViewCell:veeContactUITableViewCell forVeeContact:veeContact];
    return veeContactUITableViewCell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    BOOL isSearchTableView = tableView == self.searchDisplayController.searchResultsTableView;
    id<VeeContactProt> veeContact = [self veeContactForIndexPath:indexPath inSearchTableView:isSearchTableView];
    
    if (_contactPickerDelegate) {
        [_contactPickerDelegate didSelectABContact:veeContact];
    }
    if (_completionHandler) {
        _completionHandler(veeContact);
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - TableView data source utils

-(NSArray<VeeContact*>*)veeContactsForSection:(NSInteger)section inSearchTableView:(BOOL)isSearchTableView
{
    if (isSearchTableView){
        return [_veecontactsSearchResultsSectioned objectForKey:[self sectionIdentifierFromSection:section inSearchTableView:isSearchTableView]];
    }
    else{
        return [_veecontactsSectioned objectForKey:[self sectionIdentifierFromSection:section inSearchTableView:isSearchTableView]];
    }
}

-(NSString*)sectionIdentifierFromSection:(NSInteger)section inSearchTableView:(BOOL)isSearchTableView
{
    if (isSearchTableView){
        return [_veecontactsNonEmptySortedSectionIdentifiersSearchResults objectAtIndex:section];
    }
    return [_veecontactsNonEmptySortedSectionIdentifiers objectAtIndex:section];
}

-(id<VeeContactProt>)veeContactForIndexPath:(NSIndexPath*)indexPath inSearchTableView:(BOOL)isSearchTableView
{
    id<VeeContactProt> veeContact;
    NSString* sectionIdentifier = [self sectionIdentifierFromSection:indexPath.section inSearchTableView:isSearchTableView];
    if (isSearchTableView) {
        veeContact = [[_veecontactsSearchResultsSectioned objectForKey:sectionIdentifier] objectAtIndex:indexPath.row];
    }
    else {
        veeContact = [[_veecontactsSectioned objectForKey:sectionIdentifier] objectAtIndex:indexPath.row];
    }
    return veeContact;
}

-(void)customizeTableViewCell:(VeeContactUITableViewCell*)veeContactUITableViewCell forVeeContact:(id<VeeContactProt>)veeContact
{
    [self loadTableViewCellInitialValues:veeContactUITableViewCell];
    [self loadTableViewCellLabels:veeContactUITableViewCell forVeeContact:veeContact];
    [self loadTableViewCellImage:veeContactUITableViewCell forVeeContact:veeContact];
}

-(void)loadTableViewCellInitialValues:(VeeContactUITableViewCell*)veeContactUITableViewCell
{
    veeContactUITableViewCell.primaryLabelCenterYAlignmentConstraint.constant = 0;
    veeContactUITableViewCell.secondaryLabel.hidden = YES;
    veeContactUITableViewCell.primaryLabel.text = @"";
    veeContactUITableViewCell.secondaryLabel.text = @"";
    veeContactUITableViewCell.contactImageView.image = nil;
}

-(void)loadTableViewCellLabels:(VeeContactUITableViewCell*)veeContactUITableViewCell forVeeContact:(id<VeeContactProt>)veeContact
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

-(void)loadTableViewCellImage:(VeeContactUITableViewCell*)veeContactUITableViewCell forVeeContact:(id<VeeContactProt>)veeContact
{
    if ([veeContact thumbnailImage]) {
        veeContactUITableViewCell.contactImageView.image = [veeContact thumbnailImage];
    }
    else {
        if (_veeContactPickerOptions.showLettersWhenContactImageIsMissing){
            [veeContactUITableViewCell.contactImageView setImageWithString:[veeContact displayName] color:[_veeContactColors colorForVeeContact:veeContact]];
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

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    _veecontactsSearchResultsSectioned = [self veeContactsSectioned:[self searchResultsForText:searchText]];
}

-(NSArray<VeeContact*>*)searchResultsForText:(NSString*)searchText
{
    NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"displayName contains[c] %@ || ANY emails contains[c] %@ || ANY phoneNumbers contains[c] %@", searchText, searchText, searchText];
    ;
    NSArray<VeeContact*>* veeContactsSearchResult = [_veeContacts filteredArrayUsingPredicate:searchPredicate];
    return veeContactsSearchResult;
}

@end
