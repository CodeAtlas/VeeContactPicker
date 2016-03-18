//  Created by Andrea Cipriani on 14/03/16.
//  Copyright © 2016 Code Atlas SRL. All rights reserved.
//

#import "VeeContactPickerOptions.h"
#import "VeeContactColors.h"
#import "VeeContactPickerStrings.h"

static VeeContactPickerOptions* defaultOptionsCached;

@implementation VeeContactPickerOptions

#pragma mark - Init

-(instancetype)init
{
    self = [self initWithDefaultOptions];
    return self;
}

- (instancetype)initWithDefaultOptions
{
    if (self = [super init]) {
        _veeContactColors = [VeeContactColors colorsWithDefaultPalette];
        _veeContactPickerStrings = [VeeContactPickerStrings defaultStrings];
        _sectionIdentifiers = [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles];
        _sectionIdentifierWildcard = @"#";
        _showLettersWhenContactImageIsMissing = YES;
        _contactThumbnailImagePlaceholder = nil;
    }
    return self;
}

+ (VeeContactPickerOptions*)defaultOptions
{
    if (!defaultOptionsCached) {
        defaultOptionsCached = [[self alloc] initWithDefaultOptions];
    }
    return defaultOptionsCached;
}

@end
