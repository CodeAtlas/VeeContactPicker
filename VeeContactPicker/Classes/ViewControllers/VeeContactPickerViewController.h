//
//  VeeContactPickerViewController.h
//  VeeContactPicker
//
//  Created by Andrea Cipriani on 14/12/15.
//  Copyright © 2015 Code Atlas SRL. All rights reserved.
//

#import "ABContactProt.h"
#import "VeeContactPickerDelegate.h"
#import <UIKit/UIKit.h>
@import AddressBook;

@interface VeeContactPickerViewController : UIViewController <UISearchBarDelegate, UISearchDisplayDelegate, UITableViewDelegate, UITableViewDataSource>

typedef NS_ENUM(NSInteger, VeeContactDetail) {
    //Default
    VeeContactDetailPhoneNumber, //0
    VeeContactDetailEmail, //1
};

#pragma mark - Initializers

- (instancetype)initWithCompletionHandler:(void (^)(id<ABContactProt> abContact))didSelectABContact;
- (instancetype)initWithDelegate:(id<VeeContactPickerDelegate>)contactPickerDelegate;

#pragma mark - Outlets

@property (nonatomic, strong) IBOutlet UITableView* contactsTableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem* cancelBarButtonItem;

#pragma mark - IBActions

- (IBAction)cancelBarButtonItemPressed:(id)sender;

#pragma mark - Data source

@property (nonatomic) ABAddressBookRef addressBookRef;

@property (nonatomic, strong) NSArray<ABContactProt>* abContacts;
@property (nonatomic, strong) NSArray<NSString*>* allSectionIdentifiers;

@property (nonatomic, strong) NSArray<UIColor*>* contactLettersColorPalette; //Set your palette otherwise lightgraycolor will be used for all contact image placeholders

#pragma mark - Contact picker delegate

@property (nonatomic, strong) id<VeeContactPickerDelegate> contactPickerDelegate;

#pragma mark - Contact picker completion handler

@property (nonatomic, strong) void (^completionHandler)(id<ABContactProt>);

#pragma mark - Options

@property (nonatomic, assign) VeeContactDetail veeContactDetail;
//TODO: firstNameOrSurnameOrderOption

//picker delegate
//avoidContactsWithABId:(NSArray)...
//overrideWithACContacts
//contactEmptyImageView

#pragma mark - Appearance
//TODO: ...

@end
