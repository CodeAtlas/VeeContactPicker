//
//  VeeContactColor.m
//  VeeContactPicker
//
//  Created by Andrea Cipriani on 14/03/16.
//  Copyright © 2016 Code Atlas SRL. All rights reserved.
//

#import "VeeContactColor.h"
@interface VeeContactColor ()

@property (nonatomic, strong) NSMutableDictionary<NSString*, UIColor*>* colorsCache;

@end

@implementation VeeContactColor

#pragma mark - UIImage+Letters colors helper

- (UIColor*)colorForVeeContact:(id<VeeContactProt>)veeContact
{
    NSString* contactIdentifier = [veeContact compositeName];
    if (contactIdentifier == nil){
        return [UIColor lightGrayColor];
    }
    if (!_veecontactColorsPalette) {
        return [UIColor lightGrayColor];
    }
    if (!_colorsCache) {
        _colorsCache = (NSMutableDictionary<NSString*, UIColor*>*)[NSMutableDictionary new];
    }
    if ([_colorsCache objectForKey:contactIdentifier]) {
        return [_colorsCache objectForKey:contactIdentifier];
    }
    
    unsigned long hashNumber = djb2StringToLong((unsigned char*)[contactIdentifier UTF8String]);
    UIColor* color = _veecontactColorsPalette[hashNumber % [_veecontactColorsPalette count]];
    [_colorsCache setObject:color forKey:contactIdentifier];
    return color;
}

/*http://www.cse.yorku.ca/~oz/hash.html djb2 algorithm to generate an unsigned long hash from a given string */
unsigned long djb2StringToLong(unsigned char* str)
{
    unsigned long hash = 5381;
    int c;
    
    while ((c = *str++))
        hash = ((hash << 5) + hash) + c; /* hash * 33 + c */
    
    return hash;
}

@end
