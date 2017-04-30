#import "VeeContactProtFactoryProducer.h"
#import "VeeContactFactory.h"

NS_ASSUME_NONNULL_BEGIN

@implementation VeeContactProtFactoryProducer

+ (id<VeeContactFactoryProt>)veeContactProtFactory
{
    VeeContactFactory* veeContactFactory = [VeeContactFactory new];
    return veeContactFactory;
}

@end

NS_ASSUME_NONNULL_END
