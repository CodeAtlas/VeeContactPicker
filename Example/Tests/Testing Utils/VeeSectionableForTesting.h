#import "VeeSectionable.h"
#import <Foundation/Foundation.h>

@interface VeeSectionableForTesting : NSObject <VeeSectionableProt>

- (instancetype)initWithSectionIdentifier:(NSString*)sectionIdentifier;
@property (nonatomic, copy) NSString* sectionIdentifier;
@property (nonatomic, copy) NSString* id;

@end
