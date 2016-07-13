//
//  Created by Andrea Cipriani on 11/05/16.
//

#import <Foundation/Foundation.h>
@class AGCPropertiesExtractor;
@interface AGCDescription : NSObject

- (nullable instancetype)initWithTargetObject:(nonnull id)targetObject;
- (nullable instancetype)initWithTargetObject:(nonnull id)targetObject andPropertyNamesToIgnore:(nullable NSArray*)propertyNamesToIgnore;

@end
