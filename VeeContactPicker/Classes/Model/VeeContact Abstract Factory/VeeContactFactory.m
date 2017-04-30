#import "VeeContactFactory.h"
#import "VeeABRecordsImporter.h"
#import "VeeABRecord.h"
#import "VeeContact.h"

NS_ASSUME_NONNULL_BEGIN

@implementation VeeContactFactory

+(NSArray<id<VeeContactProt>>*)veeContactProtsFromAddressBook:(ABAddressBookRef)addressBook
{
    VeeABRecordsImporter* abRepositoryImporter = [VeeABRecordsImporter new];
    NSArray<VeeABRecord*>* veeABRecords = [abRepositoryImporter importVeeABRecordsFromAddressBook:addressBook];
    NSMutableArray* veeContacts = [NSMutableArray new];
    for (VeeABRecord* veeABRecord in veeABRecords){
        id<VeeContactProt> veeContact = [[VeeContact alloc] initWithVeeABRecord:veeABRecord];
        [veeContacts addObject:veeContact];
    }
    return [NSArray arrayWithArray:veeContacts];
}

@end

NS_ASSUME_NONNULL_END
