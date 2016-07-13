#import <Foundation/Foundation.h>
@class AGCObjectInCollection;

@interface AGCObject : NSObject

- (nullable instancetype)initWithObject:(nullable id)object;
@property (nonatomic, strong, readonly, nullable) NSArray<AGCObjectInCollection*>* childrenObjects;

NS_ASSUME_NONNULL_BEGIN

@property (nonatomic, strong) id obj;

- (BOOL)isCollection;
- (BOOL)isEnumerableForObjects;
- (BOOL)isEnumerableForObjectsAndKeys;
- (BOOL)isArray;
- (BOOL)isSet;
- (BOOL)isOrderedSet;
- (BOOL)isDictionary;

- (NSArray<AGCObjectInCollection*>*)childrenObjects;

NS_ASSUME_NONNULL_END

@end
