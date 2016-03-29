//
//  Created by Andrea Cipriani on 08/03/16.
//  Copyright © 2016 Code Atlas SRL. All rights reserved.
//

#import "VeeAddressBookForTesting.h"
#import "VeeAddressBookForTestingConstants.h"

@interface VeeAddressBookForTesting ()

@property (nonatomic) ABAddressBookRef addressBook;
@end

@implementation VeeAddressBookForTesting

#pragma mark - Init

- (instancetype)init
{
    if (self = [super init]) {
        NSAssert(ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized, @"ABAddressBookGetAuthorizationStatus is not authorized!");
        CFErrorRef* cfError = nil;
        _addressBook = ABAddressBookCreateWithOptions(NULL, cfError);
        if (cfError) {
            NSLog(@"Error while creating address book");
        }
    }
    return self;
}

#pragma mark - Public methods

- (void)addVeeTestingContactsToAddressBook
{
    NSURL* vcfURL = [[NSBundle bundleForClass:self.class] URLForResource:kVCFFileName withExtension:@"vcf"];
    CFDataRef vcfDataRef = (CFDataRef)CFBridgingRetain([NSData dataWithContentsOfURL:vcfURL]);
    NSAssert(vcfDataRef, @"%@ not found", kVCFFileName);

    ABRecordRef defaultSource = ABAddressBookCopyDefaultSource(_addressBook);
    CFArrayRef vcfContactsInDefaultSource = ABPersonCreatePeopleInSourceWithVCardRepresentation(defaultSource, vcfDataRef);
    [self addABRecordsToAddressBook:vcfContactsInDefaultSource];
}

- (void)deleteVeeTestingContactsFromAddressBook
{
    NSArray* allPeople = CFBridgingRelease(ABAddressBookCopyArrayOfAllPeople(_addressBook));
    NSInteger numberOfPeople = [allPeople count];
    for (NSInteger i = 0; i < numberOfPeople; i++) {
        ABRecordRef person = (__bridge ABRecordRef)allPeople[i];
        CFErrorRef* cfError = nil;
        if ([self isVeeTestingContact:person]) {
            BOOL result = ABAddressBookRemoveRecord(_addressBook, person, cfError);
            if (cfError || !result) {
                NSLog(@"Error while adding record into test address book");
            }
        }
    }
    [self saveABContext];
}

- (ABRecordRef)abRecordRefOfCompleteContact
{
    return [self veeTestingContactWithFirstName:kCompleteVeeContactFirstName];
}

- (ABRecordRef)abRecordRefOfUnifiedContact
{
    return [self veeTestingContactWithFirstName:kUnifiedVeecontactFirstName];
}

- (NSArray*)abRecordRefsOfTestingContacts
{
    NSMutableArray* testingRecordRefsMutable = [NSMutableArray new];
    NSArray* allPeople = CFBridgingRelease(ABAddressBookCopyArrayOfAllPeople(_addressBook));
    NSInteger numberOfPeople = [allPeople count];
    for (NSInteger i = 0; i < numberOfPeople; i++) {
        ABRecordRef recordRef = (__bridge ABRecordRef)allPeople[i];
        if ([self isVeeTestingContact:recordRef]) {
            [testingRecordRefsMutable addObject:(__bridge id _Nonnull)(recordRef)];
        }
    }
    return [NSArray arrayWithArray:testingRecordRefsMutable];
}

#pragma mark - Private utils

- (BOOL)isVeeTestingContact:(ABRecordRef)abRecord
{
    NSArray* linkedPeople = (__bridge NSArray*)ABPersonCopyArrayOfAllLinkedPeople(abRecord);
    for (int i = 0; i < linkedPeople.count; i++) {
        ABRecordRef linkedABRecord = CFArrayGetValueAtIndex((__bridge CFArrayRef)(linkedPeople), i);
        if ([self containsVeeTestingContactSignature:linkedABRecord]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)containsVeeTestingContactSignature:(ABRecordRef)abRecord
{
    NSString* abRecordNote = CFBridgingRelease(ABRecordCopyValue(abRecord, kABPersonNoteProperty));
    if ([abRecordNote containsString:kVeeTestingContactsSignature]) {
        return YES;
    }
    return NO;
}

- (ABRecordRef)veeTestingContactWithFirstName:(NSString*)firstName
{
    NSArray* allPeople = CFBridgingRelease(ABAddressBookCopyArrayOfAllPeople(_addressBook));
    NSInteger numberOfPeople = [allPeople count];
    for (NSInteger i = 0; i < numberOfPeople; i++) {
        ABRecordRef abRecord = (__bridge ABRecordRef)allPeople[i];
        if ([self isVeeTestingContact:abRecord]) {
            NSString* abRecordFirstName = CFBridgingRelease(ABRecordCopyValue(abRecord, kABPersonFirstNameProperty));
            if ([abRecordFirstName isEqualToString:firstName]) {
                return abRecord;
            }
        }
    }
    return nil;
}

/*
- (void)exportABtoVCF:(NSString*)vcfFileName
{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* filePath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.vcf", vcfFileName]];
    NSError* error;
    [fileManager removeItemAtPath:filePath error:&error];
    CFArrayRef peopleArray = ABAddressBookCopyArrayOfAllPeople(_addressBook);
    NSData* vCardData = CFBridgingRelease(ABPersonCreateVCardRepresentationWithPeople(peopleArray));
    [vCardData writeToFile:filePath atomically:YES];
}
 */

#pragma mark - AB Utils

- (void)addABRecordsToAddressBook:(CFArrayRef)abRecords
{
    for (CFIndex index = 0; index < CFArrayGetCount(abRecords); index++) {
        ABRecordRef person = CFArrayGetValueAtIndex(abRecords, index);
        CFErrorRef* cfError = nil;

        BOOL result = ABAddressBookAddRecord(_addressBook, person, cfError);
        if (cfError || !result) {
            NSLog(@"Error while adding record into test address book");
        }
    }
    [self saveABContext];
}

- (void)saveABContext
{
    CFErrorRef* cfError;
    BOOL success = ABAddressBookSave(_addressBook, cfError);
    if (cfError || success == NO) {
        NSLog(@"Error while saving test address book context");
    }
}

@end
