#import <XCTest/XCTest.h>
#import "VeeContact.h"
#import "VeeContactCellConfiguration.h"
#import "VeeContactPickerOptions.h"
#import "VeeContactTableViewCell.h"
#import "VeeContactsForTestingFactory.h"
#import "XCTest+VeeCommons.h"
#import "OCMock.h"
#import "UILabel+VeeBoldify.h"
#import "VeeContactPickerAppearanceConstants.h"
#import "NSBundle+VeeContactPicker.h"

@interface VeeContactCellConfigurationTests : XCTestCase

@property (nonatomic, strong) VeeContactCellConfiguration* veeContactCellConfigurationWithDefaultOption;
@property (nonatomic, strong) VeeContactCellConfiguration* veeContactCellConfigurationWithNoInitialsOption;

@property (nonatomic, strong) VeeContactTableViewCell* veeContactTableViewCell;
@property (nonatomic, strong) VeeContact* veeContactComplete;

@end

@implementation VeeContactCellConfigurationTests

- (void)setUp
{
    [super setUp];
    _veeContactComplete = [VeeContactsForTestingFactory veeContactComplete];
    [self loadVeeContactCellConfigurationWithDefaultOptions];
    [self loadVeeContactCellConfigurationWithNoInitialsOptions];
    [self loadEmptyCell];
}

- (void)testConfigureCellPrimaryLabel
{
    [self configureCellDefaultOptionsWithCompleteContact];
    BOOL isPrimaryLabelCorrect = [self.veeContactTableViewCell.primaryLabel.text isEqualToString:[_veeContactComplete displayName]];
    NSAssert(isPrimaryLabelCorrect, @"Primary label text should be %@ but is %@",[_veeContactComplete displayName],self.veeContactTableViewCell.primaryLabel.text);
}

-(void)testCellImageForVeeContactWithImageAndDefaultOptions
{
    [self configureCellDefaultOptionsWithCompleteContact];
    BOOL isCellImageCorrect = [self.veeContactTableViewCell.contactImageView.image isEqual:_veeContactComplete.thumbnailImage];
    NSAssert(isCellImageCorrect, @"Cell image for VeeContact complete is not set correctly");
}

-(void)testCellImageWithInitials
{
    [self nullifyIvarWithName:@"thumbnailImage" ofObject:_veeContactComplete];
    [self configureCellDefaultOptionsWithCompleteContact];

    BOOL isCellImageSet = self.veeContactTableViewCell.contactImageView.image != nil;
    NSAssert(isCellImageSet, @"Cell image is not set");
}

-(void)testCellImagePlaceHolder
{
    [self nullifyIvarWithName:@"thumbnailImage" ofObject:_veeContactComplete];
    [self configureCellNoInitialsOptionsWithCompleteContact];
    BOOL isCellImageThePlaceholder = self.veeContactTableViewCell.contactImageView.image.size.width == [self veeTestImage].size.width;
    NSAssert(isCellImageThePlaceholder, @"Cell image is not the placeholder");
}

#pragma mark - Collaboration with "UILabel+Boldify"

-(void)testBoldifyOnFirstNameComponent
{
    id primaryLabelMock = [OCMockObject partialMockForObject:[UILabel new]];
    self.veeContactTableViewCell.primaryLabel = primaryLabelMock;
    [_veeContactCellConfigurationWithDefaultOption configureCell:_veeContactTableViewCell forVeeContact:_veeContactComplete];
    NSString* nameComponentToBoldify = [[_veeContactComplete displayNameSortedForABOptions] componentsSeparatedByString:@" "].firstObject;
    OCMVerify([primaryLabelMock vee_boldSubstring:nameComponentToBoldify]);
}

-(void)testBoldifyOnVeeContactWithOnlyFirstName
{
    id primaryLabelMock = [OCMockObject partialMockForObject:[UILabel new]];
    self.veeContactTableViewCell.primaryLabel = primaryLabelMock;
    [self nullifyIvarWithName:@"lastName" ofObject:_veeContactComplete];
    [_veeContactCellConfigurationWithDefaultOption configureCell:_veeContactTableViewCell forVeeContact:_veeContactComplete];
    NSString* nameComponentToBoldify = [_veeContactComplete displayNameSortedForABOptions];
    OCMVerify([primaryLabelMock vee_boldSubstring:nameComponentToBoldify]);
}

-(void)testBoldifyOnVeeContactWithOnlyCompanyName
{
    id primaryLabelMock = [OCMockObject partialMockForObject:[UILabel new]];
    self.veeContactTableViewCell.primaryLabel = primaryLabelMock;
    VeeContact* companyVeeContact = [[VeeContact alloc] initWithFirstName:nil middleName:nil lastName:nil nickName:nil organizationName:@"test company" compositeName:nil thubnailImage:nil phoneNumbers:nil emails:nil];
    [_veeContactCellConfigurationWithDefaultOption configureCell:_veeContactTableViewCell forVeeContact:companyVeeContact];
    NSString* nameComponentToBoldify = [companyVeeContact displayNameSortedForABOptions];
    OCMVerify([primaryLabelMock vee_boldSubstring:nameComponentToBoldify]);
}

#pragma mark - Private utils

- (void)loadVeeContactCellConfigurationWithDefaultOptions
{
    _veeContactCellConfigurationWithDefaultOption = [[VeeContactCellConfiguration alloc] initWithVeePickerOptions:[VeeContactPickerOptions defaultOptions]];
}

- (void)loadVeeContactCellConfigurationWithNoInitialsOptions
{
    VeeContactPickerOptions* veeContactPickerOptions = [VeeContactPickerOptions defaultOptions];
    veeContactPickerOptions.showInitialsPlaceholder = NO;
    veeContactPickerOptions.contactThumbnailImagePlaceholder = [self veeTestImage];
    _veeContactCellConfigurationWithNoInitialsOption = [[VeeContactCellConfiguration alloc] initWithVeePickerOptions:veeContactPickerOptions];
}

- (void)loadEmptyCell
{
    NSString* cellIdentifier = [VeeContactPickerAppearanceConstants sharedInstance].veeContactCellIdentifier;
    _veeContactTableViewCell = [[[NSBundle veeContactPickerBundle] loadNibNamed:cellIdentifier owner:nil options:nil] firstObject];
}

-(void)configureCellDefaultOptionsWithCompleteContact
{
    [_veeContactCellConfigurationWithDefaultOption configureCell:_veeContactTableViewCell forVeeContact:_veeContactComplete];
}

-(void)configureCellNoInitialsOptionsWithCompleteContact
{
    [_veeContactCellConfigurationWithNoInitialsOption configureCell:_veeContactTableViewCell forVeeContact:_veeContactComplete];
}

@end
