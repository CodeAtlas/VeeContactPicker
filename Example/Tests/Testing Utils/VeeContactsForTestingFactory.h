//
//  Created by Andrea Cipriani on 16/03/16.
//  Copyright © 2016 Code Atlas SRL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VeeContactProt.h"
@class VeeContact;

@interface VeeContactsForTestingFactory : NSObject

+ (VeeContact*)veeContactComplete;
+ (NSArray<id<VeeContactProt>>*)createRandomVeeContacts:(NSUInteger)numberOfVeeContacts;

@end
