//
//  Created by Andrea Cipriani on 11/05/16.
//

#import "AGCPropertyProt.h"
#import <Foundation/Foundation.h>

@interface AGCPropertiesExtractor : NSObject

- (nullable instancetype)initWithTargetObject:(nonnull id)targetObj;

NS_ASSUME_NONNULL_BEGIN

- (NSArray<id<AGCPropertyProt>>*)extractSortedProperties;

NS_ASSUME_NONNULL_END

@end
