//
//  Created by Andrea Cipriani on 25/03/16.
//  Copyright © 2016 Code Atlas SRL. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@protocol VeeSearchResultsDelegate <NSObject>

-(void)handleSearchResults:(NSArray*)searchResults forSearchTableView:(UITableView*)searchTableView;

@end
