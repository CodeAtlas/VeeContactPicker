#import "NSObject+VeeCommons.h"

NS_ASSUME_NONNULL_BEGIN

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
    if (array == nil || array.count == 0) {
        return @"[]";
    }
    NSMutableString* arrayDescriptionMutable = [[NSMutableString alloc] initWithString:@"["];
    for (id obj in array) {
        [arrayDescriptionMutable appendString:[NSString stringWithFormat:@"%@", [obj description]]];
        BOOL isNotLastObject = [obj isEqual:array.lastObject] == NO;
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

NS_ASSUME_NONNULL_END
