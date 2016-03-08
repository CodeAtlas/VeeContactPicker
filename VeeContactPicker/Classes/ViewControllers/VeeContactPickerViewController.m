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

#define kVeeContactCellNibName @"VeeContactUITableViewCell"
#define kVeeContactCellIdentifier @"VeeContactCell" //Also referenced into the xib
#define kVeeContactCellHeight 60.0
#define kVeeSectionIdentifierNoLetter @"#"

@interface VeeContactPickerViewController ()

@property (nonatomic) ABAddressBookRef addressBookRef;

@property (nonatomic, strong) NSArray<VeeContactProt>* abContactsCache;
@property (nonatomic, strong) NSArray<VeeContactProt>* abContactsSearchResults;
@property (nonatomic, strong) NSArray<NSString*>* sectionIdentifiersCache;

@property (nonatomic, strong) NSArray<NSString*>* abContactsSortedKeysForSections;
@property (nonatomic, strong) NSArray<NSString*>* abContactsSearchResultsSortedKeysForSections;
@property (nonatomic, strong) NSDictionary* abContactsForSectionIdentifiers; //TODO: use generics
@property (nonatomic, strong) NSDictionary* abContactsForSectionIdentifiersSearchResults; //TODO: use generics
@property (nonatomic, strong) NSMutableDictionary<NSString*, UIColor*>* colorsCache;

@end

@implementation VeeContactPickerViewController

#pragma mark - Initializers

- (instancetype)initWithCompletionHandler:(void (^)(id<VeeContactProt> abContact))didSelectABContact
{
    self = [[VeeContactPickerViewController alloc] initWithNibName:NSStringFromClass([self class]) bundle:nil];
    if (self) {
        _completionHandler = didSelectABContact;
        [self initDefaultOptions];
    }
    return self;
}

- (instancetype)initWithDelegate:(id<VeeContactPickerDelegate>)contactPickerDelegate
{
    self = [[VeeContactPickerViewController alloc] initWithNibName:NSStringFromClass([self class]) bundle:nil];
    if (self) {
        _contactPickerDelegate = contactPickerDelegate;
        [self initDefaultOptions];
    }
    return self;
}

- (void)initDefaultOptions
{
    //Default options:
    _showContactDetailLabel = NO;
    _showFirstNameFirst = YES;
    _veeContactDetail = VeeContactDetailPhoneNumber;
    _showLettersWhenContactImageIsMissing = YES;
    
    //Strings
    _localizedTitle = @"Choose a contact";
    _localizedCancelButtonTitle = @"Cancel";
}

//#pragma mark - Options

#pragma mark - ViewController lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    //Load custom strings if they have been set 
    _titleNavigationItem.title = _localizedTitle;
    _cancelBarButtonItem.title = _localizedCancelButtonTitle;

    //Register nibs
    [_contactsTableView registerNib:[UINib nibWithNibName:kVeeContactCellNibName bundle:nil] forCellReuseIdentifier:kVeeContactCellIdentifier];
    
    //Check address book permission, and ask for it if needed

    CFErrorRef error = NULL;
    _addressBookRef = ABAddressBookCreateWithOptions(NULL, &error);
    if (error) {
        NSLog(@"Warning - ABAddressBookCreateWithOptions error: %@", CFBridgingRelease(error));
    }

    if ([self hasAddressBookPermissions] == NO) {
        //Ask for address book permission
        ABAddressBookRequestAccessWithCompletion(_addressBookRef, ^(bool granted, CFErrorRef error) {
            if (!granted) {
                NSLog(@"Warning - ABAddressBookRequestAccessWithCompletion not granted");
                //TODO: empty view
            }
            else{
                [self performSelectorOnMainThread:@selector(loadDataSource) withObject:nil waitUntilDone:YES];
            }
        });
    }
    
    [self loadDataSource];
}

