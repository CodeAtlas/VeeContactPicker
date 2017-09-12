### VeeContactPicker

[![CI Status](http://img.shields.io/travis/CodeAtlas/VeeContactPicker.svg?style=flat)](https://travis-ci.org/CodeAtlas/VeeContactPicker)
[![Version](https://img.shields.io/cocoapods/v/VeeContactPicker.svg?style=flat)](http://cocoapods.org/pods/VeeContactPicker)
[![License](https://img.shields.io/cocoapods/l/VeeContactPicker.svg?style=flat)](http://cocoapods.org/pods/VeeContactPicker)
[![Platform](https://img.shields.io/cocoapods/p/VeeContactPicker.svg?style=flat)](http://cocoapods.org/pods/VeeContactPicker)

![VeeContactPicker Example](Screenshots/VeeContactPicker.gif)

**VeeContactPicker** is an Objective-C replacement of the buggy *ABPeoplePickerNavigationController*: a ViewController for selecting contacts from the address book.

### Features

- 🏃🏿 It loads the contacts very **fast**! Note that the official *ABPeoplePickerNavigationController* is really slow: see [this thread](http://stackoverflow.com/questions/30372190/is-abpeoplepickernavigationcontroller-slow))
- 👨‍👨‍👧‍👧 You can select multiple contacts!  🎉🎉 New from v1 🎉🎉
- 🔵 Contacts' **images** and coloured placeholders
- 🔍 Search for your contacts! Also by email address or phone number.
- 🛂 Choose the contacts that you want to show in the picker (e.g only contacts with a valid email address)
- 🤡 Easy **customizable appearance**
- ✅ Good test coverage

### How to use it - Basic

Import the ViewController:

```objective-c
# import "VeeContactPickerViewController.h"
```

Initialize it and set the delegate:

```objective-c
VeeContactPickerViewController *veeContactPickerViewController = [[VeeContactPickerViewController alloc] initWithDefaultConfiguration];
veeContactPickerViewController.contactPickerDelegate = self;
//do you want to select multiple contacts? veeContactPickerViewController.multipleSelection = YES;
[self presentViewController:veeContactPickerViewController animated:YES completion:nil];

```

Implement the delegate:

```objective-c
- (void)didSelectContact:(id<VeeContactProt>)veeContact
{
    //veeContact was selected
}

- (void)didSelectContacts:(NSArray<id<VeeContactProt>> *)veeContacts
{
    //veeContact were selected
}

- (void)didCancelContactSelection
{
  //No contact was selected
}

- (void)didFailToAccessAddressBook
{
  //Show an error?
}

```
That's all folks!

### How to use it - Details

You can customize some properties of the picker by changing the *VeeContactPickerOptions* object and pass it to the initializer:

```objective-c
- (instancetype)initWithOptions:(VeeContactPickerOptions*)veeContactPickerOptions;
```

For example, if you don't like the contacts' initials images as the placeholder, you can set your own placeholder image:

```objective-c
VeeContactPickerOptions *veeContactPickerOptions = [VeeContactPickerOptions alloc] initWithDefaultOptions];
veeContactPickerOptions.showInitialsPlaceholder = NO;
veeContactPickerOptions.contactThumbnailImagePlaceholder = [UIImage imageNamed:@"your_placeholder"];
//...
VeeContactPickerViewController *veeContactPickerViewController = [[VeeContactPickerViewController alloc] initWithOptions:veeContactPickerOptions];
//...
```
Contact's image placeholder are provided by *AGCInitials*. You can customize the color palette if you want, see the [README of AGCInitials](https://github.com/andreacipriani/UIImageView-AGCInitials/blob/master/README.md).

- If you want to change or localize the strings shown by the picker, look at this property:

```objective-c
veeContactPickerOptions.veeContactPickerStrings
```

<!--
- NSArray<NSString*>* sectionIdentifiers; //Contacts section identifiers, default are [[[UILocalizedIndexedCollation currentCollation] sectionIndexTitles]
@property (nonatomic, copy) NSString *sectionIdentifierWildcard; //Section identifier for contacts that don't fit in a section, default is '#' as in the iOS address book
-->

- If you want to choose which contacts to show, you can initialize the picker using:

```objective-c
- (instancetype)initWithVeeContacts:(NSArray<id<VeeContactProt>>*)veeContacts;
```

**Picker Appearance:**

You can customize the appearance of the contact picker by manipulating the object *VeeContactPickerAppearanceConstants*, before loading the picker.

For example:

```objective-c
[[VeeContactPickerAppearanceConstants sharedInstance] setNavigationBarTintColor:[UIColor purpleColor]];
[[VeeContactPickerAppearanceConstants sharedInstance] setNavigationBarTranslucent:NO];
[[VeeContactPickerAppearanceConstants sharedInstance] setContactCellPrimaryLabelFont:[UIFont yourFont]];
//...
[self presentViewController:veeContactPickerViewController animated:YES completion:nil];

```

### Run the example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

Or you can even try the example online with [Appetize](https://appetize.io/app/c1c5x3vpf7hgngkrr3dr1qabem?device=iphone5s&scale=75&orientation=portrait&osVersion=9.3).

### Requirements

- iOS 8+

### Installation

VeeContactPicker is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "VeeContactPicker"
```

### Author

Andrea Cipriani andrea.g.cipriani@gmail.com - Code Atlas SRL

### License

VeeContactPicker is available under the MIT license. See the LICENSE file for more info.

### App Store
VeeContactPicker is already used in the App Store for our app [**Veer Contacts Widget**](https://itunes.apple.com/app/id1024064196); if you appreciate our work, you can download the app for free! 🤗
