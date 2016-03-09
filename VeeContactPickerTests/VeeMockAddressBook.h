//
//  VeeTestAddressBook.h
//  VeeContactPicker
//
//  Created by Andrea Cipriani on 08/03/16.
//  Copyright © 2016 Code Atlas SRL. All rights reserved.
//

#import <Foundation/Foundation.h>
@import AddressBook;

@interface VeeMockAddressBook : NSObject

-(void)addVeeMockContactsToAddressBook;
-(void)deleteVeeMockContactsFromAddressBook;
-(ABRecordRef)veeMockSuperContact;

@end
