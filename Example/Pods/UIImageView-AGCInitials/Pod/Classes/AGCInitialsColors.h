//
//  Created by Andrea Cipriani on 07/04/16.
//
//

#import <Foundation/Foundation.h>
@import UIKit;

@interface AGCInitialsColors : NSObject

+ (id _Nonnull)sharedInstance;

@property (nonatomic, nonnull, strong) NSArray<UIColor*>* colorPalette;
- (UIColor* _Nonnull)colorForString:(NSString* _Nullable)string;

@end
