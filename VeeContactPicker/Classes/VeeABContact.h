//
//  VeeABContact.h
//  VeeContactPicker
//
//  Created by Andrea Cipriani on 14/12/15.
//  Copyright © 2015 Code Atlas SRL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ABContactProt.h"
@import AddressBook;

@interface VeeABContact: NSObject<ABContactProt>

- (instancetype)initWithPerson:(ABRecordRef)person;

-(void)updateDataFromABRecordRef:(ABRecordRef)person;

@property (nonatomic,strong) NSNumber *recordId; //For unified contacts it will be just the first one
@property (nonatomic,strong) UIImage* thumbnailImage;
@property (nonatomic,copy) NSString* firstName;
@property (nonatomic,copy) NSString* lastName;
@property (nonatomic,copy) NSString* middleName;
@property (nonatomic,copy) NSString* nickname;
@property (nonatomic,copy) NSString* organizationName;
@property (nonatomic,copy) NSString* displayName;
@property (nonatomic,strong) NSArray* phoneNumbers;
@property (nonatomic,strong) NSArray* emails;

@property (nonatomic,copy) NSString* sectionIdentifier;

@end
