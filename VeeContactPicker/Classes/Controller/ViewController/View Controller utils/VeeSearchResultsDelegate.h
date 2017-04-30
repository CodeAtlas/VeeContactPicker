@import Foundation;
@import UIKit;

NS_ASSUME_NONNULL_BEGIN

@protocol VeeSearchResultsDelegate <NSObject>
-(void)handleSearchResults:(NSArray*)searchResults forSearchTableView:(UITableView*)searchTableView;
@end

NS_ASSUME_NONNULL_END
