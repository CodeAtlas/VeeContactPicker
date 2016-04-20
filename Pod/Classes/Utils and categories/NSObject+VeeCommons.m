//
//  Created by Andrea Cipriani on 30/03/16.
//  Copyright © 2016 Code Atlas SRL. All rights reserved.
//

#import "NSObject+VeeCommons.h"

@implementation NSObject (VeeCommons)

- (NSString*)vee_formattedDescriptionOfProperty:(id)property
{
    if (property == nil){
        return @"nil";
    }
    return property;
}

- (NSString*)vee_formattedDescriptionOfArray:(NSArray*)array
{
    if (array == nil || [array count] == 0) {
        return @"[]";
    }
    NSMutableString* arrayDescriptionMutable = [[NSMutableString alloc] initWithString:@"["];
    for (id obj in array) {
        [arrayDescriptionMutable appendString:[NSString stringWithFormat:@"%@", [obj description]]];
        BOOL isNotLastObject = [obj isEqual:[array lastObject]] == NO;
        if (isNotLastObject) {
            [arrayDescriptionMutable appendString:@"; "];
        }
        else {
            [arrayDescriptionMutable appendString:@"]"];
        }
    }
    return [NSString stringWithString:arrayDescriptionMutable];
}

@end
