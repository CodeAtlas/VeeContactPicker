//
//  Created by Andrea Cipriani on 18/03/16,
//  Copyright © 2015 Code Atlas SRL. All rights reserved.
//

#import "VeeSectionedArrayDataSource.h"
#import "VeeContactPickerAppearanceConstants.h"

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
        _sortedNonEmptySectionIdentifiers = [self nonEmptySortedSectionIdentifiers:[_sectionedItems allKeys]];
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
    return [itemsForSection objectAtIndex:indexPath.row];
}

-(void)setSearchResults:(NSArray<id<VeeSectionableProt>>*)searchResults forSearchTableView:(UITableView*)searchTableView
{
    if (searchTableView){
        _searchTableView = searchTableView;
    }
    if (searchResults){
        _sectionedSearchedItems = [self sectionedItems:searchResults];
        _sortedSearchedNonEmptySectionIdentifiers = [self nonEmptySortedSectionIdentifiers:[_sectionedSearchedItems allKeys]];
    }
}

-(NSString*)sectionIdentifierForItem:(id<VeeSectionableProt>)item
{
    NSString* sectionIdenfier = [item sectionIdentifier];
    if (sectionIdenfier == nil || [[self allowedSortedSectionIdentifiers] containsObject:sectionIdenfier] == NO){
        return _sectionIdentifierWildcard;
    }
    return sectionIdenfier;
}

#pragma mark - Model utils

- (NSDictionary<NSString*,NSArray<id<VeeSectionableProt>>*>*)sectionedItems:(NSArray<id<VeeSectionableProt>>*)items
{
    NSMutableDictionary<NSString*,NSArray<id<VeeSectionableProt>>*>* sectionedItemsMutable = [NSMutableDictionary new];
    for (id item in items) {
        NSString* itemSectionIdentifier = [self sectionIdentifierForItem:item];
        NSArray* itemsForThisSectionIdentifier = [sectionedItemsMutable objectForKey:itemSectionIdentifier];
        if (itemsForThisSectionIdentifier == nil) {
            [sectionedItemsMutable setObject:[NSArray arrayWithObject:item] forKey:itemSectionIdentifier];
        }
        else {
            [sectionedItemsMutable setObject:[itemsForThisSectionIdentifier arrayByAddingObject:item] forKey:itemSectionIdentifier];
        }
    }
    return [NSDictionary dictionaryWithDictionary:sectionedItemsMutable];
}

-(NSArray<NSString*>*)nonEmptySortedSectionIdentifiers:(NSArray<NSString*>*)sectionIdentifiers
{
    NSMutableArray* sortedNonEmptySectionIdentifiers = [NSMutableArray arrayWithArray:_allowedSortedSectionIdentifiers];
    
    for (NSString* sectionIdentifier in _allowedSortedSectionIdentifiers) {
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
        return [[_sectionedSearchedItems allKeys] count];
    }
    return [[_sectionedItems allKeys] count];
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    BOOL isSearchTableView = [self isSearchTableView:tableView];
    return [[self itemsForSection:section isSearchTableView:isSearchTableView] count];
}

- (NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section
{
    BOOL isSearchTableView = [self isSearchTableView:tableView];
    return [self sectionIdentifierFromSection:section isSearchTableView:isSearchTableView];
}

- (NSArray<NSString*>*)sectionIndexTitlesForTableView:(UITableView*)tableView
{
    return _allowedSortedSectionIdentifiers;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    id cell = [tableView dequeueReusableCellWithIdentifier:_cellIdentifier forIndexPath:indexPath];
    id item = [self tableView:tableView itemAtIndexPath:indexPath];
    _configureCellBlock(cell,item);
    return cell;
}

#pragma mark - Data source utils

- (NSArray<id<VeeSectionableProt>>*)itemsForSection:(NSUInteger)section isSearchTableView:(BOOL)isSearchTableView
{
    NSString* sectionIdentifier = [self sectionIdentifierFromSection:section isSearchTableView:isSearchTableView];
    if (isSearchTableView){
        return [_sectionedSearchedItems objectForKey:sectionIdentifier];
    }
    return [_sectionedItems objectForKey:sectionIdentifier];
}

-(NSString*)sectionIdentifierFromSection:(NSUInteger)section isSearchTableView:(BOOL)isSearchTableView
{
    if (isSearchTableView){
        return [_sortedSearchedNonEmptySectionIdentifiers objectAtIndex:section];
    }
    return [_sortedNonEmptySectionIdentifiers objectAtIndex:section];
}

-(BOOL)isSearchTableView:(UITableView*)tableView
{
    if ([tableView isEqual:_searchTableView]) {
        return YES;
    }
    return NO;
}

@end
