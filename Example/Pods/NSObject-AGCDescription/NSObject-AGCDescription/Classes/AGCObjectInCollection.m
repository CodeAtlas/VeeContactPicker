//
//  Created by Andrea Cipriani on 30/06/16.
//

#import "AGCObjectInCollection.h"

@implementation AGCObjectInCollection

- (nullable instancetype)initWithKey:(nonnull id)key andObject:(nonnull id)object
{
    self = [super initWithObject:object];
    if (!self) {
        return nil;
    }
    _objectKey = key;
    return self;
}

@end