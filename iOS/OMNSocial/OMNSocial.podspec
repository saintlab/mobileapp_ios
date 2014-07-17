#
# Be sure to run `pod lib lint OMNSocial.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "OMNSocial"
  s.version          = "0.1.0"
  s.summary          = "A short description of OMNSocial."
  s.description      = <<-DESC
                       An optional longer description of OMNSocial

                       * Markdown format.
                       * Don't worry about the indent, we strip it!
                       DESC
  s.homepage         = "https://github.com/<GITHUB_USERNAME>/OMNSocial"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "teanet" => "evgeniy.tutuev@gmail.com" }
  s.source           = { :git => "https://github.com/<GITHUB_USERNAME>/OMNSocial.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes'
  s.resources = 'Pod/Assets/*.png'

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'AFNetworking', '~> 2.3' 
  s.dependency 'google-plus-ios-sdk', '~> 1.5.0'
  s.dependency 'VK-ios-sdk'
  s.dependency 'SSKeychain'
  s.dependency 'odnoklassniki_ios_sdk'


end
