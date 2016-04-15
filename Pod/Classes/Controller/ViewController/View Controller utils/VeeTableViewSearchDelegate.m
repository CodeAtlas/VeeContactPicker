//
//  Created by Andrea Cipriani on 25/03/16.
//  Copyright © 2016 Code Atlas SRL. All rights reserved.
//

#import "VeeTableViewSearchDelegate.h"

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
    [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    return YES;
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController*)controller
{
    [_searchResultsDelegate handleSearchResults:nil forSearchTableView:self.searchDisplayController.searchResultsTableView];
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    [_searchResultsDelegate handleSearchResults:[self searchResultsForText:searchText] forSearchTableView:self.searchDisplayController.searchResultsTableView];
}

- (NSArray*)searchResultsForText:(NSString*)searchText
{
    BOOL dataToFilterIsEmpty = ([_dataToFilter count] > 0 == NO);
    if (dataToFilterIsEmpty){
        return @[];
    }
    if ([searchText isEqualToString:@""]){
        return _dataToFilter;
    }
    
    NSDictionary *substitutionVariables = [NSDictionary dictionaryWithObject:searchText forKey:@"searchString"];
    NSPredicate* predicateWithSubstitution = [_filterPredicate predicateWithSubstitutionVariables:substitutionVariables];
    return [_dataToFilter filteredArrayUsingPredicate:predicateWithSubstitution];
}

@end
