//
//  Created by Andrea Cipriani on 10/05/16.
//

#import "AGCPropertyConstants.h"
@import UIKit;

@implementation AGCPropertyConstants

+ (id)sharedInstance
{
    static AGCPropertyConstants* sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        [sharedInstance loadConstants];
    });
    return sharedInstance;
}

- (void)loadConstants
{
    _standardClassesWithCustomDescription = @[ NSData.class, UIImage.class ];
    _standardClassesWithShortDescription = @[ NSString.class, NSAttributedString.class, NSNumber.class, NSDate.class, UIView.class, NSBundle.class, NSCache.class, NSCalendar.class, NSError.class, NSLock.class, NSLocale.class, NSData.class ];
    _defaultIgnoredPropertyNames = @[ @"hash", @"description", @"debugDescription" ];
}

NSString* const kAGCNilWildcard = @"AGC_nil";

@end
