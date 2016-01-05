//
//  UILabel+Boldify.m
//  VeeContactPicker
//
//  Created by Andrea Cipriani on 05/01/16.
//  Copyright © 2016 Code Atlas SRL. All rights reserved.
//

#import "UILabel+Boldify.h"

@implementation UILabel (Boldify)

- (void)boldRange:(NSRange)range
{
    if (![self respondsToSelector:@selector(setAttributedText:)]) {
        return;
    }
    NSMutableAttributedString* attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    [attributedText setAttributes:@{ NSFontAttributeName : [UIFont boldSystemFontOfSize:self.font.pointSize] } range:range];

    self.attributedText = attributedText;
}

- (void)boldSubstring:(NSString*)substring
{
    NSRange range = [self.text rangeOfString:substring];
    [self boldRange:range];
}

@end
