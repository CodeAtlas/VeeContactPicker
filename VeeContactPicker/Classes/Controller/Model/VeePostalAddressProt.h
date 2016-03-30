//
//  Created by Andrea Cipriani on 29/03/16.
//  Copyright © 2016 Code Atlas SRL. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol VeePostalAddressProt <NSObject>

- (NSString*)street;
- (NSString*)city;
- (NSString*)state;
- (NSString*)postal;
- (NSString*)country;
- (NSString*)unifiedAddress;

@end
