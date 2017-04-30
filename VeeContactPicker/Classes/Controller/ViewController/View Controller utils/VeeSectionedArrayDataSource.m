#import "VeeSectionedArrayDataSource.h"
#import "VeeContactPickerAppearanceConstants.h"

NS_ASSUME_NONNULL_BEGIN

@interface VeeSectionedArrayDataSource()
@property (nonatomic, strong) NSDictionary<NSString*,NSArray<id<VeeSectionableProt>>*>* sectionedItems;
@property (nonatomic, strong) NSDictionary<NSString*,NSArray<id<VeeSectionableProt>>*>* sectionedSearchedItems;
@property (nonatomic, strong) NSArray<NSString*>* sortedNonEmptySectionIdentifiers;
@property (nonatomic, strong) NSArray<NSString*>* sortedSearchedNonEmptySectionIdentifiers;
@property (nonatomic, strong) NSArray<NSString*>* allowedSortedSectionIdentifiers;
@property (nonatomic, copy) NSString* cellIdentifier;
@property (nonatomic, copy) NSString* sectionIdentifierWildcard;
@property (nonatomic, copy) ConfigureCellBlock configureCellBlock;
@property (nonatomic, strong) UITableView *searchTableView;
@end

@implementation VeeSectionedArrayDataSource

#pragma mark - Initializers

-(instancetype)initWithItems:(NSArray<id<VeeSectionableProt>>*)items cellIdentifier:(NSString*)cellIdentifier allowedSortedSectionIdentifiers:(NSArray<NSString*>*)allowedSortedSectionIdentifiers sectionIdentifierWildcard:(NSString*)sectionIdentifierWildcard configurationCellBlock:(ConfigureCellBlock)configureCellBlock
{
    self = [super init];
    if (self) {
        _allowedSortedSectionIdentifiers = allowedSortedSectionIdentifiers;
        _sectionIdentifierWildcard = sectionIdentifierWildcard;
        _sectionedItems = [self sectionedItems:items];
        _sortedNonEmptySectionIdentifiers = [self nonEmptySortedSectionIdentifiers:_sectionedItems.allKeys];
        _cellIdentifier = cellIdentifier;
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
    BOOL isSearchTableView = [self isSearchTableView:tableView];
    NSArray<id<VeeSectionableProt>>* itemsForSection = [self itemsForSection:indexPath.section isSearchTableView:isSearchTableView];
    return itemsForSection[indexPath.row];
}

-(void)setSearchResults:(NSArray<id<VeeSectionableProt>>*)searchResults forSearchTableView:(UITableView*)searchTableView
{
    if (searchTableView){
        self.searchTableView = searchTableView;
    }
    if (searchResults){
        self.sectionedSearchedItems = [self sectionedItems:searchResults];
        self.sortedSearchedNonEmptySectionIdentifiers = [self nonEmptySortedSectionIdentifiers:(self.sectionedSearchedItems).allKeys];
    }
}

-(NSString*)sectionIdentifierForItem:(id<VeeSectionableProt>)item
{
    NSString* sectionIdenfier = [item sectionIdentifier];
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
        NSString* itemSectionIdentifier = [self sectionIdentifierForItem:item];
        NSArray* itemsForThisSectionIdentifier = sectionedItemsMutable[itemSectionIdentifier];
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
    NSMutableArray* sortedNonEmptySectionIdentifiers = [NSMutableArray arrayWithArray:self.allowedSortedSectionIdentifiers];
    
    for (NSString* sectionIdentifier in self.allowedSortedSectionIdentifiers) {
        if ([sectionIdentifiers containsObject:sectionIdentifier] == NO){
            [sortedNonEmptySectionIdentifiers removeObject:sectionIdentifier];
        }
    }
    return [NSArray arrayWithArray:sortedNonEmptySectionIdentifiers];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    BOOL isSearchTableView = [self isSearchTableView:tableView];
    if (isSearchTableView){
        return (self.sectionedSearchedItems).allKeys.count;
    }
    return (self.sectionedItems).allKeys.count;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    BOOL isSearchTableView = [self isSearchTableView:tableView];
    return [self itemsForSection:section isSearchTableView:isSearchTableView].count;
}

- (NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section
{
    BOOL isSearchTableView = [self isSearchTableView:tableView];
    return [self sectionIdentifierFromSection:section isSearchTableView:isSearchTableView];
}

- (NSArray<NSString*>*)sectionIndexTitlesForTableView:(UITableView*)tableView
{
    return self.allowedSortedSectionIdentifiers;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    id cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier forIndexPath:indexPath];
    id item = [self tableView:tableView itemAtIndexPath:indexPath];
    self.configureCellBlock(cell,item);
    return cell;
}

#pragma mark - Data source utils

- (NSArray<id<VeeSectionableProt>>*)itemsForSection:(NSUInteger)section isSearchTableView:(BOOL)isSearchTableView
{
    NSString* sectionIdentifier = [self sectionIdentifierFromSection:section isSearchTableView:isSearchTableView];
    if (isSearchTableView){
        return (self.sectionedSearchedItems)[sectionIdentifier];
    }
    return (self.sectionedItems)[sectionIdentifier];
}

-(NSString*)sectionIdentifierFromSection:(NSUInteger)section isSearchTableView:(BOOL)isSearchTableView
{
    if (isSearchTableView){
        return (self.sortedSearchedNonEmptySectionIdentifiers)[section];
    }
    return (self.sortedNonEmptySectionIdentifiers)[section];
}

-(BOOL)isSearchTableView:(UITableView*)tableView
{
    if ([tableView isEqual:self.searchTableView]) {
        return YES;
    }
    return NO;
}

@end

NS_ASSUME_NONNULL_END
