//
//  Created by Andrea Cipriani on 19/03/16.
//  Copyright © 2016 Code Atlas SRL. All rights reserved.
//

#import "VeeSectionable.h"
#import <Foundation/Foundation.h>

@interface VeeSectionableForTesting : NSObject <VeeSectionable>

- (instancetype)initWithSectionIdentifier:(NSString*)sectionIdentifier;
@property (nonatomic, copy) NSString* sectionIdentifier;
@property (nonatomic, copy) NSString* id;

@end
