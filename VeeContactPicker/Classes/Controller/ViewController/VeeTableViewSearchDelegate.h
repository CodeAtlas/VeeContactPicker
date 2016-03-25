//
//  Created by Andrea Cipriani on 25/03/16.
//  Copyright © 2016 Code Atlas SRL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VeeSearchResultsDelegate.h"
@import UIKit;

@interface VeeTableViewSearchDelegate : NSObject <UISearchDisplayDelegate>

-(instancetype)initWithSearchDisplayController:(UISearchDisplayController*)searchDisplayController dataToFiler:(NSArray*)dataToFiler withPredicate:(NSPredicate*)filterPredicate andSearchResultsDelegate:(id<VeeSearchResultsDelegate>)searchResultsDelegate;

@end
