//
//  Created by Andrea Cipriani on 21/12/15.
//  Copyright © 2015 Code Atlas SRL. All rights reserved.
//

#import "VeeContactProt.h"
#import <Foundation/Foundation.h>

@protocol VeeContactPickerDelegate <NSObject>

@required

- (void)didSelectABContact:(id<VeeContactProt>)abContact;
- (void)didCancelABContactSelection;
- (void)didFailToAccessABContacts;

@end
