//
//  Created by Andrea Cipriani on 28/03/16.
//  Copyright © 2016 Code Atlas SRL. All rights reserved.
//

#import "VeeContact.h"
#import "VeeContactCellConfiguration.h"
#import "VeeContactPickerOptions.h"
#import "VeeContactUITableViewCell.h"
#import "VeeContactsForTestingFactory.h"
#import <XCTest/XCTest.h>
#import "XCTest+VeeCommons.h"

@interface VeeContactCellConfigurationTests : XCTestCase

@property (nonatomic, strong) VeeContactCellConfiguration* veeContactCellConfigurationWithDefaultOption;
@property (nonatomic, strong) VeeContactCellConfiguration* veeContactCellConfigurationWithNoLettersOption;

@property (nonatomic, strong) VeeContactUITableViewCell* veeContactUITableViewCell;
@property (nonatomic, strong) VeeContact* veeContactComplete;

@end

@implementation VeeContactCellConfigurationTests

- (void)setUp
{
    [super setUp];
    _veeContactComplete = [VeeContactsForTestingFactory veeContactComplete];
    [self loadVeeContactCellConfigurationWithDefaultOptions];
    [self loadVeeContactCellConfigurationWithNoLettersOptions];
    [self loadEmptyVeeContactUITableViewCell];
}

- (void)testConfigureCellPrimaryLabel
{
    [self configureCellDefaultOptionsWithCompleteContact];
    
    BOOL isPrimaryLabelCorrect = [_veeContactUITableViewCell.primaryLabel.text isEqualToString:[_veeContactComplete displayName]];
    NSAssert(isPrimaryLabelCorrect, @"Primary label text should be %@ but is %@",[_veeContactComplete displayName],_veeContactUITableViewCell.primaryLabel.text);
}

- (void)testConfigureCellSecondaryLabelIsHiddenWithDefaultOptions
{
    [self configureCellDefaultOptionsWithCompleteContact];
    
    BOOL isSecondaryLabelHidden = _veeContactUITableViewCell.secondaryLabel.hidden;
    NSAssert(isSecondaryLabelHidden, @"Secondary label should be hidden with default options");
}

-(void)testCellImageForVeeContactWithImageAndDefaultOptions
{
    [self configureCellDefaultOptionsWithCompleteContact];
    NSAssert(_veeContactComplete.thumbnailImage,@"VeeContact complete doesn't have an image"); //TODO: this test sometimes fails?
    BOOL isCellImageCorrect = [_veeContactUITableViewCell.contactImageView.image isEqual:_veeContactComplete.thumbnailImage];
    NSAssert(isCellImageCorrect, @"Cell image is not correct");
}

-(void)testCellImageWithLetters
{
    [self nullifyIvarWithName:@"thumbnailImage" ofObject:_veeContactComplete];
    [self configureCellDefaultOptionsWithCompleteContact];

    BOOL isCellImageSet = _veeContactUITableViewCell.contactImageView.image; //TODO: test should be more specific, but before I need to change UIImageView+Letters with my own implementation
    NSAssert(isCellImageSet, @"Cell image is not set");
}

-(void)testCellImagePlaceHolder
{
    [self nullifyIvarWithName:@"thumbnailImage" ofObject:_veeContactComplete];
    [self configureCellNoLettersOptionsWithCompleteContact];
    BOOL isCellImageThePlaceholder = _veeContactUITableViewCell.contactImageView.image.size.width == [self codeAtasTestImage].size.width;
    NSAssert(isCellImageThePlaceholder, @"Cell image is not the placeholder");
}

//TODO: test boldify

#pragma mark - Private utils

- (void)loadVeeContactCellConfigurationWithDefaultOptions
{
    _veeContactCellConfigurationWithDefaultOption = [[VeeContactCellConfiguration alloc] initWithVeePickerOptions:[VeeContactPickerOptions defaultOptions]];
}

- (void)loadVeeContactCellConfigurationWithNoLettersOptions
{
    VeeContactPickerOptions* veeContactPickerOptions = [VeeContactPickerOptions defaultOptions];
    veeContactPickerOptions.showLettersWhenContactImageIsMissing = NO;
    veeContactPickerOptions.contactThumbnailImagePlaceholder = [self codeAtasTestImage];
    _veeContactCellConfigurationWithNoLettersOption = [[VeeContactCellConfiguration alloc] initWithVeePickerOptions:veeContactPickerOptions];
}

- (void)loadEmptyVeeContactUITableViewCell
{
    _veeContactUITableViewCell = [[NSBundle mainBundle] loadNibNamed:@"VeeContactUITableViewCell" owner:nil options:nil][0];
}

-(void)configureCellDefaultOptionsWithCompleteContact
{
    [_veeContactCellConfigurationWithDefaultOption configureCell:_veeContactUITableViewCell forVeeContact:_veeContactComplete];
}

-(void)configureCellNoLettersOptionsWithCompleteContact
{
    [_veeContactCellConfigurationWithNoLettersOption configureCell:_veeContactUITableViewCell forVeeContact:_veeContactComplete];
}

@end
