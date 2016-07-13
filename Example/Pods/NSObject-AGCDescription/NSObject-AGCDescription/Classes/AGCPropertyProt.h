//
//  Created by Andrea Cipriani on 30/06/16.
//

#import <Foundation/Foundation.h>

@protocol AGCPropertyProt <NSObject>

@property (nonatomic, strong, readonly, nullable) NSArray* childrenObjects;

NS_ASSUME_NONNULL_BEGIN

@property (nonatomic, copy) NSString* propertyName;
@property (nonatomic, copy) NSString* propertyAttributes;
@property (nonatomic, strong) id obj;

- (NSString*)propertyType;
- (BOOL)isObject;
- (BOOL)isPrimitive;
- (BOOL)isChar;

NS_ASSUME_NONNULL_END

@end
