//  Created by Andrea Cipriani on 16/03/16.
//  Copyright © 2016 Code Atlas SRL. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "VeeContactPickerOptions.h"

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

#pragma mark - Default options

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

#pragma mark - Custom options

-(void)testCustomOptionsAreSetProperly
{
    //Given
    NSArray<NSString*>* customSectionIdentifiers = @[@"A",@"B",@"C"];
    NSString* sectionIdentifierWildcard = @"$";
    BOOL showLettersWhenContactImageIsMissing = NO;
    
    UIImage* contactThumbnailImagePlaceholder = [self codeAtasTestImage];
    
    VeeContactPickerOptions * customOptions =  [[VeeContactPickerOptions alloc] initWithSectionIdentifiers:customSectionIdentifiers andSectionIdentifierWildcard:sectionIdentifierWildcard andShowLettersWhenContactImageIsMissing:showLettersWhenContactImageIsMissing andContactThumbnailImagePlaceholder:contactThumbnailImagePlaceholder];
    
    //Then
    NSAssert([customOptions.sectionIdentifiers isEqual:customSectionIdentifiers], @"sectionIdentifiers are not set properly");
    NSAssert([customOptions.sectionIdentifierWildcard isEqualToString:sectionIdentifierWildcard], @"sectionIdentifierWildcard is not set properly ");
    NSAssert(customOptions.showLettersWhenContactImageIsMissing == showLettersWhenContactImageIsMissing, @"showLettersWhenContactImageIsMissing is not set properly");
    NSAssert(customOptions.contactThumbnailImagePlaceholder, @"contactThumbnailImagePlaceholder is not set properly");

}

#pragma mark - Private utils

-(UIImage*)codeAtasTestImage
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *imagePath = [bundle pathForResource:@"codeatlas" ofType:@"png"];
    UIImage *codeAtlasImage = [UIImage imageWithContentsOfFile:imagePath];
    NSAssert(codeAtlasImage, @"codeatlas image not found");
    return codeAtlasImage;
}

@end
