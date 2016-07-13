//
//  Created by Andrea Cipriani on 11/05/16.
//

#import "NSObject+AGCDescription.h"
#import "AGCDescription.h"

@implementation NSObject (AGCDescription)

- (NSString*)agc_description
{
    AGCDescription* agcObjectDescription = [[AGCDescription alloc] initWithTargetObject:self];
    return [agcObjectDescription description];
}

- (NSString*)agc_descriptionIgnoringPropertiesWithNames:(NSArray<NSString*>*)propertiesToIgnore
{
    AGCDescription* agcObjectDescription = [[AGCDescription alloc] initWithTargetObject:self andPropertyNamesToIgnore:propertiesToIgnore];
    return [agcObjectDescription description];
}

- (NSString*)agc_debugDescription
{
    AGCDescription* agcObjectDescription = [[AGCDescription alloc] initWithTargetObject:self];
    return [agcObjectDescription debugDescription];
}

- (NSString*)agc_debugDescriptionIgnoringPropertiesWithNames:(NSArray<NSString*>*)propertiesToIgnore
{
    AGCDescription* agcObjectDescription = [[AGCDescription alloc] initWithTargetObject:self andPropertyNamesToIgnore:propertiesToIgnore];
    return [agcObjectDescription debugDescription];
}

@end
