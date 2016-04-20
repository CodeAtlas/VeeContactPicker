//
//  Created by Andrea Cipriani on 14/12/15.
//  Copyright © 2015 Code Atlas SRL. All rights reserved.
//

#import <UIKit/UIKit.h>
@import AddressBook;

#import "VeeContactPickerDelegate.h"
#import "VeeContactProt.h"
#import "VeeABDelegate.h"
#import "VeeSearchResultsDelegate.h"
@class VeeContactPickerOptions;
@class VeeContactPickerStrings;

@interface VeeContactPickerViewController : UIViewController <VeeABDelegate, VeeSearchResultsDelegate, UITableViewDelegate>

#pragma mark - Init

//If veeContacts are not set, the picker will show the contacts from the address book
- (instancetype)initWithDefaultConfiguration;
- (instancetype)initWithOptions:(VeeContactPickerOptions*)veeContactPickerOptions;
- (instancetype)initWithVeeContacts:(NSArray<id<VeeContactProt>>*)veeContacts;
- (instancetype)initWithOptions:(VeeContactPickerOptions*)veeContactPickerOptions andVeeContacts:(NSArray<id<VeeContactProt>>*)veeContacts; //Designated initializer

#pragma mark - Delegate and completion handler

@property (nonatomic, strong) id<VeeContactPickerDelegate> contactPickerDelegate;
@property (nonatomic, strong) void (^contactSelectionHandler)(id<VeeContactProt>);

#pragma mark - Public Outlets

@property (nonatomic, strong) IBOutlet UITableView* contactsTableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem* cancelBarButtonItem;
@property (weak, nonatomic) IBOutlet UINavigationItem *titleNavigationItem;
@property (weak, nonatomic) IBOutlet UILabel *emptyViewLabel;

#pragma mark - IBActions

- (IBAction)cancelBarButtonItemPressed:(id)sender;

@end
