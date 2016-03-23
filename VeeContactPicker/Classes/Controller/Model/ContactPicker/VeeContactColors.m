//
//  Created by Andrea Cipriani on 14/03/16.
//  Copyright © 2016 Code Atlas SRL. All rights reserved.
//

#import "VeeContactColors.h"
@interface VeeContactColors ()

@property (nonatomic, strong) NSMutableDictionary<NSString*, UIColor*>* colorsCache;

@end

static VeeContactColors* veeContactColorsWithDefaultPalette;

@implementation VeeContactColors

-(instancetype)init
{
    return [self initWithVeeContactsDefaultColorPalette];
}

-(instancetype)initWithVeeContactsDefaultColorPalette
{
    if (self = [super init]){
        _veecontactColorsPalette = [self defaultColors];
    }
    return self;
}

- (instancetype)initWithVeeContactsColorPalette:(NSArray<UIColor*>*)colorPalette
{
    self = [super init];
    if (self) {
        _veecontactColorsPalette = colorPalette;
    }
    return self;
}

+(VeeContactColors*)colorsWithDefaultPalette
{
    if (!veeContactColorsWithDefaultPalette){
        veeContactColorsWithDefaultPalette = [[VeeContactColors alloc] initWithVeeContactsDefaultColorPalette];
    }
    return veeContactColorsWithDefaultPalette;
}

#pragma mark - Public methods

- (UIColor*)colorForVeeContact:(id<VeeContactProt>)veeContact
{
    NSString* contactIdentifier = [veeContact compositeName];
    if (contactIdentifier == nil){
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

#pragma mark - Private methods

/*http://www.cse.yorku.ca/~oz/hash.html djb2 algorithm to generate an unsigned long hash from a given string */
unsigned long djb2StringToLong(unsigned char* str)
{
    unsigned long hash = 5381;
    int c;
    
    while ((c = *str++))
        hash = ((hash << 5) + hash) + c;
    
    return hash;
}

-(NSArray<UIColor*>*)defaultColors
{
    NSMutableArray<UIColor*>* defaultColors = [NSMutableArray array];
    for (float hue = 0.0; hue < 1.0; hue += 0.05) {
        UIColor *color = [UIColor colorWithHue:hue saturation:0.5 brightness:0.5 alpha:1.0];
        [defaultColors addObject:color];
    }
    return defaultColors;
}

@end
