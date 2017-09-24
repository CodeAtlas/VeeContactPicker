#
# Be sure to run `pod lib lint VeeContactPicker.podspec' to ensure this is a
# valid spec before submitting.

Pod::Spec.new do |s|
s.name             = "VeeContactPicker"
s.version          = "1.1"
s.summary          = "A replacement for the iOS ABPeoplePickerNavigationController, with contacts' images"
s.description      = "VeeContactPicker is a replacement for the (bugged) ABPeoplePickerNavigationController. You can use it to let the user choose a contact from the address book."
s.homepage         = "https://github.com/CodeAtlas/VeeContactPicker"
s.screenshots     = "https://raw.githubusercontent.com/CodeAtlas/VeeContactPicker/master/Screenshots/VeeContactPickerScreen1.png
"
s.license          = 'MIT'
s.author           = { "Code Atlas SRL" => "andrea.g.cipriani@gmail.com" }
s.source           = { :git => "https://github.com/CodeAtlas/VeeContactPicker.git", :tag => s.version.to_s }
s.social_media_url = 'https://github.com/CodeAtlas'
s.ios.deployment_target = '8.0'
s.requires_arc = true
s.source_files = 'VeeContactPicker/Classes/**/*'
s.resource_bundles = {
#'VeeContactPicker' => ['VeeContactPicker/Assets/*.png']
}
s.public_header_files = 'VeeContactPicker/Classes/**/*.h'
s.frameworks = 'UIKit', 'AddressBook'
s.dependency 'UIImageView-AGCInitials'

end
