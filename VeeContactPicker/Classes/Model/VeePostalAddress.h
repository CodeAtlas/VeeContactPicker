//
//  Created by Andrea Cipriani on 29/03/16.
//  Copyright © 2016 Code Atlas SRL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VeePostalAddressProt.h"

@interface VeePostalAddress : NSObject <VeePostalAddressProt>

-(instancetype)initWithStreet:(NSString*)street city:(NSString*)city state:(NSString*)state postal:(NSString*)postal country:(NSString*)country;

@property (nonatomic, copy) NSString * street;
@property (nonatomic, copy) NSString * city;
@property (nonatomic, copy) NSString * state;
@property (nonatomic, copy) NSString * postal;
@property (nonatomic, copy) NSString * country;

-(NSString*)unifiedAddress;

@end
