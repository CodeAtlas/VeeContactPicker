//
//  Created by Andrea Cipriani on 30/06/16.
//

#import "AGCObject.h"
#import <Foundation/Foundation.h>

@interface AGCObjectInCollection : AGCObject

- (nullable instancetype)initWithKey:(nonnull id)key andObject:(nonnull id)object;
@property (nonatomic, strong, nullable) id objectKey;

@end
