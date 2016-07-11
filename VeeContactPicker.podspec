#
# Be sure to run `pod lib lint VeeContactPicker.podspec' to ensure this is a
# valid spec before submitting.

Pod::Spec.new do |s|
s.name             = "VeeContactPicker"
s.version          = "0.0.2"
s.summary          = "A replacement for the iOS ABPeoplePickerNavigationController, with contacts' images"
s.description      = "VeeContactPicker is an objc replacement for the (bugged) ABPeoplePickerNavigationController. It's a ViewController that allows you to choose a contact from the address book."
s.homepage         = "https://github.com/CodeAtlas/VeeContactPicker"
s.screenshots     = "https://raw.githubusercontent.com/CodeAtlas/VeeContactPicker/master/Screenshots/VeeContactPickerScreen1.png
"
s.license          = 'MIT'
s.author           = { "Code Atlas SRL" => "andrea.g.cipriani@gmail.com" }
s.source           = { :git => "https://github.com/CodeAtlas/VeeContactPicker.git", :tag => s.version.to_s }
s.social_media_url = 'https://github.com/CodeAtlas'
s.platform     = :ios, '7.0'
s.requires_arc = true
s.source_files = 'Pod/Classes/**/*'
s.resource_bundles = {
    'VeeContactPicker' => ['Pod/Assets/*.{xib}']
}
s.dependency 'UIImageView-AGCInitials'
s.dependency 'FLKAutoLayout'
end
