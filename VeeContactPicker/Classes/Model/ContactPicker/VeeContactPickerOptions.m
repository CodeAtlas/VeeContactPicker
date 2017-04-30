#import "VeeContactPickerOptions.h"
#import "VeeContactPickerStrings.h"

NS_ASSUME_NONNULL_BEGIN

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
        _sectionIdentifiers = [UILocalizedIndexedCollation currentCollation].sectionIndexTitles;
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

NS_ASSUME_NONNULL_END
