//
//  Created by Andrea Cipriani on 29/03/16.
//  Copyright © 2016 Code Atlas SRL. All rights reserved.
//

#import "VeePostalAddress.h"

@implementation VeePostalAddress

-(instancetype)initWithStreet:(NSString*)street city:(NSString*)city state:(NSString*)state postal:(NSString*)postal country:(NSString*)country
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _street = street;
    _city = city;
    _state = state;
    _postal = postal;
    _country = country;
    return self;
}

#pragma mark - Public methods

-(NSString*)unifiedAddress
{
    NSString* unifiedAddress = @"";
    NSArray* sortedAddressProperties = [self sortedAddressProperties];
    
    for (int i = 0; i < [sortedAddressProperties count]; i++) {
        unifiedAddress = [unifiedAddress stringByAppendingString:[sortedAddressProperties objectAtIndex:i]];
        if (i != [sortedAddressProperties count] - 1) {
            unifiedAddress = [unifiedAddress stringByAppendingString:@", "];
        }
    }
    return unifiedAddress;
}

#pragma mark - Private utils

-(NSArray*)sortedAddressProperties
{
    NSMutableArray* sortedAddressPropertiesMutable = [NSMutableArray new];
    
    if (_street) {
        [sortedAddressPropertiesMutable addObject:_street];
    }
    if (_city) {
        [sortedAddressPropertiesMutable addObject:_city];
    }
    if (_state) {
        [sortedAddressPropertiesMutable addObject:_state];
    }
    if (_postal) {
        [sortedAddressPropertiesMutable addObject:_postal];
    }
    if (_country) {
        [sortedAddressPropertiesMutable addObject:_country];
    }
    return [NSArray arrayWithArray:sortedAddressPropertiesMutable];
}

#pragma mark - NSObject

-(NSString*)description
{
    return [self unifiedAddress];
}

@end
