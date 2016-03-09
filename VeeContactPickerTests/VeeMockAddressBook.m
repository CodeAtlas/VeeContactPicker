//
//  VeeTestAddressBook.m
//  VeeContactPicker
//
//  Created by Andrea Cipriani on 08/03/16.
//  Copyright © 2016 Code Atlas SRL. All rights reserved.
//

#import "VeeMockAddressBook.h"

#define VCF_FILE_NAME @"vee_mock_ab"
#define VEE_MOCK_CONTACT_SIGNATURE @"a8a8f8738b79cd660f519c1a342654a0"

@interface VeeMockAddressBook()

@property (nonatomic) ABAddressBookRef addressBook;
@end

@implementation VeeMockAddressBook

#pragma mark - Init

-(instancetype)init
{
    if (self = [super init]){
        NSAssert(ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized, @"ABAddressBookGetAuthorizationStatus is not authorized!");
        CFErrorRef *cfError = nil;
        _addressBook = ABAddressBookCreateWithOptions(NULL, cfError);
        if (cfError){
            NSLog(@"Error while creating address book");
        }
    }
    return self;
}

#pragma mark - Public methods

-(void)addVeeMockContactsToAddressBook
{
    NSURL* vcfURL = [[NSBundle bundleForClass:self.class] URLForResource:VCF_FILE_NAME withExtension:@"vcf"];
    CFDataRef vcfDataRef = (CFDataRef)CFBridgingRetain([NSData dataWithContentsOfURL:vcfURL]);
    NSAssert(vcfDataRef, @"%@ not found",VCF_FILE_NAME);
    
    ABRecordRef defaultSource = ABAddressBookCopyDefaultSource(_addressBook);
    CFArrayRef vcfContactsInDefaultSource = ABPersonCreatePeopleInSourceWithVCardRepresentation(defaultSource, vcfDataRef);
    [self addABRecordsToAddressBook:vcfContactsInDefaultSource];
}

-(void)deleteVeeMockContactsFromAddressBook
{
    NSArray* allPeople = CFBridgingRelease(ABAddressBookCopyArrayOfAllPeople(_addressBook));
    NSInteger numberOfPeople = [allPeople count];
    for (NSInteger i = 0; i < numberOfPeople; i++) {
        ABRecordRef person = (__bridge ABRecordRef)allPeople[i];
        CFErrorRef *cfError = nil;
        if ([self isVeeMockContact:person]){
            BOOL result = ABAddressBookRemoveRecord(_addressBook, person, cfError);
            if (cfError || !result){
                NSLog(@"Error while adding record into test address book");
            }
        }
    }
    [self saveABContext];
}

-(ABRecordRef)veeMockSuperContact
{
    NSArray* allPeople = CFBridgingRelease(ABAddressBookCopyArrayOfAllPeople(_addressBook));
    NSInteger numberOfPeople = [allPeople count];
    for (NSInteger i = 0; i < numberOfPeople; i++) {
        ABRecordRef abRecord = (__bridge ABRecordRef)allPeople[i];
        if ([self isVeeMockContact:abRecord]){
            NSString* abRecordFirstName = CFBridgingRelease(ABRecordCopyValue(abRecord, kABPersonFirstNameProperty));
            if ([abRecordFirstName isEqualToString:@"Super"]){
                return abRecord;
            }
        }
    }
    return nil;
}

#pragma mark - Private utils

-(BOOL)isVeeMockContact:(ABRecordRef)abRecord
{
    NSArray* linkedPeople = (__bridge NSArray*)ABPersonCopyArrayOfAllLinkedPeople(abRecord);
    for (int i = 0; i < linkedPeople.count; i++) {
        ABRecordRef linkedABRecord = CFArrayGetValueAtIndex((__bridge CFArrayRef)(linkedPeople), i);
        if ([self containsVeeMockSignature:linkedABRecord]){
            return YES;
        }
    }
    return NO;
}

-(BOOL)containsVeeMockSignature:(ABRecordRef)abRecord
{
    NSString* abRecordNote = CFBridgingRelease(ABRecordCopyValue(abRecord, kABPersonNoteProperty));
    if ([abRecordNote containsString:VEE_MOCK_CONTACT_SIGNATURE]){
        return YES;
    }
    return NO;
}

#pragma mark - AB Utils

-(void)addABRecordsToAddressBook:(CFArrayRef)abRecords
{
    for (CFIndex index = 0; index < CFArrayGetCount(abRecords); index++) {
        ABRecordRef person = CFArrayGetValueAtIndex(abRecords, index);
        CFErrorRef *cfError = nil;
        
        BOOL result = ABAddressBookAddRecord(_addressBook, person, cfError);
        if (cfError || !result){
            NSLog(@"Error while adding record into test address book");
        }
    }
    [self saveABContext];
}

-(void)saveABContext
{
    CFErrorRef *cfError;
    BOOL success = ABAddressBookSave(_addressBook, cfError);
    if (cfError || success == NO){
        NSLog(@"Error while saving test address book context");
    }
}

@end
