//
//  ABContactProt.h
//  VeeContactPicker
//
//  Created by Andrea Cipriani on 14/12/15.
//  Copyright © 2015 Code Atlas SRL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol ABContactProt <NSObject>

@property (nonatomic, strong) NSNumber* recordId; //For unified contacts just choose one recordId
@property (nonatomic, strong) UIImage* thumbnailImage;
@property (nonatomic, copy) NSString* firstName;
@property (nonatomic, copy) NSString* lastName;
@property (nonatomic, copy) NSString* middleName;
@property (nonatomic, copy) NSString* nickname;
@property (nonatomic, copy) NSString* displayName;
@property (nonatomic, copy) NSString* compositeName;
@property (nonatomic, strong) NSArray* phoneNumbers;
@property (nonatomic, strong) NSArray* emails;

@property (nonatomic, copy) NSString* sectionIdentifier;

@end
