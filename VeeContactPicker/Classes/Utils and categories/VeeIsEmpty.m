//
//  Created by Andrea Cipriani on 21/03/16.
//  Copyright © 2016 Code Atlas SRL. All rights reserved.
//

#import "VeeIsEmpty.h"

@implementation VeeIsEmpty

+(BOOL)isEmpty:(id) obj
{
return obj == nil
    || [obj isKindOfClass:[NSNull class]]
    || ([obj respondsToSelector:@selector(length)]
        && [obj length] == 0)
    || ([obj respondsToSelector:@selector(count)]
        && [obj count] == 0);
}

+(BOOL)isNotEmpty:(id)obj
{
    return [self isEmpty:obj] == NO;
}
@end
