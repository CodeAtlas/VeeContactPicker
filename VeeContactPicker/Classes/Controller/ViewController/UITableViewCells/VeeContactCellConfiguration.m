#import "VeeContactCellConfiguration.h"
#import "VeeContactTableViewCell.h"
#import "UILabel+VeeBoldify.h"
#import "VeeContactPickerOptions.h"
#import "UIImageView+AGCInitials.h"
#import "VeeCommons.h"

NS_ASSUME_NONNULL_BEGIN

@interface VeeContactCellConfiguration ()
@property (nonatomic,strong) VeeContactPickerOptions *veeContactPickerOptions;
@end

@implementation VeeContactCellConfiguration

#pragma mark - Initializers

- (instancetype)initWithVeePickerOptions:(VeeContactPickerOptions*)veeContactPickerOptions
{
    self = [super init];
    if (self) {
        _veeContactPickerOptions = veeContactPickerOptions;
    }
    return self;
}

#pragma mark - Public Methods

- (void)configureCell:(VeeContactTableViewCell*)cell forVeeContact:(id<VeeContactProt>)veeContact
{
    [self configureCellLabels:cell forVeeContact:veeContact];
    [self configureCellImage:cell forVeeContact:veeContact];
}

#pragma mark - Private utils

- (void)configureCellLabels:(VeeContactTableViewCell*)cell forVeeContact:(id<VeeContactProt>)veeContact
{
    cell.primaryLabel.text = [veeContact displayName];
    NSArray* nameComponents = [[veeContact displayNameSortedForABOptions] componentsSeparatedByString:@" "];
    BOOL isMissingANameComponent = [VeeCommons vee_isEmpty:veeContact.firstName] || [VeeCommons vee_isEmpty:veeContact.lastName];
    BOOL nameComponentsAreLessThanOne = nameComponents.count < 1;
    NSString* toBoldify;
    if (isMissingANameComponent || nameComponentsAreLessThanOne){
        toBoldify = [veeContact displayName];
    }
    else {
        toBoldify = nameComponents.firstObject;
    }
    [cell.primaryLabel vee_boldSubstring:toBoldify];
}

- (void)configureCellImage:(VeeContactTableViewCell*)cell forVeeContact:(id<VeeContactProt>)veeContact
{
    if (veeContact.thumbnailImage) {
        cell.contactImageView.image = veeContact.thumbnailImage;
    }
    else {
        if (_veeContactPickerOptions.showInitialsPlaceholder) {
            [cell.contactImageView agc_setImageWithInitialsFromName:[veeContact displayName] separatedByString:@" "];
        }
        else {
            (cell.contactImageView).image = _veeContactPickerOptions.contactThumbnailImagePlaceholder;
        }
    }
}

@end

NS_ASSUME_NONNULL_END
