//
//  VeeContactPickerStrings.h
//  VeeContactPicker
//
//  Created by Andrea Cipriani on 14/03/16.
//  Copyright © 2016 Code Atlas SRL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VeeContactPickerStrings : NSObject

- (instancetype)initWithDefaultStrings;
- (instancetype)initWithNavigationBarTitle:(NSString*)navigationBarTitle andCancelButtonTitle:(NSString*)cancelButtonTitle;

@property (nonatomic, strong) NSString* navigationBarTitle;
@property (nonatomic, strong) NSString* cancelButtonTitle;

@end
