//
//  Created by Andrea Cipriani on 30/06/16.
//

#import "AGCObjectDescription.h"
#import "AGCObjectInCollectionDescription.h"
#import "AGCPropertyConstants.h"
#import "AGCPropertyDescription.h"

@interface AGCPropertyDescription ()

@property (nonatomic, strong) AGCProperty* property ;

@end

@implementation AGCPropertyDescription

- (nullable instancetype)initWithProperty:(AGCProperty*)property
{
    AGCObject* agcObject = [[AGCObject alloc] initWithObject:[property obj]];
    self = [super initWithAGCObject:agcObject];
    if (!self) {
        return nil;
    }
    _property = property;
    return self;
}

#pragma mark - Public methods

- (nonnull NSString*)agcDescription
{
    if ([self.property isPrimitive]) {
        return [self agcDescriptionOfPrimitives];
    }
    return [super agcDescription];
}

#pragma mark - Primitives description

- (NSString*)agcDescriptionOfPrimitives
{
    if ([self.property isChar]) {
        return [self agcCharDescription];
    }
    return [self.property obj];
}

- (NSString*)agcCharDescription
{
    id propertyValue = self.property.obj;

    if ([propertyValue respondsToSelector:@selector(charValue)] == NO) {
        return propertyValue;
    }
    if ([propertyValue integerValue] == 1 || [propertyValue integerValue] == 0) {
        return [propertyValue stringValue]; //Fix for iPad2 iOS 8.4 for BOOL values, otherwise it returns a nil string
    }
    NSString* stringWithChar = [NSString stringWithFormat:@"%c", [propertyValue charValue]];
    return stringWithChar;
}

@end