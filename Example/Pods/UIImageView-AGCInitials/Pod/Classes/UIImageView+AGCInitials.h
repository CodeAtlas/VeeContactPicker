//
//  Created by Andrea Cipriani on 07/04/16.
//
//

#import <UIKit/UIKit.h>

@class AGCInitialsColors;

@interface UIImageView (AGCInitials)

- (void)agc_setImageWithInitials:(nonnull NSString*)initials;
- (void)agc_setImageWithInitials:(nonnull NSString*)initials andTextAttributes:(nonnull NSDictionary*)textAttributes;
- (void)agc_setImageWithInitialsFromName:(nonnull NSString*)name;
- (void)agc_setImageWithInitialsFromName:(nonnull NSString*)name separatedByString:(nonnull NSString*)separator;
- (void)agc_setImageWithInitialsFromName:(nonnull NSString*)name withTextAttributes:(nonnull NSDictionary*)textAttributes;
- (void)agc_setImageWithInitialsFromName:(nonnull NSString*)name separatedByString:(nonnull NSString*)separator withTextAttributes:(nonnull NSDictionary*)textAttributes;
- (void)agc_setImageWithInitials:(nonnull NSString*)initials stringToGenerateColor:(nonnull NSString*)stringToGenerateColor textAttributes:(nonnull NSDictionary*)textAttributes; //Designated initializer

@end
