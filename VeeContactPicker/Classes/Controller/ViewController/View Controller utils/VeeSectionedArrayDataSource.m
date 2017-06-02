#import "VeeSectionedArrayDataSource.h"
#import "VeeContactPickerAppearanceConstants.h"
#import "VeeContactProt.h"

NS_ASSUME_NONNULL_BEGIN

@interface VeeSectionedArrayDataSource()
@property (nonatomic, strong) NSArray<id<VeeContactProt>>* items;
@property (nonatomic, strong) NSDictionary<NSString*,NSArray<id<VeeSectionableProt>>*>* sectionedItems;
@property (nonatomic, strong) NSDictionary<NSString*,NSArray<id<VeeSectionableProt>>*>* sectionedSearchedItems;
@property (nonatomic, strong) NSArray<NSString*>* sortedNonEmptySectionIdentifiers;
@property (nonatomic, strong) NSArray<NSString*>* sortedSearchedNonEmptySectionIdentifiers;
@property (nonatomic, strong) NSArray<NSString*>* allowedSortedSectionIdentifiers;
@property (nonatomic, copy) NSString* cellIdentifier;
@property (nonatomic, copy) NSString* sectionIdentifierWildcard;
@property (nonatomic, copy) ConfigureCellBlock configureCellBlock;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) NSMutableArray<id<VeeContactProt>> *selectedVeeContacts;
@end

@implementation VeeSectionedArrayDataSource

#pragma mark - Initializers

-(instancetype)initWithItems:(NSArray<id<VeeContactProt>>*)items
              cellIdentifier:(NSString*)cellIdentifier
allowedSortedSectionIdentifiers:(NSArray<NSString*>*)allowedSortedSectionIdentifiers
   sectionIdentifierWildcard:(NSString*)sectionIdentifierWildcard
            searchController:(UISearchController *)searchController
      configurationCellBlock:(ConfigureCellBlock)configureCellBlock;
{
    self = [super init];
    if (self) {
        _items = items;
        _allowedSortedSectionIdentifiers = allowedSortedSectionIdentifiers;
        _sectionIdentifierWildcard = sectionIdentifierWildcard;
        _sectionedItems = [self sectionedItems:items];
        _sortedNonEmptySectionIdentifiers = [self nonEmptySortedSectionIdentifiers:_sectionedItems.allKeys];
        _cellIdentifier = cellIdentifier;
        _searchController = searchController;
        if (configureCellBlock){
            _configureCellBlock = configureCellBlock;
        }
        else{
            ConfigureCellBlock doNothingBlock = ^(UITableViewCell* cell, id item) {};
            _configureCellBlock = doNothingBlock;
        }
    }
    return self;
}

#pragma mark - Public methods 

-(id)tableView:(UITableView*)tableView itemAtIndexPath:(NSIndexPath*)indexPath
{
    return [self itemsForSection:indexPath.section][indexPath.row];
}

- (void)updateForSearchText:(NSString *)searchText selectedVeeContacts:(NSMutableArray<id<VeeContactProt>>*)selectedVeeContacts
{
    self.selectedVeeContacts = selectedVeeContacts;
    NSArray<id<VeeContactProt>> *searchResults = [self.items filteredArrayUsingPredicate:[self predicateForSearchString:searchText]];
    self.sectionedSearchedItems = [self sectionedItems:searchResults];
    self.sortedSearchedNonEmptySectionIdentifiers = [self nonEmptySortedSectionIdentifiers:self.sectionedSearchedItems.allKeys];
}

- (NSString*)sectionIdentifierForItem:(id<VeeSectionableProt>)item {
    NSString *sectionIdenfier = [item sectionIdentifier];
    if (sectionIdenfier == nil || [self.allowedSortedSectionIdentifiers containsObject:sectionIdenfier] == NO){
        return self.sectionIdentifierWildcard;
    }
    return sectionIdenfier;
}

#pragma mark - Model utils

- (NSDictionary<NSString*,NSArray<id<VeeSectionableProt>>*>*)sectionedItems:(NSArray<id<VeeSectionableProt>>*)items
{
    NSMutableDictionary<NSString*,NSArray<id<VeeSectionableProt>>*>* sectionedItemsMutable = [NSMutableDictionary new];
    for (id item in items) {
        NSString *itemSectionIdentifier = [self sectionIdentifierForItem:item];
        NSArray *itemsForThisSectionIdentifier = sectionedItemsMutable[itemSectionIdentifier];
        if (itemsForThisSectionIdentifier == nil) {
            sectionedItemsMutable[itemSectionIdentifier] = @[item];
        }
        else {
            sectionedItemsMutable[itemSectionIdentifier] = [itemsForThisSectionIdentifier arrayByAddingObject:item];
        }
    }
    return [NSDictionary dictionaryWithDictionary:sectionedItemsMutable];
}

-(NSArray<NSString*>*)nonEmptySortedSectionIdentifiers:(NSArray<NSString*>*)sectionIdentifiers
{
    NSMutableArray* nonEmptySortedSectionIdentifiers = [NSMutableArray arrayWithArray:self.allowedSortedSectionIdentifiers];

    for (NSString* sectionIdentifier in self.allowedSortedSectionIdentifiers) {
        if ([sectionIdentifiers containsObject:sectionIdentifier] == NO){
            [nonEmptySortedSectionIdentifiers removeObject:sectionIdentifier];
        }
    }
    return [NSArray arrayWithArray:nonEmptySortedSectionIdentifiers];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    if ([self isSearching]) {
        return self.sectionedSearchedItems.allKeys.count;
    }
    return self.sectionedItems.allKeys.count;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self itemsForSection:section].count;
}

- (NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self sectionIdentifierFromSection:section];
}

- (NSArray<NSString*>*)sectionIndexTitlesForTableView:(UITableView*)tableView
{
    return self.allowedSortedSectionIdentifiers;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    id cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier forIndexPath:indexPath];
    id item = [self tableView:tableView itemAtIndexPath:indexPath];
    if ([self.selectedVeeContacts containsObject:item]) {
        [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    self.configureCellBlock(cell,item);
    return cell;
}

#pragma mark - Data source utils

- (NSArray<id<VeeSectionableProt>>*)itemsForSection:(NSUInteger)section
{
    NSString* sectionIdentifier = [self sectionIdentifierFromSection:section];
    if ([self isSearching]) {
        return self.sectionedSearchedItems[sectionIdentifier];
    }
    return self.sectionedItems[sectionIdentifier];
}

-(NSString*)sectionIdentifierFromSection:(NSUInteger)section
{
    if ([self isSearching]) {
        return self.sortedSearchedNonEmptySectionIdentifiers[section];
    }
    return self.sortedNonEmptySectionIdentifiers[section];
}

#pragma mark - Private

- (NSPredicate*)predicateForSearchString:(NSString *)searchString
{
    if (self.items.count <= 0) {
        return nil;
    }
    NSPredicate *searchPredicate = [[self.items.firstObject class] searchPredicateForSearchString];
    searchPredicate = [searchPredicate predicateWithSubstitutionVariables:@{@"searchString": searchString}];
    return searchPredicate;
}

- (BOOL)isSearching {
    if (self.searchController.isActive && ![self.searchController.searchBar.text isEqualToString:@""]) {
        return YES;
    }
    return NO;
}

@end

NS_ASSUME_NONNULL_END
