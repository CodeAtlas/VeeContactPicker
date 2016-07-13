//
//  Created by Andrea Cipriani on 30/06/16.
//

#import <Foundation/Foundation.h>
#import "AGCObject.h"

@interface AGCObjectDescription : NSObject

- (nullable instancetype)initWithAGCObject:(nonnull AGCObject*)agcObject;

NS_ASSUME_NONNULL_BEGIN

@property (nonatomic, strong, readonly) AGCObject * agcObject;
- (BOOL)isStandardObjectWithCustomDescription;
- (NSString*)agcCustomDescriptionOfStandardObject;
- (NSString*)agcDescription;

NS_ASSUME_NONNULL_END

@end
