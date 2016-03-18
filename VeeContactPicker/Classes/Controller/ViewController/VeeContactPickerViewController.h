//
//  Created by Andrea Cipriani on 14/12/15.
//  Copyright © 2015 Code Atlas SRL. All rights reserved.
//

#import <UIKit/UIKit.h>
@import AddressBook;

#import "VeeContactPickerDelegate.h"
#import "VeeContactProt.h"
#import "VeeABDelegate.h"
@class VeeContactPickerOptions;
@class VeeContactPickerStrings;
@class VeeContactColors;

@interface VeeContactPickerViewController : UIViewController <VeeABDelegate,UISearchBarDelegate, UISearchDisplayDelegate, UITableViewDelegate>

#pragma mark - Init

- (instancetype)initWithDefaultConfiguration;
- (instancetype)initWithOptions:(VeeContactPickerOptions*)veeContactPickerOptions;
//When veeContacts are not set they are loaded from all records of the address book
- (instancetype)initWithVeeContacts:(NSArray<id<VeeContactProt>>*)veeContacts;
- (instancetype)initWithOptions:(VeeContactPickerOptions*)veeContactPickerOptions andVeeContacts:(NSArray<id<VeeContactProt>>*)veeContacts;

#pragma mark - Delegate and completion handler

@property (nonatomic, strong) id<VeeContactPickerDelegate> contactPickerDelegate;
@property (nonatomic, strong) void (^completionHandler)(id<VeeContactProt>);

#pragma mark - Outlets

@property (nonatomic, strong) IBOutlet UITableView* contactsTableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem* cancelBarButtonItem;
@property (weak, nonatomic) IBOutlet UINavigationItem *titleNavigationItem;

#pragma mark - IBActions

- (IBAction)cancelBarButtonItemPressed:(id)sender;

@end
