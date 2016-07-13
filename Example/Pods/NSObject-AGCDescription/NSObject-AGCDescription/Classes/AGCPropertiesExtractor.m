//
//  Created by Andrea Cipriani on 11/05/16.
//

#import "AGCPropertiesExtractor.h"
#import <objc/runtime.h>
#import "AGCPropertyConstants.h"
#import "AGCProperty.h"

@interface AGCPropertiesExtractor ()

@property (nonatomic, strong) id targetObject;
@property (nonatomic, strong) NSMutableArray<id<AGCPropertyProt>> * sortedPropertiesMutable;

@end

@implementation AGCPropertiesExtractor

- (instancetype)initWithTargetObject:(id)targetObj
{
    self = [super init];
    if (!self) {
        return nil;
    }
    _targetObject = targetObj;
    [self extractSortedProperties];
    return self;
}

- (NSArray<id<AGCPropertyProt> >*)extractSortedProperties
{
    self.sortedPropertiesMutable = [NSMutableArray new];
    
    unsigned int outCount, i;
    objc_property_t* properties = class_copyPropertyList([self.targetObject class], &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString* propertyName = [NSString stringWithUTF8String:property_getName(property)];
        NSString* propertyAttributes = [NSString stringWithUTF8String:property_getAttributes(property)];
        id propertyValue = [self.targetObject valueForKey:propertyName];
        AGCProperty* agcProperty = [[AGCProperty alloc] initWithName:propertyName value:propertyValue andAttributes:propertyAttributes];
        [self.sortedPropertiesMutable addObject:agcProperty];
    }
    if (properties) {
        free(properties);
    }
    return [self.sortedPropertiesMutable copy];
}

@end
