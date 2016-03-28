//
//  Created by Andrea Cipriani on 10/03/16.
//  Copyright © 2016 Code Atlas SRL. All rights reserved.
//

#import "XCTest+VeeCommons.h"

@implementation XCTest (VeeCommons)

-(void)nullifyIvarWithName:(NSString*)iVarSelectorName ofObject:(id)object
{
    [self assertObject:object respondToSelectorWithName:iVarSelectorName];
    [object setValue:nil forKey:iVarSelectorName];
}

-(void)assertObject:(id)object respondToSelectorWithName:(NSString*)selectorName
{
    SEL selector = NSSelectorFromString(selectorName);
    BOOL objectRespondToSelector = [object respondsToSelector:selector];
    NSAssert(objectRespondToSelector,@"%@ doesn't respond to selector %@",[object class],selectorName);
}

-(UIImage*)codeAtasTestImage
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *imagePath = [bundle pathForResource:@"codeatlas" ofType:@"png"];
    UIImage *codeAtlasImage = [UIImage imageWithContentsOfFile:imagePath];
    NSAssert(codeAtlasImage, @"codeatlas image not found");
    return codeAtlasImage;
}

@end