-(void)loadDataSource
{
    _sectionIdentifiersCache = [self sectionIdentifiers];
    
    //Sort contacts by first name, in the address book way
    //TODO: check showFirstNameFirst
    _abContactsCache = (NSArray<VeeContactProt>*)[[self unifiedABContacts] sortedArrayUsingComparator:^NSComparisonResult(id<VeeContactProt> firstContact, id<VeeContactProt> secondContact) {
        NSString* firstContactSortProperty = firstContact.firstName;
        NSString* secondContactSortProperty = secondContact.firstName;
        
        if ([firstContact.firstName isEqualToString:@""]) {
            firstContactSortProperty = firstContact.lastName;
            if ([firstContact.lastName isEqualToString:@""]) {
                firstContactSortProperty = firstContact.displayName;
            }
        }
        if ([secondContact.firstName isEqualToString:@""]) {
            secondContactSortProperty = secondContact.lastName;
            if ([secondContact.lastName isEqualToString:@""]) {
                secondContactSortProperty = secondContact.displayName;
            }
        }
        NSComparisonResult result = [firstContactSortProperty compare:secondContactSortProperty options:NSDiacriticInsensitiveSearch | NSCaseInsensitiveSearch];
        if (result == NSOrderedSame) {
            return [firstContact.displayName compare:secondContact.displayName options:NSDiacriticInsensitiveSearch | NSCaseInsensitiveSearch];
        }
        else {
            return result;
        }
    }];
    
    _abContactsForSectionIdentifiers = [self abContactsDictionaryWithSectionIdentifiers:_abContactsCache];
    _abContactsSortedKeysForSections = [[_abContactsForSectionIdentifiers allKeys] sortedArrayUsingComparator:^NSComparisonResult(NSString* firstKey, NSString* secondKey) {
        
        //Re-sort section identifiers because we want '#' to be the last section and not the first one:
        if ([firstKey isEqualToString:kVeeSectionIdentifierNoLetter]) {
            return NSOrderedDescending;
        }
        else if ([secondKey isEqualToString:kVeeSectionIdentifierNoLetter]) {
            return NSOrderedAscending;
        }
        else {
            return [firstKey caseInsensitiveCompare:secondKey];
        }
    }];
    
    
    [_contactsTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - AddressBook utils

- (BOOL)hasAddressBookPermissions
{
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        return YES;
    }
    return NO;
}

#pragma mark - Data source

- (NSArray<VeeContactProt>*)unifiedABContacts
{
    NSMutableArray<VeeContactProt>* mutableACContacts = (NSMutableArray<VeeContactProt>*)[NSMutableArray new];
    NSMutableSet* linkedPersonsToSkip = [NSMutableSet new]; //Use this set to skip linked records of a contact that are already been processed

    NSArray* abSources = (__bridge_transfer NSArray*)(ABAddressBookCopyArrayOfAllSources(_addressBookRef));

    for (int s = 0; s < abSources.count; s++) { //Search in all sources
        ABRecordRef source = (__bridge ABRecordRef)(abSources[s]);
        NSArray* peopleInSource = (__bridge NSArray*)ABAddressBookCopyArrayOfAllPeopleInSource(_addressBookRef, source);

        for (int i = 0; i < peopleInSource.count; i++) {
            ABRecordRef person = CFArrayGetValueAtIndex((__bridge CFArrayRef)(peopleInSource), i);

            if ([linkedPersonsToSkip containsObject:(__bridge id)(person)]) {
                continue;
            }

            VeeContact* veeABContactUnified = [[VeeContact alloc] initWithPerson:person];
            
            NSArray* linkedRecordsOfPerson = (__bridge_transfer NSArray*)ABPersonCopyArrayOfAllLinkedPeople(person);

            //If the contact is composed by 2 or more records
            if (linkedRecordsOfPerson.count > 1) {

                //To avoid duplicates, we add all linked records in linkedPersonsToSkip, so next time we can recognie and skip them
                [linkedPersonsToSkip addObjectsFromArray:linkedRecordsOfPerson];

                for (int j = 0; j < linkedRecordsOfPerson.count; j++) {
                    //Add information to the unified contact from linked records
                    ABRecordRef linkedABRecordRef = CFArrayGetValueAtIndex((__bridge CFArrayRef)(linkedRecordsOfPerson), j);
                    [veeABContactUnified updateDataFromABRecordRef:linkedABRecordRef];
                }
            }
            
            [mutableACContacts addObject:veeABContactUnified];

        }
    }
    return (NSArray<VeeContactProt>*)[NSArray arrayWithArray:mutableACContacts];
}

- (NSArray<NSString*>*)sectionIdentifiers
{
    return [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles];
}

- (NSDictionary*)abContactsDictionaryWithSectionIdentifiers:(NSArray*)abContacts
{
    NSMutableDictionary* abContactsSectionedMutable = [NSMutableDictionary new];
    
    for (id<VeeContactProt> abContact in abContacts) {
        NSArray* abContactsForSectionIdentifier = [abContactsSectionedMutable objectForKey:[abContact sectionIdentifier]];
        if (abContactsForSectionIdentifier == nil) {
            [abContactsSectionedMutable setObject:[NSArray arrayWithObject:abContact] forKey:[abContact sectionIdentifier]];
        }
        else {
            [abContactsSectionedMutable setObject:[abContactsForSectionIdentifier arrayByAddingObject:abContact] forKey:[abContact sectionIdentifier]];
        }
    }
    return [NSDictionary dictionaryWithDictionary:abContactsSectionedMutable];
}

#pragma mark - TableView data source

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [[_abContactsForSectionIdentifiersSearchResults allKeys] count];
    }
    return [[_abContactsForSectionIdentifiers allKeys] count];
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        NSString* sectionIdentifier = [_abContactsSearchResultsSortedKeysForSections objectAtIndex:section];
        return [[_abContactsForSectionIdentifiersSearchResults objectForKey:sectionIdentifier] count];
    }
    NSString* sectionIdentifier = [_abContactsSortedKeysForSections objectAtIndex:section];
    return [[_abContactsForSectionIdentifiers objectForKey:sectionIdentifier] count];
}

