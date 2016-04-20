//
//  Created by Andrea Cipriani on 05/01/16.
//  Copyright © 2016 Code Atlas SRL. All rights reserved.
//

#import "UILabel+VeeBoldify.h"

@implementation UILabel (VeeBoldify)

- (void)vee_boldRange:(NSRange)range
{
    if (![self respondsToSelector:@selector(setAttributedText:)]) {
        return;
    }
    NSMutableAttributedString* attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    [attributedText setAttributes:@{ NSFontAttributeName : [UIFont boldSystemFontOfSize:self.font.pointSize] } range:range];
    self.attributedText = attributedText;
}

- (void)vee_boldSubstring:(NSString*)substring
{
    NSRange range = [self.text rangeOfString:substring];
    [self vee_boldRange:range];
}

@end
