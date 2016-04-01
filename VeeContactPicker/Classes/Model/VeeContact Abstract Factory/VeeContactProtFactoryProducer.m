//
//  Created by Andrea Cipriani on 30/03/16.
//  Copyright © 2016 Code Atlas SRL. All rights reserved.
//

#import "VeeContactProtFactoryProducer.h"
#import "VeeContactFactory.h"

@implementation VeeContactProtFactoryProducer

+ (id<VeeContactFactoryProt>)veeContactProtFactory
{
    VeeContactFactory* veeContactFactory = [VeeContactFactory new];
    return veeContactFactory;
}

@end
