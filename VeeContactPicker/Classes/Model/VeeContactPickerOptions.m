//
//  VeeContactPickerOptions.m
//  VeeContactPicker
//
//  Created by Andrea Cipriani on 14/03/16.
//  Copyright © 2016 Code Atlas SRL. All rights reserved.
//

#import "VeeContactPickerOptions.h"

@implementation VeeContactPickerOptions

-(instancetype)initWithDefaultOptions
{
    if (self = [super init]){
        _sectionIdentifiers= [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles];
        _sectionIdentifierWildcard = @"#";
       
        //Default options:
        //_showContactDetailLabel = NO;
        //_showFirstNameFirst = YES;
        //_veeContactDetail = VeeContactDetailPhoneNumber;
        //_showLettersWhenContactImageIsMissing = YES;
    }
    return self;
}

+(VeeContactPickerOptions*)defaultOptions
{
    VeeContactPickerOptions* defaultOptions = [[self alloc] initWithDefaultOptions];
    return defaultOptions;
}

@end
