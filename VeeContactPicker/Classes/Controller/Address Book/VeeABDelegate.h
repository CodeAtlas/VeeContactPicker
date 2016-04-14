//
//  Created by Andrea Cipriani on 18/03/16.
//  Copyright © 2016 Code Atlas SRL. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol VeeABDelegate <NSObject>

- (void)abPermissionsGranted;
- (void)abPermissionsNotGranted;

@end
