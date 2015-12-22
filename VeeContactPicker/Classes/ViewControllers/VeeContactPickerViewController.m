//
//  VeeContactPicker.m
//  VeeContactPicker
//
//  Created by Andrea Cipriani on 14/12/15.
//  Copyright © 2015 Code Atlas SRL. All rights reserved.
//

#import "ACContact.h"
#import "VeeContactPickerViewController.h"
#import "VeeContactUITableViewCell.h"
#import "UIImageView+Letters.h"

#define kVeeContactCellNibName @"VeeContactUITableViewCell"
#define kVeeContactCellIdentifier @"VeeContactCell" //Also referenced into the xib
#define kVeeContactCellHeight 60.0
#define kVeeSectionIdentifierNoLetter @"#"

@interface VeeContactPickerViewController ()

@property (nonatomic,strong) NSArray<ABContactProt>* abContactsSearchResults;

@property (nonatomic,strong) NSArray<NSString *>* abContactsSortedKeysForSections;
@property (nonatomic,strong) NSArray<NSString *>* abContactsSearchResultsSortedKeysForSections;
@property (nonatomic,strong) NSDictionary* abContactsForSectionIdentifiers; //TODO: use generics
@property (nonatomic,strong) NSDictionary* abContactsForSectionIdentifiersSearchResults; //TODO: use generics

@end

@implementation VeeContactPickerViewController

#pragma mark - Initializers

-(instancetype)initWithCompletionHandler:(void(^)(id<ABContactProt> abContact))didSelectABContact
{
    self = [[VeeContactPickerViewController alloc] initWithNibName:NSStringFromClass([self class]) bundle:nil];
    if (self) {
        _completionHandler = didSelectABContact;
    }
    return self;
}

-(instancetype)initWithDelegate:(id<VeeContactPickerDelegate>)contactPickerDelegate
{
    self = [[VeeContactPickerViewController alloc] initWithNibName:NSStringFromClass([self class]) bundle:nil];
    if (self) {
        _contactPickerDelegate = contactPickerDelegate;
    }
    return self;
}

#pragma mark - ViewController lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    //Data source loading
    if (!_addressBookRef) {
        CFErrorRef error = NULL;
        _addressBookRef = ABAddressBookCreateWithOptions(NULL, &error);
        if (!_addressBookRef) {
            NSLog(@"ABAddressBookCreateWithOptions error: %@", CFBridgingRelease(error));
            //TODO: Handle error
        }

        if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
            //Ask for address book permission //TODO: refactor
            ABAddressBookRequestAccessWithCompletion(_addressBookRef, ^(bool granted, CFErrorRef error) {
                if (!granted) {
                    //TODO: handle denied case, dismiss view controller?
                    return;
                }

            });
        }
        //TOOD: handle not authorized status

        //Authorized...

        _allSectionIdentifiers = [self allSectionIdentifiers];
        _abContacts = [self abContacts];         //TODO: change this
        
        //Sort contacts by first name, in the address book way
        _abContacts = (NSArray<ABContactProt>*)[_abContacts sortedArrayUsingComparator:^NSComparisonResult(ACContact* firstContact, ACContact* secondContact) {
          
            NSString *firstContactSortProperty = firstContact.firstName;
            NSString *secondContactSortProperty = secondContact.firstName;
            
            if([firstContact.firstName isEqualToString:@""]){
                firstContactSortProperty = firstContact.lastName;
                if([firstContact.lastName isEqualToString:@""]){
                    firstContactSortProperty = firstContact.displayName;
                }
            }
            if([secondContact.firstName isEqualToString:@""]){
                secondContactSortProperty = secondContact.lastName;
                if([secondContact.lastName isEqualToString:@""]){
                    secondContactSortProperty = secondContact.displayName;
                }
            }
            NSComparisonResult result = [firstContactSortProperty compare:secondContactSortProperty options:NSDiacriticInsensitiveSearch|NSCaseInsensitiveSearch];
            if (result == NSOrderedSame){
                return [firstContact.displayName compare:secondContact.displayName options:NSDiacriticInsensitiveSearch|NSCaseInsensitiveSearch];
            }
            else{
                return result;
            }
        }];
        
        _abContactsForSectionIdentifiers = [self contactsDictionaryWithSectionIdentifiers:_abContacts];
        _abContactsSortedKeysForSections = [[_abContactsForSectionIdentifiers allKeys] sortedArrayUsingComparator:^NSComparisonResult(NSString* firstKey, NSString* secondKey) {
            
            //Because we want '#' to be the last section and not the first one:
            if ([firstKey isEqualToString:kVeeSectionIdentifierNoLetter]){
                return NSOrderedDescending;
            }
            else if([secondKey isEqualToString:kVeeSectionIdentifierNoLetter]){
                return NSOrderedAscending;
            }
            else{
                return [firstKey caseInsensitiveCompare:secondKey];
            }
        }];

        _veeContactDetail = VeeContactDetailEmail;
        CFRelease(_addressBookRef);
    }
    
    //Register nibs
    [_contactsTableView registerNib:[UINib nibWithNibName:kVeeContactCellNibName bundle:nil] forCellReuseIdentifier:kVeeContactCellIdentifier];
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
    NSLog(@"%@ failed to get address book permissions", NSStringFromClass([self class]));
    return NO;
}

#pragma mark - Data source

