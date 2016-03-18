//  Created by Andrea Cipriani on 14/03/16.
//  Copyright © 2016 Code Atlas SRL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class VeeContactColors;

@interface VeeContactPickerOptions : NSObject

#pragma mark - Init

-(instancetype)initWithDefaultOptions;

//TODO: use builder block to avoid this huge init method
-(instancetype)initWithSectionIdentifiers:(NSArray<NSString*>*)sectionIdentifiers andSectionIdentifierWildcard:(NSString*)sectionIdentifierWildcard andShowLettersWhenContactImageIsMissing:(BOOL)showLettersWhenContactImageIsMissing andContactThumbnailImagePlaceholder:(UIImage*)contactThumbnailImagePlaceholder;

+(VeeContactPickerOptions*)defaultOptions;

@property (nonatomic, copy) NSArray<NSString*>* sectionIdentifiers; //Contacts section identifiers, default are [[[UILocalizedIndexedCollation currentCollation] sectionIndexTitles]
@property (nonatomic, copy) NSString* sectionIdentifierWildcard; //Section identifier for contacts that don't fit in a section, default is '#' as in the iOS address book
@property (nonatomic, assign) BOOL showLettersWhenContactImageIsMissing; //Default value is YES
@property (nonatomic, strong) UIImage* contactThumbnailImagePlaceholder; //Image shown when showLettersWhenContactImageIsMissing is NO and the contact doesn't have an image

@end
