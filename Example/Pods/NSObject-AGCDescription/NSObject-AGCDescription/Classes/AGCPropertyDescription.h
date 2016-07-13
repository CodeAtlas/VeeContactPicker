//
//  Created by Andrea Cipriani on 30/06/16.
//

#import "AGCProperty.h"
#import <Foundation/Foundation.h>
#import "AGCObjectDescription.h"

@interface AGCPropertyDescription : AGCObjectDescription

- (nullable instancetype)initWithProperty:(nonnull AGCProperty*)property;
- (nonnull NSString*)agcDescription;

@end
