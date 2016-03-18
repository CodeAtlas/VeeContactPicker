//  Created by Andrea Cipriani on 14/03/16.
//  Copyright © 2016 Code Atlas SRL. All rights reserved.
//

#import "VeeContactPickerOptions.h"

static VeeContactPickerOptions* defaultOptionsCache;

@implementation VeeContactPickerOptions

#pragma mark - Init

- (instancetype)initWithDefaultOptions
{
    if (self = [super init]) {
        _sectionIdentifiers = [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles];
        _sectionIdentifierWildcard = @"#";
        _showLettersWhenContactImageIsMissing = YES;
    }
    return self;
}

- (instancetype)initWithSectionIdentifiers:(NSArray<NSString*>*)sectionIdentifiers andSectionIdentifierWildcard:(NSString*)sectionIdentifierWildcard andShowLettersWhenContactImageIsMissing:(BOOL)showLettersWhenContactImageIsMissing andContactThumbnailImagePlaceholder:(UIImage*)contactThumbnailImagePlaceholder
{
    if (self = [super init]) {
        _sectionIdentifiers = sectionIdentifiers;
        _sectionIdentifierWildcard = sectionIdentifierWildcard;
        _showLettersWhenContactImageIsMissing = showLettersWhenContactImageIsMissing;
        _contactThumbnailImagePlaceholder = contactThumbnailImagePlaceholder;
    }
    return self;
}

+ (VeeContactPickerOptions*)defaultOptions
{
    if (!defaultOptionsCache) {
        defaultOptionsCache = [[self alloc] initWithDefaultOptions];
    }
    return defaultOptionsCache;
}

@end
