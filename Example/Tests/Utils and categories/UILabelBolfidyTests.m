//
//  Created by Andrea Cipriani on 29/03/16.
//  Copyright © 2016 Code Atlas SRL. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "UILabel+VeeBoldify.h"
@interface UILabelBolfidyTests : XCTestCase

@end

@implementation UILabelBolfidyTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

-(void)testBoldSubString
{
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    NSString* completeString = @"foo bar";
    NSString* shouldNotBeBoldSubstring = @"foo ";
    NSString* shouldBeBoldSubstring = @"bar";
    label.text = completeString;
    [label vee_boldSubstring:shouldBeBoldSubstring];

    BOOL shouldBeBold = [self isLabelFontBold:label forSubstring:shouldBeBoldSubstring] == YES;
    BOOL shouldNotBeBold = [self isLabelFontBold:label forSubstring:shouldNotBeBoldSubstring] == NO;
    NSAssert(shouldBeBold, @"Substring should be bold");
    NSAssert(shouldNotBeBold, @"Substring should not be bold");
}

-(void)testBoldNonExistingSubString
{
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    label.text = @"foo bar";
    [label vee_boldSubstring:@"lol"];
    BOOL shouldNotBeBold = [self isLabelFontBold:label forSubstring:@"lol"] == NO;
    NSAssert(shouldNotBeBold, @"Substring should not be bold");
}

-(BOOL)isLabelFontBold:(UILabel*)label forSubstring:(NSString*)substring
{
    NSString* completeString = label.text;
    NSRange boldRange = [completeString rangeOfString:substring];
    return [self isLabelFontBold:label forRange:boldRange];
}

-(BOOL)isLabelFontBold:(UILabel*)label forRange:(NSRange)range
{
    NSAttributedString * attributedLabelText = label.attributedText;

    __block BOOL isRangeBold = NO;

    [attributedLabelText enumerateAttribute:NSFontAttributeName inRange:range options:0 usingBlock:^(UIFont *font, NSRange range, BOOL *stop) {
        if (font) {
            if ([self isFontBold:font]){
                isRangeBold = YES;
            }
        }
    }];
    
    return isRangeBold;
}

-(BOOL)isFontBold:(UIFont*)font
{
    UIFontDescriptor *fontDescriptor = font.fontDescriptor;
    UIFontDescriptorSymbolicTraits fontDescriptorSymbolicTraits = fontDescriptor.symbolicTraits;
    BOOL isBold = (fontDescriptorSymbolicTraits & UIFontDescriptorTraitBold) != 0;
    return isBold;
}

@end
