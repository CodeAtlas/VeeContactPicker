# UIImageView-AGCInitials

[![CI Status](http://img.shields.io/travis/AndreaCipriani/UIImageView-AGCInitials.svg?style=flat)](https://travis-ci.org/AndreaCipriani/UIImageView-AGCInitials)
[![Version](https://img.shields.io/cocoapods/v/UIImageView-AGCInitials.svg?style=flat)](http://cocoapods.org/pods/UIImageView-AGCInitials)
[![License](https://img.shields.io/cocoapods/l/UIImageView-AGCInitials.svg?style=flat)](http://cocoapods.org/pods/UIImageView-AGCInitials)
[![Platform](https://img.shields.io/cocoapods/p/UIImageView-AGCInitials.svg?style=flat)](http://cocoapods.org/pods/UIImageView-AGCInitials)

![AGCInitials Example gif](http://i.giphy.com/HyFTIFTbDkF2M.gif)

<!-- 
![AGCInitials Example screenshot 1](http://i.imgur.com/ZHagHyK.png) 
![AGCInitials Example screenshot 2](http://i.imgur.com/a5bBMub.png)
-->

## Why

When you are displaying contacts in your app it's cool to show a colored placeholder with the contact's initials!

There are other categories on Github to set an image placeholder with the initials of a contact, but they can't' be used inside a Table View because the background color change with cell recycle. 🤔

With *UIImageView+AGCInitials* it's **super-easy** to set the image placeholder with the contact's initials and background colors will remain the same for identical names, so **you can use it in your table/collection view**. 😎

Plus: good test coverage - easy customization! 💪

## Requirements

iOS 7+

## Installation with Cocoapods

UIImageView-AGCInitials is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "UIImageView-AGCInitials"
```

## Installation without Cocoapods

Copy and paste *AGCInitialsColors.h/m* and *UIImageView+AGCInitials.h/m* classes into your project.

## How to use it - Basic

Import the category 

```objective-c
#import "UIImageView+AGCInitials.h"
```
and then just use it:

```objective-c
[_anImageView agc_setImageWithInitialsFromName:@"Mick Jagger" separatedByString:@" "];
```
The image will contain a placeholder with the initials "MJ" and a generated background color.

## How to use it - Details

If you want you can **customize the font** by specifying the text attributes:

```objective-c
NSDictionary* initialsTextAttributes = @{ NSFontAttributeName : [UIFont systemFontOfSize:20], NSForegroundColorAttributeName : [UIColor purpleColor] };
[cellImageView agc_setImageWithInitialsFromName:@"Mick Jagger" separatedByString:@" " withTextAttributes:initialsTextAttributes];
```

You can also customize the **color palette** used to generate background colors:

```objective-c
#import "AGCInitialsColors.h"
```

And then just set your palette before using the category:

```objective-c
NSArray<UIColor*>* yourColorPalette; //...
[[AGCInitialsColors sharedInstance] setColorPalette:yourColorPalette];
```

## Run the example 

To run the example project, clone the repo, and run `pod install` from the Example directory first. 

You can also see a demo online here: https://appetize.io/app/1h801604jew4ppeeqt67qn54n4

## Author

Andrea Cipriani, andrea.g.cipriani@gmail.com - Twitter [@AndreaCipriani](https://twitter.com/AndreaCipriani)

## License

UIImageView-AGCInitials is available under the MIT license. See the LICENSE file for more info.