- (NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [_abContactsSearchResultsSortedKeysForSections objectAtIndex:section];
    }
    return [_abContactsSortedKeysForSections objectAtIndex:section];
}

- (NSArray<NSString*>*)sectionIndexTitlesForTableView:(UITableView*)tableView
{
    return _sectionIdentifiersCache;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    VeeContactUITableViewCell* veeContactUITableViewCell = [tableView dequeueReusableCellWithIdentifier:kVeeContactCellIdentifier];
    if (!veeContactUITableViewCell) {
        veeContactUITableViewCell = [[[NSBundle mainBundle] loadNibNamed:kVeeContactCellNibName owner:self options:nil] objectAtIndex:0];
    }

    //Load ACContact for this cell
    id<VeeContactProt> abContact;

    if (tableView == self.searchDisplayController.searchResultsTableView) {
        NSString* sectionIdentifier = [_abContactsSearchResultsSortedKeysForSections objectAtIndex:indexPath.section];
        abContact = [[_abContactsForSectionIdentifiersSearchResults objectForKey:sectionIdentifier] objectAtIndex:indexPath.row];
    }
    else {
        NSString* sectionIdentifier = [_abContactsSortedKeysForSections objectAtIndex:indexPath.section];
        abContact = [[_abContactsForSectionIdentifiers objectForKey:sectionIdentifier] objectAtIndex:indexPath.row];
    }

    //Load empty default values
    veeContactUITableViewCell.firstLabelCenterYAlignmenetConstraint.constant = 0;
    veeContactUITableViewCell.thirdLabel.hidden = YES;
    veeContactUITableViewCell.firstLabel.text = @"";
    veeContactUITableViewCell.thirdLabel.text = @"";
    veeContactUITableViewCell.contactImageView.image = nil;
    
    NSString* firstInfo = [abContact firstName];
    NSString* secondInfo;
    NSString* concatInfo;

    if ([abContact middleName]) {
        secondInfo = [NSString stringWithFormat:@"%@ %@", [abContact middleName], [abContact lastName]];
    }
    else {
        secondInfo = [abContact lastName];
    }

    if (_showFirstNameFirst == NO) {
        //Swap firstInfo and secondInfo
        NSString* tmp = firstInfo;
        firstInfo = secondInfo;
        secondInfo = tmp;
    }

    //Load ACContact information into the cell
    if (firstInfo) {
        concatInfo = firstInfo;
        if (secondInfo) {
            concatInfo = [concatInfo stringByAppendingString:[NSString stringWithFormat:@" %@",secondInfo]];
        }
        veeContactUITableViewCell.firstLabel.text = concatInfo;
        [veeContactUITableViewCell.firstLabel boldSubstring:firstInfo];
    }
    else {
        if (secondInfo) {
            concatInfo = secondInfo;
        }
        else {
            concatInfo = [abContact displayName];
        }
        veeContactUITableViewCell.firstLabel.text = concatInfo;
        [veeContactUITableViewCell.firstLabel boldSubstring:concatInfo];
    }

    
    if ([abContact thumbnailImage]) {
        veeContactUITableViewCell.contactImageView.image = [abContact thumbnailImage];
    }
    else {
        if (_showLettersWhenContactImageIsMissing){
            [veeContactUITableViewCell.contactImageView setImageWithString:[abContact displayName] color:[self colorForABContact:abContact]];
        }
        else{
            if (_contactThumbnailImagePlaceholder){
                [veeContactUITableViewCell.contactImageView setImage:_contactThumbnailImagePlaceholder];
            }
        }
    }

    if (_showContactDetailLabel) {

        veeContactUITableViewCell.thirdLabel.hidden = NO;

        if (_veeContactDetail == VeeContactDetailPhoneNumber) {
            if ([[abContact phoneNumbers] count] > 0) {
                veeContactUITableViewCell.thirdLabel.text = [[abContact phoneNumbers] firstObject];
            }
        }
        else if (_veeContactDetail == VeeContactDetailEmail) {
            if ([[abContact emails] count] > 0) {
                veeContactUITableViewCell.thirdLabel.text = [[abContact emails] firstObject];
            }
        }

        //Change constraints: //TODO: this is not working
        veeContactUITableViewCell.firstLabelCenterYAlignmenetConstraint.constant = 20;
    }
    return veeContactUITableViewCell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    [self dismissViewControllerAnimated:YES completion:^{
        //Both delegate and blocks
        id<VeeContactProt> abContact;

        if (tableView == self.searchDisplayController.searchResultsTableView) {
            NSString* sectionIdentifier = [_abContactsSearchResultsSortedKeysForSections objectAtIndex:indexPath.section];
            abContact = [[_abContactsForSectionIdentifiersSearchResults objectForKey:sectionIdentifier] objectAtIndex:indexPath.row];
        }
        else {
            NSString* sectionIdentifier = [_abContactsSortedKeysForSections objectAtIndex:indexPath.section];
            abContact = [[_abContactsForSectionIdentifiers objectForKey:sectionIdentifier] objectAtIndex:indexPath.row];
        }

        if (_contactPickerDelegate) {
            [_contactPickerDelegate didSelectABContact:abContact];
        }

        if (_completionHandler) {
            _completionHandler(abContact);
        }
    }];
}

