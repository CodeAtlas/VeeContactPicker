#import "VeeSectionableForTesting.h"

@implementation VeeSectionableForTesting

-(instancetype)initWithSectionIdentifier:(NSString*)sectionIdentifier
{
    self = [super init];
    if (self) {
        _id = [NSProcessInfo processInfo].globallyUniqueString;
        _sectionIdentifier = sectionIdentifier;
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _id = [NSProcessInfo processInfo].globallyUniqueString;
    }
    return self;
}

-(NSString*)description
{
    return [NSString stringWithFormat:@"VeeSectionableForTesting id: %@ sectionIdentifier: %@",_id,_sectionIdentifier];
}

@end
