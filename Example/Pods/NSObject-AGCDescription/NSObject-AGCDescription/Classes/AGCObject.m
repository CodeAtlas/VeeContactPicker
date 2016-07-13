#import "AGCObject.h"
#import "AGCObjectInCollection.h"
#import "AGCPropertyConstants.h"

@interface AGCObject ()

@property (nonatomic, strong, nullable) NSMutableArray<AGCObjectInCollection*>* childrenObjectsMutable;

@end

@implementation AGCObject

- (instancetype)initWithObject:(id)obj
{
    self = [super init];
    if (!self) {
        return nil;
    }

    _obj = obj;

    if ([self isCollection]) {
        [self initializeChildrenObjects];
    }
    return self;
}

#pragma mark - Public methods

- (BOOL)isCollection
{
    return [self isArray] || [self isSet] || [self isOrderedSet] || [self isDictionary];
}

- (BOOL)isEnumerableForObjects
{
    return [self isArray] || [self isSet] || [self isOrderedSet];
}

- (BOOL)isEnumerableForObjectsAndKeys
{
    return [self isDictionary];
}

- (BOOL)isArray
{
    if ([self.obj isKindOfClass:NSArray.class]) {
        return YES;
    }
    return NO;
}

- (BOOL)isSet
{
    if ([self.obj isKindOfClass:NSSet.class]) {
        return YES;
    }
    return NO;
}

- (BOOL)isOrderedSet
{
    if ([self.obj isKindOfClass:NSOrderedSet.class]) {
        return YES;
    }
    return NO;
}

- (BOOL)isDictionary
{
    if ([self.obj isKindOfClass:NSDictionary.class]) {
        return YES;
    }
    return NO;
}

#pragma mark - Children objects

- (void)initializeChildrenObjects
{
    _childrenObjectsMutable = [NSMutableArray new];
    if ([self isEnumerableForObjects]) {
        [self initializeChildrenArrayObjects];
    }
    else if ([self isEnumerableForObjectsAndKeys]) {
        [self initializeChildrenDictObjects];
    }
}

- (void)initializeChildrenArrayObjects
{
    [self.obj enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL* _Nonnull stop) {
        AGCObjectInCollection* agcObjectInCollection = [[AGCObjectInCollection alloc] initWithObject:obj];
        [_childrenObjectsMutable addObject:agcObjectInCollection];
    }];
}

- (void)initializeChildrenDictObjects
{
    [self.obj enumerateKeysAndObjectsUsingBlock:^(id _Nonnull key, id _Nonnull obj, BOOL* _Nonnull stop) {
        AGCObjectInCollection* agcObjectInCollection = [[AGCObjectInCollection alloc] initWithKey:key andObject:obj];
        [_childrenObjectsMutable addObject:agcObjectInCollection];
    }];
}

- (NSArray<AGCObjectInCollection*>*)childrenObjects
{
    return [self.childrenObjectsMutable copy];
}

@end
