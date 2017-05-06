#import "VeeTableViewSearchDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface VeeTableViewSearchDelegate ()
@property (nonatomic,strong) UISearchDisplayController* searchDisplayController;
@property (nonatomic,strong) id<VeeSearchResultsDelegate> searchResultsDelegate;
@property (nonatomic,strong) NSPredicate* filterPredicate;
@property (nonatomic,strong) NSArray* dataToFilter;
@end

@implementation VeeTableViewSearchDelegate

#pragma mark - Initializers

-(instancetype)initWithSearchDisplayController:(UISearchDisplayController*)searchDisplayController dataToFiler:(NSArray*)dataToFiler withPredicate:(NSPredicate*)filterPredicate andSearchResultsDelegate:(id<VeeSearchResultsDelegate>)searchResultsDelegate
{
    self = [super init];
    if (self) {
        _searchDisplayController = searchDisplayController;
        _searchResultsDelegate = searchResultsDelegate;
        _filterPredicate = filterPredicate;
        _dataToFilter = dataToFiler;
    }
    return self;
}

#pragma mark - UISearchDisplayDelegate

- (BOOL)searchDisplayController:(UISearchDisplayController*)controller shouldReloadTableForSearchString:(NSString*)searchString
{
    [self filterContentForSearchText:searchString scope:(self.searchDisplayController.searchBar).scopeButtonTitles[(self.searchDisplayController.searchBar).selectedScopeButtonIndex]];
    return YES;
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController*)controller
{
    [self.searchResultsDelegate handleSearchResults:@[] forSearchTableView:self.searchDisplayController.searchResultsTableView];
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    [self.searchResultsDelegate handleSearchResults:[self searchResultsForText:searchText] forSearchTableView:self.searchDisplayController.searchResultsTableView];
}

- (NSArray*)searchResultsForText:(NSString*)searchText
{
    BOOL dataToFilterIsEmpty = ((self.dataToFilter).count > 0 == NO);
    if (dataToFilterIsEmpty){
        return @[];
    }
    if ([searchText isEqualToString:@""]){
        return self.dataToFilter;
    }
    
    NSDictionary *substitutionVariables = @{@"searchString": searchText};
    NSPredicate* predicateWithSubstitution = [self.filterPredicate predicateWithSubstitutionVariables:substitutionVariables];
    return [self.dataToFilter filteredArrayUsingPredicate:predicateWithSubstitution];
}

@end

NS_ASSUME_NONNULL_END
