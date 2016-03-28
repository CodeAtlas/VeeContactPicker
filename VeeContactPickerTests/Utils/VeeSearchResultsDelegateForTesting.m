//
//  Created by Andrea Cipriani on 28/03/16.
//  Copyright © 2016 Code Atlas SRL. All rights reserved.
//

#import "VeeSearchResultsDelegateForTesting.h"

@implementation VeeSearchResultsDelegateForTesting

-(instancetype)initWithSearchResults:(NSArray*)searchResults
{
    self = [super init];
    if (self) {
        _searchResults = searchResults;
    }
    return self;
}

-(void)handleSearchResults:(NSArray*)searchResults forSearchTableView:(UITableView*)searchTableView
{
    _searchResults = searchResults;
}

@end
