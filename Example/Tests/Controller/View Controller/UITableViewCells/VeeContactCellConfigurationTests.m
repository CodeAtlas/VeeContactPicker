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
#import "OCMock.h"
#import "UILabel+Boldify.h"
#import "VeeContactPickerConstants.h"

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

-(void)testCellImageForVeeContactWithImageAndDefaultOptions
{
    [self configureCellDefaultOptionsWithCompleteContact];
    NSAssert(_veeContactComplete.thumbnailImage, @"VeeContact complete has no image loaded");
    BOOL isCellImageCorrect = [_veeContactUITableViewCell.contactImageView.image isEqual:_veeContactComplete.thumbnailImage];
    NSAssert(isCellImageCorrect, @"Cell image for VeeContact complete is not set correctly");
}

-(void)testCellImageWithInitials
{
    [self nullifyIvarWithName:@"thumbnailImage" ofObject:_veeContactComplete];
    [self configureCellDefaultOptionsWithCompleteContact];

    BOOL isCellImageSet = _veeContactUITableViewCell.contactImageView.image != nil;
    NSAssert(isCellImageSet, @"Cell image is not set");
}

-(void)testCellImagePlaceHolder
{
    [self nullifyIvarWithName:@"thumbnailImage" ofObject:_veeContactComplete];
    [self configureCellNoLettersOptionsWithCompleteContact];
    BOOL isCellImageThePlaceholder = _veeContactUITableViewCell.contactImageView.image.size.width == [self veeTestImage].size.width;
    NSAssert(isCellImageThePlaceholder, @"Cell image is not the placeholder");
}

#pragma mark - Collaboration with "UILabel+Boldify"

-(void)testBoldifyOnFirstNameComponent
{
    id primaryLabelMock = [OCMockObject partialMockForObject:[UILabel new]];
    _veeContactUITableViewCell.primaryLabel = primaryLabelMock;
    [_veeContactCellConfigurationWithDefaultOption configureCell:_veeContactUITableViewCell forVeeContact:_veeContactComplete];
    NSString* nameComponentToBoldify = [[[_veeContactComplete displayNameSortedForABOptions] componentsSeparatedByString:@" "] firstObject];
    OCMVerify([primaryLabelMock vee_boldSubstring:nameComponentToBoldify]);
}

-(void)testBoldifyOnVeeContactWithOnlyFirstName
{
    id primaryLabelMock = [OCMockObject partialMockForObject:[UILabel new]];
    _veeContactUITableViewCell.primaryLabel = primaryLabelMock;
    [self nullifyIvarWithName:@"lastName" ofObject:_veeContactComplete];
    [_veeContactCellConfigurationWithDefaultOption configureCell:_veeContactUITableViewCell forVeeContact:_veeContactComplete];
    NSString* nameComponentToBoldify = [_veeContactComplete displayNameSortedForABOptions];
    OCMVerify([primaryLabelMock vee_boldSubstring:nameComponentToBoldify]);
}

-(void)testBoldifyOnVeeContactWithOnlyCompanyName
{
    id primaryLabelMock = [OCMockObject partialMockForObject:[UILabel new]];
    _veeContactUITableViewCell.primaryLabel = primaryLabelMock;
    VeeContact* companyVeeContact = [[VeeContact alloc] initWithFirstName:nil middleName:nil lastName:nil nickName:nil organizationName:@"test company" compositeName:nil thubnailImage:nil phoneNumbers:nil emails:nil];
    [_veeContactCellConfigurationWithDefaultOption configureCell:_veeContactUITableViewCell forVeeContact:companyVeeContact];
    NSString* nameComponentToBoldify = [companyVeeContact displayNameSortedForABOptions];
    OCMVerify([primaryLabelMock vee_boldSubstring:nameComponentToBoldify]);
}

#pragma mark - Private utils

- (void)loadVeeContactCellConfigurationWithDefaultOptions
{
    _veeContactCellConfigurationWithDefaultOption = [[VeeContactCellConfiguration alloc] initWithVeePickerOptions:[VeeContactPickerOptions defaultOptions]];
}

- (void)loadVeeContactCellConfigurationWithNoLettersOptions
{
    VeeContactPickerOptions* veeContactPickerOptions = [VeeContactPickerOptions defaultOptions];
    veeContactPickerOptions.showLettersWhenContactImageIsMissing = NO;
    veeContactPickerOptions.contactThumbnailImagePlaceholder = [self veeTestImage];
    _veeContactCellConfigurationWithNoLettersOption = [[VeeContactCellConfiguration alloc] initWithVeePickerOptions:veeContactPickerOptions];
}

- (void)loadEmptyVeeContactUITableViewCell
{
    NSString* cellIdentifier = [[VeeContactPickerConstants sharedInstance] veeContactCellIdentifier];
    _veeContactUITableViewCell =  [[VeeContactUITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
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
