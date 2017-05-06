@import Foundation;
@import UIKit;
#import "VeeSearchResultsDelegate.h"

@interface VeeTableViewSearchDelegate : NSObject <UISearchDisplayDelegate>

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithSearchDisplayController:(UISearchDisplayController*)searchDisplayController dataToFiler:(NSArray*)dataToFiler withPredicate:(NSPredicate*)filterPredicate andSearchResultsDelegate:(id<VeeSearchResultsDelegate>)searchResultsDelegate;

#pragma mark - UISearchDisplayDelegate

- (BOOL)searchDisplayController:(UISearchDisplayController*)controller shouldReloadTableForSearchString:(NSString*)searchString;
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope;
- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController*)controller;

@end
