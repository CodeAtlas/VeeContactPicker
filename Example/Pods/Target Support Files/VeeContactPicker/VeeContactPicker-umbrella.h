#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "VeeABDelegate.h"
#import "VeeABRecordsImporter.h"
#import "VeeAddressBook.h"
#import "VeeContactCellConfiguration.h"
#import "VeeContactUITableViewCell.h"
#import "VeeContactPickerDelegate.h"
#import "VeeContactPickerViewController.h"
#import "VeeSearchResultsDelegate.h"
#import "VeeSectionedArrayDataSource.h"
#import "VeeTableViewSearchDelegate.h"
#import "VeeContactPickerAppearanceConstants.h"
#import "VeeContactPickerOptions.h"
#import "VeeContactPickerStrings.h"
#import "VeeABRecord.h"
#import "VeeContactFactory.h"
#import "VeeContactFactoryProt.h"
#import "VeeContactProtFactoryProducer.h"
#import "VeeContact.h"
#import "VeeContactProt.h"
#import "VeePostalAddress.h"
#import "VeePostalAddressProt.h"
#import "VeeSectionable.h"
#import "NSObject+VeeCommons.h"
#import "UILabel+VeeBoldify.h"
#import "VeeCommons.h"

FOUNDATION_EXPORT double VeeContactPickerVersionNumber;
FOUNDATION_EXPORT const unsigned char VeeContactPickerVersionString[];

