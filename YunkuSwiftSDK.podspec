#
# Be sure to run `pod lib lint YunkuPod.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'YunkuSwiftSDK'
  s.version          = '1.0.13'
  s.summary          = '根据 appstore 审核标准更换 hmac 算法库'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
 够快云库开放 API Swift 语言
DESC

  s.homepage         = 'https://github.com/gokuai/yunku-sdk-swift'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'BrandonGk' => 'heybozai@sina.com' }
  s.source           = { :git => 'https://github.com/gokuai/yunku-sdk-swift.git', :tag => s.version.to_s }
#  s.social_media_url = 'http://www.gokuai.com'

  s.platform = :osx, '10.13'
  s.platform = :ios, '9.0'
#  s.public_header_files = 'Headers/iOS/YunkuSwiftSDK.h'
  s.osx.source_files = 'YunkuSwiftSDK/YunkuSwiftSDK/Class/**/*'
  s.ios.source_files = 'YunkuSwiftSDK/YunkuSwiftSDK/Class/**/*'
#  s.frameworks = 'YunkuSwiftSDK'
  s.osx.vendored_frameworks = 'Frameworks/CryptoSwift.framework'
  s.ios.vendored_frameworks = 'Frameworks/CryptoSwift.framework'

#  s.libraries = "libz.tbd"

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
