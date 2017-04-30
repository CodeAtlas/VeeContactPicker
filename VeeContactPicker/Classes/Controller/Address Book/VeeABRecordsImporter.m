#import "VeeABRecordsImporter.h"
#import "VeeABRecord.h"

NS_ASSUME_NONNULL_BEGIN

@implementation VeeABRecordsImporter

#pragma mark - Public methods

- (NSArray<VeeABRecord*>*)importVeeABRecordsFromAddressBook:(ABAddressBookRef)addressBook
{
    if (ABAddressBookGetAuthorizationStatus() != kABAuthorizationStatusAuthorized){
        NSLog(@"Can't import contacts: ABAuthStatus is not authorized");
        return @[];
    }
    NSArray *allSources = (__bridge_transfer NSArray*)(ABAddressBookCopyArrayOfAllSources(addressBook));
    NSMutableSet<VeeABRecord*> *veeABRecords = [NSMutableSet new];

    for (int s = 0; s < allSources.count; s++) {
        ABRecordRef source = (__bridge ABRecordRef)(allSources[s]);
        [veeABRecords addObjectsFromArray:[self importVeeABRecordsFromSingleSource:source ofAddressBook:addressBook]];
    }
    return [NSArray arrayWithArray:veeABRecords.allObjects];
}

- (NSArray<VeeABRecord*>*)importVeeABRecordsFromSingleSource:(ABRecordRef)source ofAddressBook:(ABAddressBookRef)addressBook
{
    NSMutableArray* abRepositoryOfSingleSourceData = [NSMutableArray new];
    NSArray* peopleInSource = CFBridgingRelease(ABAddressBookCopyArrayOfAllPeopleInSource(addressBook, source));
    for (int i = 0; i < peopleInSource.count; i++) {
        ABRecordRef abRecord = CFArrayGetValueAtIndex((__bridge CFArrayRef)(peopleInSource), i);
        VeeABRecord* veeABRecord = [[VeeABRecord alloc] initWithLinkedPeopleOfABRecord:abRecord];
        [abRepositoryOfSingleSourceData addObject:veeABRecord];
    }
    return [NSArray arrayWithArray:abRepositoryOfSingleSourceData];
}

@end

NS_ASSUME_NONNULL_END
