//  Created by Andrea Cipriani on 16/03/16.
//  Copyright © 2016 Code Atlas SRL. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "VeeContactPickerOptions.h"
#import "VeeContactPickerStrings.h"

@interface VeeContactPickerOptionsTests : XCTestCase

@property (nonatomic,strong) VeeContactPickerOptions* veeContactPickerDefaultOptions;
@end

@implementation VeeContactPickerOptionsTests

- (void)setUp
{
    [super setUp];
    _veeContactPickerDefaultOptions = [VeeContactPickerOptions defaultOptions];
}

- (void)tearDown
{
    [super tearDown];
}

#pragma mark - Init

-(void)testInitShouldReturnDefaultOptions
{
    VeeContactPickerOptions* veeContactPickerOptions = [VeeContactPickerOptions new];
    BOOL areDefaultOption = [veeContactPickerOptions isEqual:veeContactPickerOptions];
    NSAssert(areDefaultOption, @"Init should return default options");
}

#pragma mark - Default options

-(void)testDefaultOptionsStrings
{
    BOOL stringsAreDefault = [[[_veeContactPickerDefaultOptions veeContactPickerStrings] navigationBarTitle] isEqualToString:[[VeeContactPickerStrings defaultStrings] navigationBarTitle]];
    NSAssert(stringsAreDefault, @"Strings should be default");
}

-(void)testDefaultOptionsSectionIdentifiers
{
    NSArray* sectionIndexTitles = [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles];
    NSAssert(sectionIndexTitles, @"SectionIndexTitles should not be nil");
    
    BOOL areDefaultSectionIdentifiersCorrect =[_veeContactPickerDefaultOptions.sectionIdentifiers isEqual:sectionIndexTitles];
    NSAssert(areDefaultSectionIdentifiersCorrect, @"Default sectionIdentifiers are %@ but they should be %@",_veeContactPickerDefaultOptions.sectionIdentifiers,sectionIndexTitles);
}

-(void)testDefaultOptionsSectionIdentifierWildcard
{
    BOOL isDefaultSectionIdentifierWildcardCorrect = [_veeContactPickerDefaultOptions.sectionIdentifierWildcard isEqualToString:@"#"];
    NSAssert(isDefaultSectionIdentifierWildcardCorrect, @"Default sectionIdentifierWildcard is %@ but should be #",_veeContactPickerDefaultOptions.sectionIdentifierWildcard);
}

-(void)testDefaultOptionsShowLettersIsYES
{
    NSAssert(_veeContactPickerDefaultOptions.showLettersWhenContactImageIsMissing, @"Default options showLettersWhenContactImageIsMissing should be YES");
}

-(void)testDefaultOptionsContactThumbnailImagePlaceholderIsNil
{
    NSAssert(_veeContactPickerDefaultOptions.contactThumbnailImagePlaceholder == nil, @"Default options testDefaultOptionsContactThumbnailImagePlaceholderIsNil should be nil");
}

@end
