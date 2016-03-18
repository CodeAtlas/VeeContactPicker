//
//  Created by Andrea Cipriani on 18/03/16,
//  Copyright © 2015 Code Atlas SRL. All rights reserved.
//

#import "VeeSectionedArrayDataSource.h"

@interface VeeSectionedArrayDataSource()

@property (nonatomic, strong) NSDictionary<NSString*,NSArray<id<VeeSectionable>>*>* sectionedItems;
@property (nonatomic, strong) NSDictionary<NSString*,NSArray<id<VeeSectionable>>*>* sectionedSearchedItems;
@property (nonatomic, strong) NSArray<NSString*>* sortedNonEmptySectionIdentifiers;
@property (nonatomic, strong) NSArray<NSString*>* sortedSearchedNonEmptySectionIdentifiers;
@property (nonatomic, strong) NSArray<NSString*>* allowedSectionIdentifiers;
@property (nonatomic, copy) NSString* cellIdentifier;
@property (nonatomic, copy) NSString* sectionIdentifierWildcard;
@property (nonatomic, copy) ConfigureCellBlock configureCellBlock;
@property (nonatomic, strong) UITableView *searchTableView;

@end

@implementation VeeSectionedArrayDataSource

#pragma mark - Initializers

-(instancetype)initWithItems:(NSArray<id<VeeSectionable>>*)items cellIdentifier:(NSString*)cellIdentifier allowedSectionIdentifiers:(NSArray<NSString*>*)allowedSectionIdentifiers sectionIdentifierWildcard:(NSString*)sectionIdentifierWildcard configurationCellBlock:(ConfigureCellBlock)configureCellBlock
{
    self = [super init];
    if (self) {
        _allowedSectionIdentifiers = allowedSectionIdentifiers;
        _sectionIdentifierWildcard = sectionIdentifierWildcard;
        _sectionedItems = [self sectionedItems:items];
        _sortedNonEmptySectionIdentifiers = [self caseInsensitiveSortedSectionIdentifiers:[_sectionedItems allKeys]];
        _cellIdentifier = cellIdentifier;
        _configureCellBlock = configureCellBlock;
    }
    return self;
}

#pragma mark - Public methods

-(id)tableView:(UITableView*)tableView itemAtIndexPath:(NSIndexPath*)indexPath
{
    BOOL isSearchTableView = [self isSearchTableView:tableView];
    NSArray<id<VeeSectionable>>* itemsForSection = [self itemsForSection:indexPath.section isSearchTableView:isSearchTableView];
    return [itemsForSection objectAtIndex:indexPath.row];
}

-(void)setSearchResults:(NSArray<id<VeeSectionable>>*)searchResults forSearchTableView:(UITableView*)searchTableView
{
    _searchTableView = searchTableView;
    if (searchResults){
        _sectionedSearchedItems = [self sectionedItems:searchResults];
        _sortedSearchedNonEmptySectionIdentifiers = [self caseInsensitiveSortedSectionIdentifiers:[_sectionedSearchedItems allKeys]];
    }
}

#pragma mark - Model utils

- (NSDictionary<NSString*,NSArray<id<VeeSectionable>>*>*)sectionedItems:(NSArray<id<VeeSectionable>>*)items
{
    NSMutableDictionary<NSString*,NSArray<id<VeeSectionable>>*>* sectionedItemsMutable = [NSMutableDictionary new];
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

-(NSArray<NSString*>*)caseInsensitiveSortedSectionIdentifiers:(NSArray*)sectionIdentifiers
{
    return [sectionIdentifiers sortedArrayUsingComparator:^NSComparisonResult(NSString* firstKey, NSString* secondKey) {
        if ([firstKey isEqualToString:_sectionIdentifierWildcard]) {
            return NSOrderedDescending;
        }
        else if ([secondKey isEqualToString:_sectionIdentifierWildcard]) {
            return NSOrderedAscending;
        }
        else {
            return [firstKey caseInsensitiveCompare:secondKey];
        }
    }];
}

#pragma mark - TableViewDataSource

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
    return _allowedSectionIdentifiers;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    
    id cell = [tableView dequeueReusableCellWithIdentifier:_cellIdentifier forIndexPath:indexPath];
    id item = [self tableView:tableView itemAtIndexPath:indexPath];
    _configureCellBlock(cell,item);
    return cell;
}

#pragma mark - Data source utils

- (NSArray<id<VeeSectionable>>*)itemsForSection:(NSUInteger)section isSearchTableView:(BOOL)isSearchTableView
{
    NSString* sectionIdentifier = [self sectionIdentifierFromSection:section isSearchTableView:isSearchTableView];
    if (isSearchTableView){
        return [_sectionedSearchedItems objectForKey:sectionIdentifier];
    }
    return [_sectionedItems objectForKey:sectionIdentifier];
}

-(NSString*)sectionIdentifierForItem:(id<VeeSectionable>)item
{
    NSString* sectionIdenfier = [item sectionIdentifier];
    if (sectionIdenfier == nil){
        return _sectionIdentifierWildcard;
    }
    return sectionIdenfier;
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
