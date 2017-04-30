//
//  Created by Andrea Cipriani on 19/03/16.
//  Copyright © 2016 Code Atlas SRL. All rights reserved.
//

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
