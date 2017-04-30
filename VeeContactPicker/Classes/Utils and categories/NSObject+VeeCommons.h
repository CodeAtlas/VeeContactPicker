@import Foundation;

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (VeeCommons)

- (NSString*)vee_formattedDescriptionOfProperty:(id)property;
- (NSString*)vee_formattedDescriptionOfArray:(NSArray*)array;

@end

NS_ASSUME_NONNULL_END
