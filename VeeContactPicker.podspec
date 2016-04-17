#
# Be sure to run `pod lib lint VeeContactPicker.podspec' to ensure this is a
# valid spec before submitting.

Pod::Spec.new do |s|
s.name             = "VeeContactPicker"
s.version          = "0.0.1"
s.summary          = "A replacement for the iOS ABPeoplePickerViewController, with contact's images"
s.description      = "A replacement for the (bugged) iOS ABPeoplePickerViewController, with contact's images"

s.homepage         = "https://github.com/CodeAtlas/VeeContactPicker"
# s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
s.license          = 'MIT'
s.author           = { "Code Atlas SRL" => "info@codeatlas.it" }
s.source           = { :git => "https://github.com/CodeAtlas/VeeContactPicker.git", :tag => s.version.to_s }
s.social_media_url = 'https://www.linkedin.com/company/code-atlas-srl'
s.platform     = :ios, '7.0'
s.requires_arc = true
s.source_files = 'Pod/Classes/**/*'
s.resource_bundles = {
    'VeeContactPicker' => ['Pod/Assets/*.{xib}']
}
s.dependency 'UIImageView-AGCInitials'
s.dependency 'PodAsset'
end
