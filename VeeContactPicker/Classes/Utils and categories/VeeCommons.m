#import "VeeCommons.h"

NS_ASSUME_NONNULL_BEGIN

@implementation VeeCommons

+ (BOOL)vee_isEmpty:(id)obj
{
    return obj == nil
        || [obj isKindOfClass:[NSNull class]]
        || ([obj respondsToSelector:@selector(length)]
               && [obj length] == 0)
        || ([obj respondsToSelector:@selector(count)]
               && [obj count] == 0);
}

+ (BOOL)vee_isNotEmpty:(id)obj
{
    return [self vee_isEmpty:obj] == NO;
}

@end

NS_ASSUME_NONNULL_END
