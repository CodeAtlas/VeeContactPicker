@import Foundation;
@import UIKit;
@class VeeContactPickerStrings;

NS_ASSUME_NONNULL_BEGIN

@interface VeeContactPickerOptions : NSObject

#pragma mark - Init

- (instancetype)initWithDefaultOptions NS_DESIGNATED_INITIALIZER;
+ (VeeContactPickerOptions*)defaultOptions;

@property (nonatomic, strong) VeeContactPickerStrings *veeContactPickerStrings;
@property (nonatomic, strong) NSArray<NSString*> *sectionIdentifiers; //Contacts section identifiers, default are [[[UILocalizedIndexedCollation currentCollation] sectionIndexTitles]
@property (nonatomic, copy) NSString *sectionIdentifierWildcard; //Section identifier for contacts that don't fit in a section, default is '#' as in the iOS address book
@property (nonatomic, assign) BOOL showInitialsPlaceholder; //Default value is YES
@property (nonatomic, strong) UIImage *contactThumbnailImagePlaceholder; //The placeholder image that is shown when showInitialsPlaceholder is NO and the contact doesn't have an image

@end

NS_ASSUME_NONNULL_END
