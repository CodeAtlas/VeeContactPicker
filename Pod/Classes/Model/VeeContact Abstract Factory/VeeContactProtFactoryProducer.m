#import "VeeContactProtFactoryProducer.h"
#import "VeeContactFactory.h"

@implementation VeeContactProtFactoryProducer

+ (id<VeeContactFactoryProt>)veeContactProtFactory
{
    VeeContactFactory* veeContactFactory = [VeeContactFactory new];
    return veeContactFactory;
}

@end
