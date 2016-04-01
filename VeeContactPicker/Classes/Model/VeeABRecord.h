//
//  Created by Andrea Cipriani on 22/03/16.
//  Copyright © 2016 Code Atlas SRL. All rights reserved.
//

@import AddressBook;
@import UIKit;
@import Foundation;

@interface VeeABRecord : NSObject

- (instancetype)initWithLinkedPeopleOfABRecord:(ABRecordRef)abRecordRef;

@property (nonatomic, readonly, strong) NSArray<NSNumber*>* recordIds;
@property (nonatomic, readonly, strong) NSDate* modifiedAt;
@property (nonatomic, readonly, strong) NSDate* createdAt;
@property (nonatomic, readonly, copy) NSString* firstName;
@property (nonatomic, readonly, copy) NSString* lastName;
@property (nonatomic, readonly, copy) NSString* middleName;
@property (nonatomic, readonly, copy) NSString* nickname;
@property (nonatomic, readonly, copy) NSString* organizationName;
@property (nonatomic, readonly, copy) NSString* compositeName;
@property (nonatomic, readonly, strong) UIImage* thumbnailImage;
@property (nonatomic, strong) NSArray<NSString*>* phoneNumbers;
@property (nonatomic, strong) NSArray<NSString*>* emails;
@property (nonatomic, strong) NSArray<NSDictionary*>* postalAddresses;
@property (nonatomic, strong) NSArray<NSString*>* websites;
@property (nonatomic, strong) NSArray<NSString*>* facebookAccounts;
@property (nonatomic, strong) NSArray<NSString*>* twitterAccounts;

@end
