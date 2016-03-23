//
//  Created by Andrea Cipriani on 21/12/15.
//  Copyright © 2015 Code Atlas SRL. All rights reserved.
//

#import "ViewController.h"
#import "VeeContactPickerViewController.h"
#import "VeeContact.h"
#import "VeeContactsForTestingFactory.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *selectedContactLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)showVeecontactPickerPressed:(id)sender
{
    NSArray<id<VeeContactProt>>* randomVeeContacts = [VeeContactsForTestingFactory createRandomVeeContacts:100];
    VeeContactPickerViewController* veePickerVC = [[VeeContactPickerViewController alloc] initWithVeeContacts:randomVeeContacts];
    //VeeContactPickerViewController* veePickerVC = [[VeeContactPickerViewController alloc] initWithDefaultConfiguration];
    
    veePickerVC.contactPickerDelegate = self;
    
    [self presentViewController:veePickerVC animated:YES completion:nil];
}

#pragma mark - VeeContactPickerDelegate

- (void)didSelectABContact:(id<VeeContactProt>)veeContact
{
    NSLog(@"Selected %@",veeContact);
    _selectedContactLabel.text = [NSString stringWithFormat:@"Last selected contact: %@",veeContact.displayName];
}

@end
