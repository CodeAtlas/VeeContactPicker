//
//  Created by Andrea Cipriani on 25/04/16.
//

#import "AGCProperty.h"
#import "AGCPropertyConstants.h"
#import "AGCObjectInCollection.h"

@interface AGCProperty ()


@end

@implementation AGCProperty

- (nullable instancetype)initWithName:(nonnull NSString*)name value:(nullable id)value andAttributes:(nonnull NSString*)attributes
{
    self = [super init];
    if (!self) {
        return nil;
    }

    _propertyName = name;
    _propertyAttributes = attributes;
    super.obj = value;
    return self;
}

#pragma mark - Public methods

- (NSString*)propertyType
{
    NSString* propertyType;
    if (self.propertyAttributes) {
        propertyType = [self.propertyAttributes substringWithRange:NSMakeRange(1, 1)];
    }
    else {
        const char* propertyTypeChar = @encode(typeof(self.obj));
        propertyType = [NSString stringWithFormat:@"%s", propertyTypeChar];
    }
    return propertyType;
}

- (BOOL)isObject
{
    NSString* propertyType = [self propertyType];
    if ([propertyType isEqualToString:@"@"]) {
        return YES;
    }
    return NO;
}

- (BOOL)isPrimitive
{
    NSString* propertyType = [self propertyType];
    NSArray* primitiveTypes = @[ @"c", @"d", @"i", @"f", @"l", @"w", @"q", @"b", @"s" ];
    NSArray* primitiveTypesUppercase = [primitiveTypes valueForKey:@"uppercaseString"];
    if ([primitiveTypes containsObject:propertyType] || [primitiveTypesUppercase containsObject:propertyType]) {
        return YES;
    }
    return NO;
}

- (BOOL)isChar
{
    NSString* propertyType = [self propertyType];
    if ([propertyType isEqualToString:@"c"] || [propertyType isEqualToString:@"C"]) {
        return YES;
    }
    return NO;
}

@end
