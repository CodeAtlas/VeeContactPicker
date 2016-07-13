//
//  Created by Andrea Cipriani on 30/06/16.
//

#import "AGCObjectDescription.h"
#import "AGCObjectInCollectionDescription.h"
#import "AGCPropertyConstants.h"

@implementation AGCObjectDescription

- (nullable instancetype)initWithAGCObject:(AGCObject*)agcObject
{
    self = [super init];
    if (!self) {
        return nil;
    }

    _agcObject = agcObject;
    return self;
}

#pragma mark - Public methods

-(BOOL)isStandardObjectWithShortDescription
{
    for (id class in [[AGCPropertyConstants sharedInstance] standardClassesWithShortDescription]) {
       if ([self.agcObject.obj isKindOfClass:class]) {
           return YES;
        }
            }
      return NO;
}

- (BOOL)isStandardObjectWithCustomDescription
{
    for (id classType in [[AGCPropertyConstants sharedInstance] standardClassesWithCustomDescription]) {
        if ([self.agcObject.obj isKindOfClass:classType]) {
            return YES;
        }
    }
    return NO;
}

- (NSString*)agcCustomDescriptionOfStandardObject
{
    id objectValue = self.agcObject.obj;
    if ([objectValue isKindOfClass:NSData.class]) {
        return [NSString stringWithFormat:@"<NSData: %p>, %zd bytes", objectValue, [objectValue length]];
    }
    if ([objectValue isKindOfClass:UIImage.class]) {
        return [NSString stringWithFormat:@"<UIImage: %p>, {%d, %d}", objectValue, (int)[objectValue size].width, (int)[objectValue size].height];
    }
    NSLog(@"Warning - custom description called on unhandled class: %@", [objectValue class]);
    return objectValue;
}

#pragma mark - AGCDescription

- (nonnull NSString*)agcDescription
{
    if (self.agcObject.obj == nil) {
        return @"nil";
    }
    if ([self isStandardObjectWithCustomDescription]) {
        return [self agcCustomDescriptionOfStandardObject];
    }
    if ([self.agcObject isCollection]) {
        return [self agcCollectionDescription];
    }
    if ([self isStandardObjectWithShortDescription]){
        return [self.agcObject.obj description];
    }

    return [self agcShortDescription];
}

#pragma mark - Short description

- (NSString*)agcShortDescription
{
    return [NSString stringWithFormat:@"<%@: %p>", NSStringFromClass([self.agcObject.obj class]), self.agcObject.obj];
}

#pragma mark - Collection description

- (NSString*)agcCollectionDescription
{
    if ([self.agcObject isEnumerableForObjects]) {
        return [self agcArrayDescription];
    }
    if ([self.agcObject isEnumerableForObjectsAndKeys]) {
        return [self agcDictionaryDescription];
    }
    NSLog(@"Warning - property is an unknown collection");
    return nil;
}

- (NSString*)agcArrayDescription
{
    NSMutableString* arrayDescription = [[NSMutableString alloc] initWithString:@"(\n"];
    [self.agcObject.childrenObjects enumerateObjectsUsingBlock:^(AGCObjectInCollection* _Nonnull objInCollection, NSUInteger idx, BOOL* _Nonnull stop) {
        AGCObjectInCollectionDescription* objInCollectionDescription = [[AGCObjectInCollectionDescription alloc] initWithObjectInCollection:objInCollection];
        [arrayDescription appendString:[NSString stringWithFormat:@"\t\t%@", [objInCollectionDescription agcDescription]]];
        BOOL isLastObjectOfCollection = idx == [self.agcObject.childrenObjects count] - 1;
        if (isLastObjectOfCollection) {
            [arrayDescription appendString:@"\n"];
        }
        else {
            [arrayDescription appendString:@",\n"];
        }
    }];
    [arrayDescription appendString:@"\t)"];
    return [arrayDescription copy];
}

- (NSString*)agcDictionaryDescription
{
    NSMutableString* dictDescription = [[NSMutableString alloc] initWithString:@"{\n"];
    [self.agcObject.childrenObjects enumerateObjectsUsingBlock:^(AGCObjectInCollection* _Nonnull objInCollection, NSUInteger idx, BOOL* _Nonnull stop) {
        AGCObjectInCollectionDescription* objInCollectionDescription = [[AGCObjectInCollectionDescription alloc] initWithObjectInCollection:objInCollection];
        [dictDescription appendString:[NSString stringWithFormat:@"\t\t%@ = %@", [objInCollection objectKey],[objInCollectionDescription agcDescription]]];
        BOOL isLastObjectOfCollection = idx == [self.agcObject.childrenObjects count] - 1;
        if (isLastObjectOfCollection) {
            [dictDescription appendString:@"\n"];
        }
        else {
            [dictDescription appendString:@",\n"];
        }
    }];
    [dictDescription appendString:@"\t}"];
    return [dictDescription copy];
}

@end
