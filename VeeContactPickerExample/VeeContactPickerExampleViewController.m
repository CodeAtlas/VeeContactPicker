//
//  Created by Andrea Cipriani on 21/12/15.
//  Copyright © 2015 Code Atlas SRL. All rights reserved.
//

#import "VeeContact.h"
#import "VeeContactPickerViewController.h"
#import "VeeContactsForTestingFactory.h"
#import "VeeContactPickerExampleViewController.h"
#import "AGCInitialsColors.h"
#import "UIImageView+AGCInitials.h"

@interface VeeContactPickerExampleViewController ()

@property (weak, nonatomic) IBOutlet UILabel* selectedContactLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectedContactImageView;
@property (weak, nonatomic) IBOutlet UITextView *selectedContactTextView;

@end

@implementation VeeContactPickerExampleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateUIForNoContactSelected];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)showVeecontactPickerPressed:(id)sender
{
    //VeeContactPickerViewController* veePickerVC = [self pickerWithAddressBookContacts];
    VeeContactPickerViewController* veePickerVC = [self pickerWithRandomFakeVeeContacts];
    veePickerVC.contactPickerDelegate = self;
    [self setColorPlaceholdersCustomPalette];
    [self presentViewController:veePickerVC animated:YES completion:nil];
}

#pragma mark - VeeContact Picker customization templates

- (VeeContactPickerViewController*)pickerWithAddressBookContacts
{
    return [[VeeContactPickerViewController alloc] initWithDefaultConfiguration];
}

- (VeeContactPickerViewController*)pickerWithRandomFakeVeeContacts
{
    NSArray<id<VeeContactProt> >* randomVeeContacts = [VeeContactsForTestingFactory createRandomVeeContacts:100];
    return [[VeeContactPickerViewController alloc] initWithVeeContacts:randomVeeContacts];
}

-(void)setColorPlaceholdersCustomPalette
{
    NSArray* replaceWithYourCustomPalette = @[[UIColor purpleColor]];
    [[AGCInitialsColors sharedInstance] setColorPalette:replaceWithYourCustomPalette];
}

#pragma mark - VeeContactPickerDelegate

- (void)didSelectABContact:(id<VeeContactProt>)veeContact
{
    NSLog(@"Selected %@", veeContact);
    [self updateUIForSelectedContact:veeContact];
}

-(void)didCancelABContactSelection
{
    NSLog(@"No contact was selected");
    _selectedContactLabel.text = @"No Contact is selected";
    [self updateUIForNoContactSelected];
}

-(void)didFailToAccessABContacts
{
    NSLog(@"Failed to access contacts. Have you accepted Address book permissions?");
    [self updateUIForNoContactSelected];
    _selectedContactLabel.text =  [_selectedContactLabel.text stringByAppendingString:@" Have you accepted Address book permissions?"];
}

#pragma mark - UI Utils

-(void)updateUIForNoContactSelected
{
    _selectedContactLabel.text = @"No Contact is selected.";
    _selectedContactImageView.hidden = YES;
    _selectedContactTextView.hidden = YES;
}

-(void)updateUIForSelectedContact:(VeeContact*)veeContact
{
    _selectedContactLabel.text = @"Selected Contact:";
    [self showSelectedContactImage:veeContact];
    [self showPrettyVeeContactDescription:veeContact];
}

-(void)showSelectedContactImage:(VeeContact*)veeContact
{
    _selectedContactImageView.hidden = NO;
    if (veeContact.thumbnailImage){
        _selectedContactImageView.image = veeContact.thumbnailImage;
    }
    else{
        [_selectedContactImageView agc_setImageWithInitialsFromName:[veeContact displayName] separatedByString:@" "];
    }
}

-(void)showPrettyVeeContactDescription:(VeeContact*)veeContact
{
    _selectedContactTextView.hidden = NO;
    _selectedContactTextView.text = [self prettyVeeContactDescription:veeContact];
}

-(NSString*)prettyVeeContactDescription:(VeeContact*)veeContact
{
    NSString* veeContactDescription = veeContact.description;
    if ([veeContactDescription hasPrefix:@"\n[VeeContact"]){
        veeContactDescription = [veeContactDescription substringFromIndex:13];
        if ([veeContactDescription hasSuffix:@"]"]){
            return [veeContactDescription substringToIndex:[veeContactDescription length]-1];
        }
    }
    return veeContactDescription;
}

@end
