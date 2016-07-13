//
//  Created by Andrea Cipriani on 10/05/16.
//

#import <Foundation/Foundation.h>

@interface AGCPropertyConstants : NSObject

+ (nonnull id)sharedInstance;

NS_ASSUME_NONNULL_BEGIN

@property (nonatomic, strong) NSArray* standardClassesWithCustomDescription;
@property (nonatomic, strong) NSArray* standardClassesWithShortDescription;
@property (nonatomic, strong) NSArray* defaultIgnoredPropertyNames;

extern NSString* const kAGCNilWildcard;

NS_ASSUME_NONNULL_END

@end
