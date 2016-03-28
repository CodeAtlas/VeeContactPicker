//
//  Created by Andrea Cipriani on 28/03/16.
//  Copyright © 2016 Code Atlas SRL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VeeContactProt.h"
@class VeeContactUITableViewCell;
@class VeeContactPickerOptions;

@interface VeeContactCellConfiguration : NSObject

#pragma mark - Initializers

- (instancetype)initWithVeePickerOptions:(VeeContactPickerOptions*)veeContactPickerOptions;

#pragma mark - Public Methods

- (void)configureCell:(VeeContactUITableViewCell*)veeContactUITableViewCell forVeeContact:(id<VeeContactProt>)veeContact;

@end
