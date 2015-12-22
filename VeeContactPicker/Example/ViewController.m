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
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showVeecontactPickerPressed:(id)sender {
    /*VeeContactPickerViewController* VeePickerVC = [[VeeContactPickerViewController alloc] initWithCompletionHandler:^(id<ABContact> abContact) {
     if (abContact){
     NSLog(@"Selected %@", [abContact displayName]);
     }
     }];*/
    
    VeeContactPickerViewController* acPickerVC = [[VeeContactPickerViewController alloc] initWithDelegate:self];
    [self presentViewController:acPickerVC animated:YES completion:nil];
}

#pragma mark - VeeContactPickerDelegate

- (void)didSelectABContact:(id<ABContactProt>)abContact
{
    NSLog(@"Selected %@", [abContact displayName]);
}

@end
