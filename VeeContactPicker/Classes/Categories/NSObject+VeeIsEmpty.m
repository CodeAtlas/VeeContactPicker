//
//  NSObject+IsEmpty.m
//  VeeContactPicker
//
//  Created by Andrea Cipriani on 14/03/16.
//  Copyright © 2016 Code Atlas SRL. All rights reserved.
//

#import "NSObject+VeeIsEmpty.h"

@implementation NSObject (VeeIsEmpty)

-(BOOL)veeIsEmpty
{
    return self == nil
    || [self isKindOfClass:[NSNull class]]
    || ([self respondsToSelector:@selector(length)]
        && [(NSData *)self length] == 0)
    || ([self respondsToSelector:@selector(count)]
        && [(NSArray *)self count] == 0);
}

@end
