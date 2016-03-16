//
//  VeeContactPickerViewController.h
//  VeeContactPicker
//
//  Created by Andrea Cipriani on 14/12/15.
//  Copyright © 2015 Code Atlas SRL. All rights reserved.
//

#import "VeeContactProt.h"
#import "VeeContactPickerDelegate.h"
#import <UIKit/UIKit.h>
#import "VeeContactPickerOptions.h"
@import AddressBook;
@class VeeContactPickerOptions;

@interface VeeContactPickerViewController : UIViewController <UISearchBarDelegate, UISearchDisplayDelegate, UITableViewDelegate, UITableViewDataSource>

#pragma mark - Init

- (instancetype)initWithDefaultOptions;
- (instancetype)initWithOptions:(VeeContactPickerOptions *)veeContactPickerOptions;
- (instancetype)initWithOptions:(VeeContactPickerOptions *)veeContactPickerOptions andColors:(VeeContactColors*)veeContactColors;

#pragma mark - Data source

@property (nonatomic,strong) NSArray<VeeContactProt>* veeContacts //By default veeContacts are loaded from the address book
;

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
