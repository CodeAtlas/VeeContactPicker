//
//  Created by Andrea Cipriani on 14/03/16.
//  Copyright © 2016 Code Atlas SRL. All rights reserved.
//

#import "VeeContactPickerOptions.h"
#import "VeeContactPickerStrings.h"

@implementation VeeContactPickerOptions

#pragma mark - Init

- (instancetype)init
{
    self = [self initWithDefaultOptions];
    return self;
}

- (instancetype)initWithDefaultOptions
{
    if (self = [super init]) {
        _veeContactPickerStrings = [VeeContactPickerStrings defaultStrings];
        _sectionIdentifiers = [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles];
        _sectionIdentifierWildcard = @"#";
        _showInitialsPlaceholder = YES;
        _contactThumbnailImagePlaceholder = nil;
    }
    return self;
}

+ (VeeContactPickerOptions*)defaultOptions
{
    VeeContactPickerOptions* veeContactPickerOptions = [[self alloc] initWithDefaultOptions];
    return veeContactPickerOptions;
}

@end
