//
//  VeeContactPickerDelegate.h
//  VeeContactPicker
//
//  Created by Andrea Cipriani on 21/12/15.
//  Copyright © 2015 Code Atlas SRL. All rights reserved.
//

#import "ABContactProt.h"
#import <Foundation/Foundation.h>

@protocol VeeContactPickerDelegate <NSObject>

@required

- (void)didSelectABContact:(id<ABContactProt>)abContact;

@end
