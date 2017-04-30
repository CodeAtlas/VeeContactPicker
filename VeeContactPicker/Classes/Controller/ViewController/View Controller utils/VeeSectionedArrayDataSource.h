@import Foundation;
@import UIKit;
#import "VeeSectionable.h"

NS_ASSUME_NONNULL_BEGIN

@interface VeeSectionedArrayDataSource : NSObject <UITableViewDataSource>

typedef void (^ConfigureCellBlock)(id cell, id item);

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithItems:(NSArray<id<VeeSectionableProt> >*)items cellIdentifier:(NSString*)cellIdentifier allowedSortedSectionIdentifiers:(NSArray<NSString*>*)allowedSortedSectionIdentifiers sectionIdentifierWildcard:(NSString*)sectionIdentifierWildcard configurationCellBlock:(ConfigureCellBlock)block NS_DESIGNATED_INITIALIZER;

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView;
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section;
- (NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section;
- (NSArray<NSString*>*)sectionIndexTitlesForTableView:(UITableView*)tableView;
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath;

#pragma mark - Public methods

- (id)tableView:(UITableView*)tableView itemAtIndexPath:(NSIndexPath*)indexPath;
-(NSString*)sectionIdentifierForItem:(id<VeeSectionableProt>)item;

#pragma mark - SearchTableView

- (void)setSearchResults:(NSArray<id<VeeSectionableProt> >*)searchResults forSearchTableView:(UITableView*)searchTableView;

@end

NS_ASSUME_NONNULL_END
