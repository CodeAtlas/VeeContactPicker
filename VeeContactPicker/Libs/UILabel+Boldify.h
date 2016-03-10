//
//  UILabel+Boldify.h
//  VeeContactPicker
//
//  Created by Andrea Cipriani on 05/01/16.
//  Copyright © 2016 Code Atlas SRL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Boldify)

- (void)boldSubstring:(NSString*)substring;
- (void)boldRange:(NSRange)range;

@end
