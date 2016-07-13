//
//  Created by Andrea Cipriani on 30/06/16.
//

#import "AGCObjectInCollectionDescription.h"

@interface AGCObjectInCollectionDescription ()

@end

@implementation AGCObjectInCollectionDescription

- (nullable instancetype)initWithObjectInCollection:(AGCObjectInCollection*)objectInCollection
{
    self = [super initWithAGCObject:objectInCollection];
    if (!self) {
        return nil;
    }
    return self;
}

#pragma mark - Public methods

- (nonnull NSString*)agcDescription
{
    if ([self.agcObject isCollection]) {
        return [self agcCollectionShortDescription];
    }
    return [super agcDescription];
}

#pragma mark - Short descriptions

-(NSString*)agcCollectionShortDescription
{
    if ([self.agcObject isArray]){
        return [self agcArrayShortDescription];
    }
    if ([self.agcObject isSet] || [self.agcObject isOrderedSet]){
        return [self agcSetShortDescription];
    }
    
    if ([self.agcObject isDictionary]){
        return [self agcDictionaryShortDescription];
    }
    
    NSLog(@"Warning - short description called on unknown collection %@", [self.agcObject.obj class]);
    return self.agcObject.obj;
}

- (NSString*)agcArrayShortDescription
{
    NSString* className;
    if ([self.agcObject.obj isKindOfClass:[NSMutableArray class]]) {
        className = @"NSMutableArray";
    }
    else {
        className = @"NSArray";
    }
    return [NSString stringWithFormat:@"<%@: %p, count = %zd>", className, self.agcObject.obj, [self.agcObject.obj count]];
}

- (NSString*)agcSetShortDescription
{
    NSString* className;
    if ([self.agcObject.obj isKindOfClass:[NSMutableSet class]]) {
        className = @"NSMutableSet";
    }
    else if ([self.agcObject.obj isKindOfClass:[NSSet class]]) {
        className = @"NSSet";
    }
    else if ([self.agcObject.obj isKindOfClass:[NSMutableOrderedSet class]]) {
        className = @"NSMutableOrderedSet";
    }
    else if ([self.agcObject.obj isKindOfClass:[NSOrderedSet class]]) {
        className = @"NSOrderedSet";
    }
    
    return [NSString stringWithFormat:@"<%@: %p, count = %zd>", className, self.agcObject.obj, [[self.agcObject.obj allObjects] count]];
}

- (NSString*)agcDictionaryShortDescription
{
    NSString* className;
    if ([self.agcObject.obj isKindOfClass:[NSMutableDictionary class]]) {
        className = @"NSMutableDictionary";
    }
    else {
        className = @"NSDictionary";
    }
    return [NSString stringWithFormat:@"<%@: %p, count = %zd>", className, self.agcObject.obj, [[self.agcObject.obj allObjects] count]];
}

@end
