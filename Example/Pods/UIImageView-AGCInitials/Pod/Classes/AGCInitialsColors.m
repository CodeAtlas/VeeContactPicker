//
//  Created by Andrea Cipriani on 07/04/16.
//
//

#import "AGCInitialsColors.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 blue:((float)(rgbValue & 0xFF)) / 255.0 alpha:1.0]

@interface AGCInitialsColors ()

@property (nonatomic, strong) NSMutableDictionary<NSString*, UIColor*>* cachedColorsForStrings;

@end

@implementation AGCInitialsColors

+ (id _Nonnull)sharedInstance
{
    static AGCInitialsColors* sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] initWithDefaultColorPalette];
    });
    return sharedInstance;
}

- (instancetype)initWithDefaultColorPalette
{
    self = [super init];
    if (!self) {
        return nil;
    }
    _colorPalette = [self defaultColorPalette];
    _cachedColorsForStrings = [NSMutableDictionary new];
    return self;
}

- (NSArray<UIColor*>*)defaultColorPalette
{
    return @[ UIColorFromRGB(0x6200EA), UIColorFromRGB(0xC51162), UIColorFromRGB(0x304FFE), UIColorFromRGB(0x2962FF), UIColorFromRGB(0x00BFA5), UIColorFromRGB(0xd50000), UIColorFromRGB(0x00C853), UIColorFromRGB(0x64DD17), UIColorFromRGB(0x00B8D4), UIColorFromRGB(0x827717), UIColorFromRGB(0xFFD600), UIColorFromRGB(0xDD2C00), UIColorFromRGB(0x37474F), UIColorFromRGB(0xBF360C), UIColorFromRGB(0x004D40), UIColorFromRGB(0xe53935), UIColorFromRGB(0x0091EA), UIColorFromRGB(0x607D8B), UIColorFromRGB(0xFF5722), UIColorFromRGB(0xFF9800), UIColorFromRGB(0xFFC107), UIColorFromRGB(0x8BC34A), UIColorFromRGB(0x4CAF50), UIColorFromRGB(0x009688), UIColorFromRGB(0x00BCD4), UIColorFromRGB(0x42A5F5), UIColorFromRGB(0x5C6BC0), UIColorFromRGB(0x673AB7), UIColorFromRGB(0xE91E63), UIColorFromRGB(0xf44336) ];
}

- (void)setPalette:(NSArray<UIColor*>*)colorPalette
{
    _colorPalette = colorPalette;
}

- (UIColor* _Nonnull)colorForString:(NSString*)string
{
    if (string == nil) {
        string = @"";
    }
    if ([self cachedColorForString:string]) {
        return [self cachedColorForString:string];
    }

    unsigned long hashNumber = agc_djb2StringToLong((unsigned char*)[string UTF8String]);
    UIColor* color = _colorPalette[hashNumber % [_colorPalette count]];
    _cachedColorsForStrings[string] = color;
    return color;
}

- (UIColor*)cachedColorForString:(NSString*)string
{
    return _cachedColorsForStrings[string];
}

/*
 http://www.cse.yorku.ca/~oz/hash.html djb2 algorithm to generate an unsigned long hash from a given string.
 Attention, it could return different values on different architectures for the same string
 */

unsigned long agc_djb2StringToLong(unsigned char* str)
{
    unsigned long hash = 5381;
    int c;
    while ((c = *str++)) {
        hash = ((hash << 5) + hash) + c;
    }
    return hash;
}

@end