//You can overwrite this method to change the data source of the VeeContactPicker
- (NSArray<ABContactProt>*)abContacts
{
    NSMutableArray<ABContactProt>* mutableACContacts = (NSMutableArray<ABContactProt>*)[NSMutableArray new];
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

            NSArray* linkedRecordsOfPerson = (__bridge_transfer NSArray*)ABPersonCopyArrayOfAllLinkedPeople(person);
            
            //If the contact is composed by 2 or more records
            if (linkedRecordsOfPerson.count > 1) {
                //To avoid duplicates, I add all linked record in linkedPersonsToSkip, so next time I can recognie and skip them
                [linkedPersonsToSkip addObjectsFromArray:linkedRecordsOfPerson];
            }
            
            [mutableACContacts addObject:[[ACContact alloc] initWithPerson:person]]; //TODO: In this way we lose the info of linked contacts, that could be useful for searching
        }
    }
    return (NSArray<ABContactProt>*) [NSArray arrayWithArray:mutableACContacts];
}

- (NSDictionary*)contactsDictionaryWithSectionIdentifiers:(NSArray*)abContacts
{
    NSMutableDictionary* abContactsSectionedMutable = [NSMutableDictionary new];

    for (id<ABContactProt> abContact in abContacts){
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

- (NSArray<NSString*>*)allSectionIdentifiers
{
    //TODO: localize
    return [NSArray arrayWithObjects:@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", kVeeSectionIdentifierNoLetter, nil];
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
    return _allSectionIdentifiers;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    VeeContactUITableViewCell* veeContactUITableViewCell = [tableView dequeueReusableCellWithIdentifier:kVeeContactCellIdentifier];
    if (!veeContactUITableViewCell) {
        veeContactUITableViewCell = [[[NSBundle mainBundle] loadNibNamed:kVeeContactCellNibName owner:self options:nil] objectAtIndex:0];
    }

    //Load ACContact for this cell
    id<ABContactProt> abContact;
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        NSString* sectionIdentifier = [_abContactsSearchResultsSortedKeysForSections objectAtIndex:indexPath.section];
        abContact = [[_abContactsForSectionIdentifiersSearchResults objectForKey:sectionIdentifier] objectAtIndex:indexPath.row];
    }
    else{
        NSString* sectionIdentifier = [_abContactsSortedKeysForSections objectAtIndex:indexPath.section];
        abContact = [[_abContactsForSectionIdentifiers objectForKey:sectionIdentifier] objectAtIndex:indexPath.row];
    }

    //Load ACContact information into the cell
    veeContactUITableViewCell.firstLabel.text = @"";
    veeContactUITableViewCell.secondLabel.text = @"";
    veeContactUITableViewCell.thirdLabel.text = @"";

    if ([abContact firstName] && [abContact lastName]){
        veeContactUITableViewCell.firstLabel.text = [abContact firstName];
        if ([abContact middleName]){
            veeContactUITableViewCell.secondLabel.text = [NSString stringWithFormat:@"%@ %@",[abContact middleName],[abContact lastName]];
        }
        else{
            veeContactUITableViewCell.secondLabel.text = [abContact lastName];
        }
    }
    else{
        if ([abContact firstName]){
            veeContactUITableViewCell.firstLabel.text = [abContact firstName];
        }
        else if([abContact lastName])
        {
            if ([abContact middleName]){
                veeContactUITableViewCell.secondLabel.text = [NSString stringWithFormat:@"%@ %@",[abContact middleName],[abContact lastName]];
            }
            else{
                veeContactUITableViewCell.firstLabel.text = [abContact lastName];
            }
        }
        else{
            veeContactUITableViewCell.firstLabel.text = [abContact displayName];
        }
    }

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

    if ([abContact thumbnailImage]) {
        veeContactUITableViewCell.contactImageView.image = [abContact thumbnailImage];
    }
    else {
        [veeContactUITableViewCell.contactImageView setImageWithString:[abContact displayName] color:[self colorForString:[abContact displayName]]];
    }

    return veeContactUITableViewCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self dismissViewControllerAnimated:YES completion:^{
        //Both delegate and blocks
        id<ABContactProt> abContact;
        
        if (tableView == self.searchDisplayController.searchResultsTableView) {
            NSString* sectionIdentifier = [_abContactsSearchResultsSortedKeysForSections objectAtIndex:indexPath.section];
            abContact = [[_abContactsForSectionIdentifiersSearchResults objectForKey:sectionIdentifier] objectAtIndex:indexPath.row];
        }
        else{
            NSString* sectionIdentifier = [_abContactsSortedKeysForSections objectAtIndex:indexPath.section];
            abContact = [[_abContactsForSectionIdentifiers objectForKey:sectionIdentifier] objectAtIndex:indexPath.row];
        }
        
        if (_contactPickerDelegate){
            [_contactPickerDelegate didSelectABContact:abContact];
        }
        
        if (_completionHandler){
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

-(UIColor*)colorForString:(NSString*)contactDisplayName
{
    if (!_contactLettersColorPalette){
        return [UIColor lightGrayColor];
    }
    //TODO: add cache
    
    unsigned long hashNumber = hash((unsigned char*)[contactDisplayName UTF8String]);
    UIColor *color = _contactLettersColorPalette[hashNumber % [_contactLettersColorPalette count]];
    return color;
}

/*http://www.cse.yorku.ca/~oz/hash.html djb2 algorithm to generate an unsigned long hash from a given string */
unsigned long hash(unsigned char *str)
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
        if (_completionHandler){
            _completionHandler(nil);
        }
    }];
}

#pragma mark - Search

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    return YES;
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"displayName contains[c] %@ || ANY emails contains[c] %@ || ANY phoneNumbers contains[c] %@", searchText, searchText, searchText];
    _abContactsSearchResults = (NSArray<ABContactProt>*)[_abContacts filteredArrayUsingPredicate:resultPredicate];
    _abContactsForSectionIdentifiersSearchResults = [self contactsDictionaryWithSectionIdentifiers:_abContactsSearchResults];
    _abContactsSearchResultsSortedKeysForSections = [[_abContactsForSectionIdentifiersSearchResults allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
}

@end
