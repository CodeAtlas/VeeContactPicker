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
     }];*/
    
    //With delegation
    VeeContactPickerViewController* veePickerVC = [[VeeContactPickerViewController alloc] initWithDelegate:self];
    [self presentViewController:veePickerVC animated:YES completion:nil];
}

#pragma mark - VeeContactPickerDelegate

- (void)didSelectABContact:(id<ABContactProt>)abContact
{
    NSLog(@"Selected %@", [abContact displayName]);
}

@end
