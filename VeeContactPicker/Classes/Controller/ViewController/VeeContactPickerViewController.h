@import UIKit;
@import AddressBook;

#import "VeeContactPickerDelegate.h"
#import "VeeContactProt.h"
#import "VeeABDelegate.h"
@class VeeContactPickerOptions;
@class VeeContactPickerStrings;

NS_ASSUME_NONNULL_BEGIN

@interface VeeContactPickerViewController : UIViewController <VeeABDelegate, UITableViewDelegate>

#pragma mark - Init

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithDefaultConfiguration;
- (instancetype)initWithOptions:(VeeContactPickerOptions*)veeContactPickerOptions;
- (instancetype)initWithVeeContacts:(NSArray<id<VeeContactProt>>*)veeContacts;
- (instancetype)initWithOptions:(VeeContactPickerOptions*)veeContactPickerOptions
                    veeContacts:(NSArray<id<VeeContactProt>>*)veeContacts;

@property (nonatomic, assign) BOOL multipleSelection;

#pragma mark - Delegate and completion handler

@property (nonatomic, weak) id<VeeContactPickerDelegate> contactPickerDelegate;
@property (nonatomic, strong) void (^contactSelectionHandler)(id<VeeContactProt>);

#pragma mark - Public Outlets

@property (weak, nonatomic) IBOutlet UITableView *contactsTableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelBarButtonItem;
@property (weak, nonatomic) IBOutlet UINavigationItem *titleNavigationItem;
@property (weak, nonatomic) IBOutlet UILabel *emptyViewLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *multipleSelectionDoneButton;


#pragma mark - IBActions

- (IBAction)cancelBarButtonItemPressed:(id)sender;
- (IBAction)multipleSelectionDoneButtonItemPressed:(id)sender;

@end

NS_ASSUME_NONNULL_END
