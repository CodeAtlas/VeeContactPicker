@import QuartzCore;
#import "VeeContactPickerAppearanceConstants.h"
#import "VeeContactUITableViewCell.h"
#import "FLKAutoLayout.h"
#import "VeeContactPickerAppearanceConstants.h"

@implementation VeeContactUITableViewCell

NS_ASSUME_NONNULL_BEGIN

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (!self) {
        return nil;
    }
    
    self.backgroundColor = [VeeContactPickerAppearanceConstants sharedInstance].veeContactCellBackgroundColor;
    [self setCellSelectedBackgroundColor];
    [self addContactImageViewToSubView];
    [self addPrimaryLabelToSubView];
    return self;
}

-(void)setCellSelectedBackgroundColor
{
    UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:self.bounds];
    selectedBackgroundView.backgroundColor = [VeeContactPickerAppearanceConstants sharedInstance].veeContactCellBackgroundColorWhenSelected;
    self.selectedBackgroundView = selectedBackgroundView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    UIColor* backgroundColor = _contactImageView.backgroundColor;
    [super setSelected:selected animated:animated];
    self.contactImageView.backgroundColor = backgroundColor;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    UIColor* backgroundColor = _contactImageView.backgroundColor;
    [super setHighlighted:highlighted animated:animated];
    self.contactImageView.backgroundColor = backgroundColor;
}

-(void)prepareForReuse
{
    self.primaryLabel.text = @"";
    self.contactImageView.image = nil;
}

#pragma mark - Private

/*
 I personally don't like to code the UI, but I'm not able to load the nib of a UITableViewCell from the bundle of a Pod, see:
 https://github.com/CocoaPods/CocoaPods/issues/2408
 */

-(void)addContactImageViewToSubView
{
    CGFloat contactImageViewDiameter = [VeeContactPickerAppearanceConstants sharedInstance].veeContactCellImageDiameter.floatValue;
    self.contactImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, contactImageViewDiameter, contactImageViewDiameter)];
    [self addSubview:_contactImageView];
    self.contactImageView.layer.cornerRadius = [VeeContactPickerAppearanceConstants sharedInstance].veeContactCellImageDiameter.floatValue / 2;
    self.contactImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.contactImageView.clipsToBounds = YES;
    [self setConstraintsForContactImageView];
}

-(void)addPrimaryLabelToSubView
{
    self.primaryLabel = [UILabel new];
    [self addSubview:_primaryLabel];
    self.primaryLabel.font = [VeeContactPickerAppearanceConstants sharedInstance].veeContactCellPrimaryLabelFont;
    [self setConstraintsForPrimaryLabel];
}

-(void)setConstraintsForContactImageView
{
    NSString* contactImageViewDiameterString = [VeeContactPickerAppearanceConstants sharedInstance].veeContactCellImageDiameter.stringValue;
    [self.contactImageView constrainWidth:contactImageViewDiameterString height:contactImageViewDiameterString];
 
    NSString* contactImageViewMarginString = [self contactImageViewMargin].stringValue;
    [self.contactImageView alignTop:contactImageViewMarginString leading:contactImageViewMarginString bottom:contactImageViewMarginString trailing:@"0" toView:self.contentView];
}

-(void)setConstraintsForPrimaryLabel
{
    [self.primaryLabel alignCenterYWithView:_contactImageView predicate:@"0"];
    CGFloat horizontalMarginFromContactImageView = 16;
    [self.primaryLabel constrainLeadingSpaceToView:_contactImageView predicate:(@(horizontalMarginFromContactImageView)).stringValue];
    [self.primaryLabel constrainWidth:[self cellWidthWithoutPrimaryLabelWithHorizontalMarginFromContactImageView:horizontalMarginFromContactImageView andHorizontalTrailingSpaceToSuperView:16].stringValue];
}

-(NSNumber*)contactImageViewMargin
{
    CGFloat cellHeight = [VeeContactPickerAppearanceConstants sharedInstance].veeContactCellHeight;
    NSNumber* contactImageViewDiameter = [VeeContactPickerAppearanceConstants sharedInstance].veeContactCellImageDiameter;
    return @((cellHeight - contactImageViewDiameter.integerValue) / 2);
}

-(NSNumber*)cellWidthWithoutPrimaryLabelWithHorizontalMarginFromContactImageView:(CGFloat)horizontalMarginFromContactImageView andHorizontalTrailingSpaceToSuperView:(CGFloat)horizontalTrailingSpaceToSuperView
{
    CGFloat cellWidth = self.contentView.frame.size.width;
    return @(cellWidth - [self contactImageViewMargin].floatValue - [VeeContactPickerAppearanceConstants sharedInstance].veeContactCellImageDiameter.floatValue - horizontalTrailingSpaceToSuperView);
}

@end

NS_ASSUME_NONNULL_END
