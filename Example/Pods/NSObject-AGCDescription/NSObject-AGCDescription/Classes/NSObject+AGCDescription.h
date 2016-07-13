//
//  Created by Andrea Cipriani on 11/05/16.
//

#import <Foundation/Foundation.h>

@interface NSObject (AGCDescription)

NS_ASSUME_NONNULL_BEGIN

- (NSString*)agc_description;
- (NSString*)agc_descriptionIgnoringPropertiesWithNames:(NSArray<NSString*>*)propertiesToIgnore;

- (NSString*)agc_debugDescription;
- (NSString*)agc_debugDescriptionIgnoringPropertiesWithNames:(NSArray<NSString*>*)propertiesToIgnore;

NS_ASSUME_NONNULL_END

@end
