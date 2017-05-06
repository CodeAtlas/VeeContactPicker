@import UIKit;
@import AddressBook;

#import "VeeContactPickerDelegate.h"
#import "VeeContactProt.h"
#import "VeeABDelegate.h"
#import "VeeSearchResultsDelegate.h"
@class VeeContactPickerOptions;
@class VeeContactPickerStrings;

NS_ASSUME_NONNULL_BEGIN

@interface VeeContactPickerViewController : UIViewController <VeeABDelegate, VeeSearchResultsDelegate, UITableViewDelegate>

#pragma mark - Init

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithDefaultConfiguration;
- (instancetype)initWithOptions:(VeeContactPickerOptions*)veeContactPickerOptions;
- (instancetype)initWithVeeContacts:(NSArray<id<VeeContactProt>>*)veeContacts;
- (instancetype)initWithOptions:(VeeContactPickerOptions*)veeContactPickerOptions veeContacts:(NSArray<id<VeeContactProt>>*)veeContacts;

#pragma mark - Delegate and completion handler

@property (nonatomic, weak) id<VeeContactPickerDelegate> contactPickerDelegate;
@property (nonatomic, strong) void (^contactSelectionHandler)(id<VeeContactProt>);

#pragma mark - Public Outlets

@property (nonatomic, strong) IBOutlet UITableView *contactsTableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelBarButtonItem;
@property (weak, nonatomic) IBOutlet UINavigationItem *titleNavigationItem;
@property (weak, nonatomic) IBOutlet UILabel *emptyViewLabel;

#pragma mark - IBActions

- (IBAction)cancelBarButtonItemPressed:(id)sender;

@end

NS_ASSUME_NONNULL_END
