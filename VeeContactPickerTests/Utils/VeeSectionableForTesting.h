//
//  Created by Andrea Cipriani on 19/03/16.
//  Copyright © 2016 Code Atlas SRL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VeeSectionable.h"

@interface VeeSectionableForTesting : NSObject <VeeSectionable>

@property (nonatomic,copy) NSString* sectionIdentifier;
@property (nonatomic,copy) NSString* id;

@end