#pragma mark - TableView delegate

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return kVeeContactCellHeight;
}

#pragma mark - UIImage+Letters colors helper

- (UIColor*)colorForABContact:(id<VeeContactProt>)abContact
{
    NSString* contactIdentifier = [abContact compositeName];
    if (contactIdentifier == nil){
        return [UIColor lightGrayColor];
    }
    if (!_contactLettersColorPalette) {
        return [UIColor lightGrayColor];
    }
    if (!_colorsCache) {
        _colorsCache = (NSMutableDictionary<NSString*, UIColor*>*)[NSMutableDictionary new];
    }
    if ([_colorsCache objectForKey:contactIdentifier]) {
        return [_colorsCache objectForKey:contactIdentifier];
    }
    
    unsigned long hashNumber = djb2StringToLong((unsigned char*)[contactIdentifier UTF8String]);
    UIColor* color = _contactLettersColorPalette[hashNumber % [_contactLettersColorPalette count]];
    [_colorsCache setObject:color forKey:contactIdentifier];
    return color;
}

/*http://www.cse.yorku.ca/~oz/hash.html djb2 algorithm to generate an unsigned long hash from a given string */
unsigned long djb2StringToLong(unsigned char* str)
{
    unsigned long hash = 5381;
    int c;

    while ((c = *str++))
        hash = ((hash << 5) + hash) + c; /* hash * 33 + c */

    return hash;
}

#pragma mark - IBActions

- (IBAction)cancelBarButtonItemPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        if (_completionHandler) {
            _completionHandler(nil);
        }
    }];
}

#pragma mark - Search

- (BOOL)searchDisplayController:(UISearchDisplayController*)controller shouldReloadTableForSearchString:(NSString*)searchString
{
    [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    return YES;
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate* resultPredicate = [NSPredicate predicateWithFormat:@"displayName contains[c] %@ || ANY emails contains[c] %@ || ANY phoneNumbers contains[c] %@", searchText, searchText, searchText];
    _abContactsSearchResults = (NSArray<VeeContactProt>*)[_abContactsCache filteredArrayUsingPredicate:resultPredicate];
    _abContactsForSectionIdentifiersSearchResults = [self abContactsDictionaryWithSectionIdentifiers:_abContactsSearchResults];
    _abContactsSearchResultsSortedKeysForSections = [[_abContactsForSectionIdentifiersSearchResults allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
}

@end
