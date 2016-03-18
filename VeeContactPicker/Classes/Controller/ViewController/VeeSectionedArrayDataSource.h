//
//  Created by Andrea Cipriani on 18/03/16.
//  Copyright © 2015 Code Atlas SRL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VeeSectionable.h"
@import UIKit;

@interface VeeSectionedArrayDataSource : NSObject <UITableViewDataSource>

typedef void (^ConfigureCellBlock)(id cell, id item);

-(instancetype)initWithItems:(NSArray<id<VeeSectionable>>*)items cellIdentifier:(NSString*)cellIdentifier allowedSectionIdentifiers:(NSArray<NSString*>*)allowedSectionIdentifiers sectionIdentifierWildcard:(NSString*)sectionIdentifierWildcard configurationCellBlock:(ConfigureCellBlock)block;

-(void)setSearchResults:(NSArray<id<VeeSectionable>>*)searchResults forSearchTableView:(UITableView*)searchTableView;

#pragma mark - Public items

-(id)tableView:(UITableView*)tableView itemAtIndexPath:(NSIndexPath*)indexPath;

@end
