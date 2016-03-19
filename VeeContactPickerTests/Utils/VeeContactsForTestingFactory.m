//
//  Created by Andrea Cipriani on 16/03/16.
//  Copyright © 2016 Code Atlas SRL. All rights reserved.
//

#import "VeeAddressBookForTesting.h"
#import "VeeContact.h"
#import "VeecontactsForTestingFactory.h"

@interface VeeContactsForTestingFactory ()

@property (nonatomic, strong) VeeAddressBookForTesting* veeAddressBookForTesting;

@end

@implementation VeeContactsForTestingFactory

- (instancetype)initWithAddressBookForTesting:(VeeAddressBookForTesting*)veeAddressBookForTesting
{
    self = [super init];
    if (self) {
        _veeAddressBookForTesting = veeAddressBookForTesting;
    }
    return self;
}

#pragma mark - Public methods

- (VeeContact*)veeContactComplete
{
    VeeContact* veeContactComplete = [[VeeContact alloc] initWithLinkedPeopleOfABRecord:[_veeAddressBookForTesting veeContactCompleteRecord]];
    return veeContactComplete;
}

- (VeeContact*)veeContactUnified
{
    VeeContact* veeContactUnified = [[VeeContact alloc] initWithLinkedPeopleOfABRecord:[_veeAddressBookForTesting veeContactUnifiedRecord]];
    return veeContactUnified;
}

- (NSArray<id<VeeContactProt>>*)veeContactsFromAddressBookForTesting
{
    NSMutableArray* veeContactsFromABForTestingMutable = [NSMutableArray new];
    for (id abRecordRefBoxed in [_veeAddressBookForTesting recordRefsOfAddressBookForTesting]) {
        VeeContact* veeContact = [[VeeContact alloc] initWithLinkedPeopleOfABRecord:(__bridge ABRecordRef)(abRecordRefBoxed)];
        [veeContactsFromABForTestingMutable addObject:veeContact];
    }
    return [NSArray arrayWithArray:veeContactsFromABForTestingMutable];
}

+ (NSArray<id<VeeContactProt>>*)createRandomVeeContacts:(NSUInteger)numberOfVeeContacts
{
    NSMutableArray* randomVeeContactsMutable = [NSMutableArray new];
    for (int i = 0; i < numberOfVeeContacts; i++){
        VeeContact* veeContact = [VeeContact new];
        NSMutableSet* recordIds = [[NSMutableSet alloc] initWithObjects:[NSNumber numberWithInt:1000+i],nil];
        [veeContact setValue:recordIds forKey:@"recordIdsMutable"];
        NSDate* now = [NSDate date];
        [veeContact setValue:now forKey:@"createdAt"];
        [veeContact setValue:now forKey:@"modifiedAt"];
        NSString* randomFirstName = [self randomString];
        NSString* randomLastName = [self randomString];
        [veeContact setValue:randomFirstName forKey:@"firstName"];
        [veeContact setValue:randomLastName forKey:@"lastName"];
        [veeContact setValue:[self randomString] forKey:@"middleName"];
        [veeContact setValue:[self randomString] forKey:@"nickname"];
        [veeContact setValue:[self randomString] forKey:@"organizationName"];
        [veeContact setValue:[NSString stringWithFormat:@"%@ %@",randomFirstName,randomLastName] forKey:@"compositeName"];
        //No image
        NSMutableSet* phoneNumbers = [NSMutableSet setWithObjects:[self randomItalianPhoneNumber], [self randomItalianPhoneNumber],[self randomItalianPhoneNumber], nil];
        [veeContact setValue:phoneNumbers forKey:@"phoneNumbersMutable"];
        NSMutableSet* emails = [NSMutableSet setWithObjects:[self randomGmail], [self randomGmail],[self randomGmail], nil];
        [veeContact setValue:emails forKey:@"emailsMutable"];
        [randomVeeContactsMutable addObject:veeContact];
    }
    
    return [[NSArray alloc] initWithArray:randomVeeContactsMutable];
}

+(NSString*)randomString
{
    NSString *alphabet  = @"abcdefghijklmnopqrstuvwxyz";
    NSUInteger alphabetLength = alphabet.length;
    NSUInteger randomStringLength = (arc4random() % 10) +1;
    NSMutableString *mutableString = [NSMutableString stringWithCapacity:randomStringLength];
    for (NSUInteger i = 0U; i < randomStringLength; i++) {
        u_int32_t r = arc4random() % alphabetLength;
        unichar c = [alphabet characterAtIndex:r];
        [mutableString appendFormat:@"%C", c];
    }
    return [NSString stringWithString:mutableString];
}

+(NSString*)randomGmail
{
    return [NSString stringWithFormat:@"%@@gmail.com",[self randomString]];
}

+(NSString*)randomItalianPhoneNumber
{
    return [NSString stringWithFormat:@"+39333%@",[self sevenNumberRandomString]];
}

+(NSString*)sevenNumberRandomString
{
    NSString *alphabet  = @"0123456789";
    NSUInteger alphabetLength = alphabet.length;
    NSMutableString *mutableString = [NSMutableString stringWithCapacity:7];
    for (NSUInteger i = 0U; i < 7; i++) {
        u_int32_t r = arc4random() % alphabetLength;
        unichar c = [alphabet characterAtIndex:r];
        [mutableString appendFormat:@"%C", c];
    }
    return [NSString stringWithString:mutableString];
}

@end
