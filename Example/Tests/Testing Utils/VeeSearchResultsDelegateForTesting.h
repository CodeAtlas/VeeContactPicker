#import <Foundation/Foundation.h>
#import "VeeSearchResultsDelegate.h"

@interface VeeSearchResultsDelegateForTesting : NSObject <VeeSearchResultsDelegate>

- (instancetype)init NS_UNAVAILABLE;
-(instancetype)initWithSearchResults:(NSArray*)searchResults;

@property (nonatomic,strong) NSArray* searchResults;

-(void)handleSearchResults:(NSArray*)searchResults forSearchTableView:(UITableView*)searchTableView;

@end
