//
//  Created by Andrea Cipriani on 07/04/16.
//
//

#import "AGCInitialsColors.h"
#import "UIImageView+AGCInitials.h"

@implementation UIImageView (AGCInitials)

- (void)agc_setImageWithInitials:(nonnull NSString*)initials
{
    [self agc_setImageWithInitials:initials stringToGenerateColor:initials textAttributes:[self agc_defaultTextAttributes]];
}

- (void)agc_setImageWithInitials:(nonnull NSString*)initials andTextAttributes:(nonnull NSDictionary*)textAttributes
{
    [self agc_setImageWithInitials:initials stringToGenerateColor:initials textAttributes:textAttributes];
}

- (void)agc_setImageWithInitialsFromName:(nonnull NSString*)name
{
    NSString* initials = [self agc_initialsFromName:name separatedByString:@" "];
    [self agc_setImageWithInitials:initials stringToGenerateColor:name textAttributes:[self agc_defaultTextAttributes]];
}

- (void)agc_setImageWithInitialsFromName:(nonnull NSString*)name separatedByString:(nonnull NSString*)separator
{
    NSString* initials = [self agc_initialsFromName:name separatedByString:separator];
    [self agc_setImageWithInitials:initials stringToGenerateColor:name textAttributes:[self agc_defaultTextAttributes]];
}

- (void)agc_setImageWithInitialsFromName:(nonnull NSString*)name withTextAttributes:(nonnull NSDictionary*)textAttributes
{
    NSString* initials = [self agc_initialsFromName:name separatedByString:@" "];
    [self agc_setImageWithInitials:initials stringToGenerateColor:name textAttributes:textAttributes];
}

- (void)agc_setImageWithInitialsFromName:(nonnull NSString*)name separatedByString:(nonnull NSString*)separator withTextAttributes:(nonnull NSDictionary*)textAttributes
{
    NSString* initials = [self agc_initialsFromName:name separatedByString:separator];
    [self agc_setImageWithInitials:initials stringToGenerateColor:name textAttributes:textAttributes];
}

- (void)agc_setImageWithInitials:(nonnull NSString*)initials stringToGenerateColor:(nonnull NSString*)stringToGenerateColor textAttributes:(nonnull NSDictionary*)textAttributes
{
    NSString* uppercaseInitials = [initials uppercaseString];
    if ([stringToGenerateColor isEqualToString:initials]) {
        stringToGenerateColor = [stringToGenerateColor uppercaseString];
    }
    [self agc_setBackgroundColorForString:stringToGenerateColor];
    self.image = [self agc_imageWithInitials:uppercaseInitials withTextAttributes:textAttributes];
}

#pragma mark - Private

- (NSDictionary*)agc_defaultTextAttributes
{
    return @{ NSFontAttributeName : [UIFont systemFontOfSize:[self agc_fontSizeForImageViewSize]],
        NSForegroundColorAttributeName : [UIColor whiteColor] };
}

- (void)agc_setBackgroundColorForString:(NSString*)string
{
    UIColor* colorForString = [[AGCInitialsColors sharedInstance] colorForString:string];
    self.backgroundColor = colorForString;
}

- (NSString*)agc_initialsFromName:(NSString *)name separatedByString:(NSString *)separator
{
    NSArray* nameComponents = [name componentsSeparatedByString:separator];
    NSMutableArray* nameComponentsCleaned = [NSMutableArray new];
    for (NSString* nameComponent in nameComponents) {
        BOOL nameComponentIsNotValid = nameComponent == nil || [nameComponent length] == 0 || [nameComponent isEqualToString:separator] || [self agc_isStringComposedOnlyBySpacesOrNewLines:name];
        if (nameComponentIsNotValid) {
            continue;
        }
        [nameComponentsCleaned addObject:nameComponent];
    }

    BOOL nameComponentsCleanedIsEmpty = [nameComponentsCleaned count] < 1;
    if (nameComponentsCleanedIsEmpty) {
        return @"";
    }
    NSString* firstComponent = nameComponentsCleaned[0];
    NSString* firstInitial = [firstComponent substringToIndex:1];
    NSString* lastComponent = @"";
    NSString* lastInitial = @"";
    if ([nameComponentsCleaned count] > 1) {
        lastComponent = [nameComponentsCleaned lastObject];
        lastInitial = [lastComponent substringToIndex:1];
    }
    return [firstInitial stringByAppendingString:lastInitial];
}

- (BOOL)agc_isStringComposedOnlyBySpacesOrNewLines:(NSString*)string
{
    NSCharacterSet* whiteSpaceAndNewLinesSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    if ([[string stringByTrimmingCharactersInSet:whiteSpaceAndNewLinesSet] length] == 0) {
        return YES;
    }
    return NO;
}

- (UIImage*)agc_imageWithInitials:(NSString*)initials withTextAttributes:(NSDictionary*)textAttributes
{
    [self acg_beginImageContext];
    CGSize textSize = [initials sizeWithAttributes:textAttributes];
    [initials drawInRect:[self agc_initialsRectForTextSize:textSize] withAttributes:textAttributes];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    [self agc_endContext];
    return newImage;
}

- (CGFloat)agc_fontSizeForImageViewSize
{
    CGFloat scaleFactor = 0.4;
    CGFloat fontSize = [self agc_imageHeight] * scaleFactor;
    return fontSize;
}

- (CGContextRef)acg_beginImageContext
{
    UIGraphicsBeginImageContextWithOptions([self acg_imageSize], NO, 0);
    return UIGraphicsGetCurrentContext();
}

- (CGSize)acg_imageSize
{
    return self.bounds.size;
}

- (CGRect)agc_initialsRectForTextSize:(CGSize)textSize
{
    CGFloat x = [self agc_imageWidth] / 2 - textSize.width / 2;
    CGFloat y = [self agc_imageHeight] / 2 - textSize.height / 2;
    return CGRectMake(x, y, textSize.width, textSize.height);
}

- (CGFloat)agc_imageWidth
{
    return [self acg_imageSize].width;
}

- (CGFloat)agc_imageHeight
{
    return [self acg_imageSize].height;
}

- (void)agc_endContext
{
    UIGraphicsEndImageContext();
}

@end
