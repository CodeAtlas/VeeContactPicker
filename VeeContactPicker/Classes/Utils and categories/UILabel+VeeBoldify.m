#import "UILabel+VeeBoldify.h"

NS_ASSUME_NONNULL_BEGIN

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

NS_ASSUME_NONNULL_END
