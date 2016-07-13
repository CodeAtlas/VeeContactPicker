#import "VeeContactPickerOptions.h"
#import "VeeContactPickerStrings.h"
#import "NSObject+AGCDescription.h"

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

#pragma mark - NSObject

- (NSString*)description
{
    return [self agc_description];
}

- (NSString*)debugDescription
{
    return [self agc_debugDescription];
}

@end
