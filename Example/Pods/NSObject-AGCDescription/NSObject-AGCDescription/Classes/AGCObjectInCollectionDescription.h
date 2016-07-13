//
//  Created by Andrea Cipriani on 30/06/16.
//

#import <Foundation/Foundation.h>
#import "AGCObjectInCollection.h"
#import "AGCObjectDescription.h"

@interface AGCObjectInCollectionDescription : AGCObjectDescription

- (nullable instancetype)initWithObjectInCollection:(nonnull AGCObjectInCollection*)objectInCollection;
- (nonnull NSString*)agcDescription;

@end
