#import "VeeContactPicker-umbrella.h"
#import "VeeContactPickerExampleViewController.h"
#import "VeeContactPickerViewController.h"
#import "VeeContact.h"
#import "VeeContactPickerDelegate.h"
#import "AGCInitialsColors.h"
#import "UIImageView+AGCInitials.h"

NS_ASSUME_NONNULL_BEGIN

@interface VeeContactPickerExampleViewController ()
@property (weak, nonatomic) IBOutlet UILabel *selectedContactLabel;
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
    VeeContactPickerViewController *veePickerVC = [self pickerWithAddressBookContacts];
    //VeeContactPickerViewController* veePickerVC = [self pickerWithRandomFakeVeeContacts];
    veePickerVC.contactPickerDelegate = self;
    [self presentViewController:veePickerVC animated:YES completion:nil];
}

#pragma mark - VeeContact Picker customization templates

- (VeeContactPickerViewController *)pickerWithAddressBookContacts
{
    return [[VeeContactPickerViewController alloc] initWithDefaultConfiguration];
}

//- (VeeContactPickerViewController *)pickerWithRandomFakeVeeContacts
//{
//    NSArray<id<VeeContactProt>> *randomVeeContacts = [VeeContactsForTestingFactory createRandomVeeContacts:100];
//    return [[VeeContactPickerViewController alloc] initWithVeeContacts:randomVeeContacts];
//}

#pragma mark - VeeContactPickerDelegate

- (void)didSelectContact:(id<VeeContactProt>)veeContact
{
    NSLog(@"Selected %@", veeContact);
    [self updateUIForSelectedContact:veeContact];
}

-(void)didCancelContactSelection
{
    NSLog(@"No contact was selected");
    self.selectedContactLabel.text = @"No Contact is selected";
    [self updateUIForNoContactSelected];
}

-(void)didFailToAccessAddressBook
{
    NSLog(@"Failed to access contacts. Have you accepted Address book permissions?");
    [self updateUIForNoContactSelected];
    self.selectedContactLabel.text =  [_selectedContactLabel.text stringByAppendingString:@"Have you gave the permission to access the Address book?"];
}

#pragma mark - UI Utils

-(void)updateUIForNoContactSelected
{
    self.selectedContactLabel.text = @"No Contact is selected.";
    self.selectedContactImageView.hidden = YES;
    self.selectedContactTextView.hidden = YES;
}

-(void)updateUIForSelectedContact:(VeeContact*)veeContact
{
    self.selectedContactLabel.text = @"Selected Contact:";
    [self showSelectedContactImage:veeContact];
    [self showPrettyVeeContactDescription:veeContact];
}

-(void)showSelectedContactImage:(VeeContact*)veeContact
{
    self.selectedContactImageView.hidden = NO;
    if (veeContact.thumbnailImage){
        self.selectedContactImageView.backgroundColor = [UIColor whiteColor];
        self.selectedContactImageView.image = veeContact.thumbnailImage;
    }
    else{
        [self.selectedContactImageView agc_setImageWithInitialsFromName:[veeContact displayName] separatedByString:@" "];
    }
}

-(void)showPrettyVeeContactDescription:(VeeContact*)veeContact
{
    self.selectedContactTextView.hidden = NO;
    self.selectedContactTextView.text = [self prettyVeeContactDescription:veeContact];
}

-(NSString*)prettyVeeContactDescription:(VeeContact*)veeContact
{
    NSString* veeContactDescription = veeContact.description;
    if ([veeContactDescription hasPrefix:@"<VeeContact,\n {\n"]){
        veeContactDescription = [veeContactDescription substringFromIndex:15];
        if ([veeContactDescription hasSuffix:@"\n}>"]){
            return [veeContactDescription substringToIndex:veeContactDescription.length-3];
        }
    }
    return veeContactDescription;
}

@end

NS_ASSUME_NONNULL_END
