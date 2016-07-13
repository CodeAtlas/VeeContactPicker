//
//  Created by Andrea Cipriani on 25/04/16.
//

#import "AGCPropertyProt.h"
#import <Foundation/Foundation.h>
#import "AGCObject.h"

@interface AGCProperty : AGCObject <AGCPropertyProt>

- (nullable instancetype)initWithName:(nonnull NSString*)name value:(nullable id)value andAttributes:(nonnull NSString*)attributes;

NS_ASSUME_NONNULL_BEGIN

@property (nonatomic, copy) NSString* propertyName;
@property (nonatomic, copy) NSString* propertyAttributes;

#pragma mark - Public methods

- (NSString*)propertyType;
- (BOOL)isObject;
- (BOOL)isPrimitive;
- (BOOL)isChar;

NS_ASSUME_NONNULL_END

@end
