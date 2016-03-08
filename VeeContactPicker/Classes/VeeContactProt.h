//
//  ABContactProt.h
//  VeeContactPicker
//
//  Created by Andrea Cipriani on 14/12/15.
//  Copyright © 2015 Code Atlas SRL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol VeeContactProt <NSObject>

@property (nonatomic, readonly, strong) NSSet<NSNumber*>* recordIds;
@property (nonatomic, readonly, strong) NSDate* modifiedAt;
@property (nonatomic, readonly, strong) NSDate* createdAt;
@property (nonatomic, readonly, copy) NSString* firstName;
@property (nonatomic, readonly, copy) NSString* lastName;
@property (nonatomic, readonly, copy) NSString* middleName;
@property (nonatomic, readonly, copy) NSString* nickname;
@property (nonatomic, readonly, copy) NSString* organizationName;
@property (nonatomic, readonly, copy) NSString* compositeName;
@property (nonatomic, readonly, copy) NSString* displayName;
@property (nonatomic, readonly, strong) UIImage* thumbnailImage;

@property (nonatomic, readonly, strong) NSArray<NSString*>* phoneNumbers;
@property (nonatomic, readonly, strong) NSArray<NSString*>* emails;

@property (nonatomic, readonly, copy) NSString* sectionIdentifier;


@end
