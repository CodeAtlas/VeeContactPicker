#import "VeeContactTableViewCell.h"
@import QuartzCore;
#import "VeeContactPickerAppearanceConstants.h"
#import "VeeContactTableViewCell.h"
#import "VeeContactPickerAppearanceConstants.h"

@implementation VeeContactTableViewCell

NS_ASSUME_NONNULL_BEGIN

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [VeeContactPickerAppearanceConstants sharedInstance].veeContactCellBackgroundColor;
    [self setCellSelectedBackgroundColor];
    [self setupContactImageViewStyle];
    [self setupPrimaryLabelStyle];
}

- (void)setupContactImageViewStyle
{
    _contactImageView.layer.cornerRadius = [[[VeeContactPickerAppearanceConstants sharedInstance] veeContactCellImageDiameter] floatValue] / 2;
    _contactImageView.contentMode = UIViewContentModeScaleAspectFill;
    _contactImageView.clipsToBounds = YES;
}

- (void)setupPrimaryLabelStyle
{
    _primaryLabel.font = [[VeeContactPickerAppearanceConstants sharedInstance] veeContactCellPrimaryLabelFont];
}

-(void)setCellSelectedBackgroundColor
{
    UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:self.bounds];
    selectedBackgroundView.backgroundColor = [VeeContactPickerAppearanceConstants sharedInstance].veeContactCellBackgroundColorWhenSelected;
    self.selectedBackgroundView = selectedBackgroundView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    UIColor *backgroundColor = self.contactImageView.backgroundColor;
    [super setSelected:selected animated:animated];
    self.contactImageView.backgroundColor = backgroundColor;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    UIColor *backgroundColor = self.contactImageView.backgroundColor;
    [super setHighlighted:highlighted animated:animated];
    self.contactImageView.backgroundColor = backgroundColor;
}

-(void)prepareForReuse
{
    self.primaryLabel.text = @"";
    self.contactImageView.image = nil;
}

@end

NS_ASSUME_NONNULL_END

