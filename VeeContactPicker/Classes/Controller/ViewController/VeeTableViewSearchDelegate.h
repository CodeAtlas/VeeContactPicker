//
//  Created by Andrea Cipriani on 25/03/16.
//  Copyright © 2016 Code Atlas SRL. All rights reserved.
//

#import "VeeSearchResultsDelegate.h"
#import <Foundation/Foundation.h>
@import UIKit;

@interface VeeTableViewSearchDelegate : NSObject <UISearchDisplayDelegate>

- (instancetype)initWithSearchDisplayController:(UISearchDisplayController*)searchDisplayController dataToFiler:(NSArray*)dataToFiler withPredicate:(NSPredicate*)filterPredicate andSearchResultsDelegate:(id<VeeSearchResultsDelegate>)searchResultsDelegate;

#pragma mark - UISearchDisplayDelegate

- (BOOL)searchDisplayController:(UISearchDisplayController*)controller shouldReloadTableForSearchString:(NSString*)searchString;
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope;
- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController*)controller;

@end
