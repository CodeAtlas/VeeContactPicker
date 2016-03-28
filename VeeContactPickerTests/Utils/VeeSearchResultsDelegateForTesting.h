//
//  Created by Andrea Cipriani on 28/03/16.
//  Copyright © 2016 Code Atlas SRL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VeeSearchResultsDelegate.h"

@interface VeeSearchResultsDelegateForTesting : NSObject <VeeSearchResultsDelegate>

-(instancetype)initWithSearchResults:(NSArray*)searchResults;

@property (nonatomic,strong) NSArray* searchResults;

-(void)handleSearchResults:(NSArray*)searchResults forSearchTableView:(UITableView*)searchTableView;

@end
