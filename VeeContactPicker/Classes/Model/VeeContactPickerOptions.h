//
//  VeeContactPickerOptions.h
//  VeeContactPicker
//
//  Created by Andrea Cipriani on 14/03/16.
//  Copyright © 2016 Code Atlas SRL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface VeeContactPickerOptions : NSObject

+(VeeContactPickerOptions*)defaultOptions;

@property (nonatomic, copy) NSArray<NSString*>* sectionIdentifiers; //Contacts section identifiers, default are [[[UILocalizedIndexedCollation currentCollation] sectionIndexTitles]
@property (nonatomic, copy) NSString* sectionIdentifierWildcard; //For contacts with unrecognized section identifier, default section is '#' as in the iOS address book

//@property (nonatomic, assign) BOOL showContactDetailLabel;
//@property (nonatomic, assign) VeeContactDetail veeContactDetail; //Default value is VeeContactDetailPhoneNumber
//@property (nonatomic, assign) BOOL showFirstNameFirst;
//@property (nonatomic, assign) BOOL showLettersWhenContactImageIsMissing; //Default value is YES
//@property (nonatomic, assign) UIImage* contactThumbnailImagePlaceholder; //Used when showLettersWhenContactImageIsMissing = NO

//When you want to show a detail label for all contacts, this enum defines which field to show into it
/*typedef NS_ENUM(NSInteger, VeeContactDetail) {
    //Default
    VeeContactDetailPhoneNumber, //0
    VeeContactDetailEmail, //1
};
 */

@end
