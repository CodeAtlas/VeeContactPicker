//
//  Created by Andrea Cipriani on 10/03/16.
//  Copyright © 2016 Code Atlas SRL. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface XCTest (VeeCommons)

- (void)nullifyIvarWithName:(NSString*)iVarSelectorName ofObject:(id)object;
- (void)assertObject:(id)object respondToSelectorWithName:(NSString*)selectorName;
@property (NS_NONATOMIC_IOSONLY, readonly, strong) UIImage *veeTestImage;
@property (NS_NONATOMIC_IOSONLY, readonly, strong) NSBundle *veeContactPickerBundle;

@end
