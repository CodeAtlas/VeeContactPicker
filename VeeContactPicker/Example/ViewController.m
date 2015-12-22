//
//  ViewController.m
//  VeeContactPicker
//
//  Created by Andrea Cipriani on 21/12/15.
//  Copyright © 2015 Code Atlas SRL. All rights reserved.
//

#import "ViewController.h"
#import "VeeContactPickerViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)showVeecontactPickerPressed:(id)sender {
    
     //With Completion Block
    /*
     VeeContactPickerViewController* veePickerVC = [[VeeContactPickerViewController alloc] initWithCompletionHandler:^(id<ABContact> abContact) {
     if (abContact){
     NSLog(@"Selected %@", [abContact displayName]);
     }
     }];
     */
    
    //With delegation
    VeeContactPickerViewController* veePickerVC = [[VeeContactPickerViewController alloc] initWithDelegate:self];
    //veePickerVC.showContactDetailLabel = YES;
    //veePickerVC.showFirstNameFirst = NO;
    
    //Generate colors for a palette
    NSMutableArray *colors = [NSMutableArray array];
    for (float hue = 0.0; hue < 1.0; hue += 0.05) {
        UIColor *color = [UIColor colorWithHue:hue saturation:0.5 brightness:0.5 alpha:1.0];
        [colors addObject:color];
    }
    veePickerVC.contactLettersColorPalette = colors;
    
    //Present the VeePickerViewController
    [self presentViewController:veePickerVC animated:YES completion:nil];
}

#pragma mark - VeeContactPickerDelegate

- (void)didSelectABContact:(id<ABContactProt>)abContact
{
    NSLog(@"Selected %@", [abContact displayName]);
}

@end
