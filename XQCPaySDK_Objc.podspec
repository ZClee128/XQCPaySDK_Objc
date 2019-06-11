#
# Be sure to run `pod lib lint XQCPaySDK_Objc.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'XQCPaySDK_Objc'
  s.version          = '0.1.0'
  s.summary          = 'A short description of XQCPaySDK_Objc.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
薪起程聚合支付
                       DESC

  s.homepage         = 'https://github.com/ZClee128/XQCPaySDK_Objc'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ZClee128' => '876231865@qq.com' }
  s.source           = { :git => 'https://github.com/ZClee128/XQCPaySDK_Objc.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'XQCPaySDK_Objc/Classes/**/*'
  
  #s.resource_bundles = {
  #     'XQCPaySDK_Objc' => ['XQCPaySDK_Objc/Assets/images/*.png']
  #}

  s.vendored_frameworks = 'XQCPaySDK_Objc/Classes/Frameworks/YSSDK.framework', 'XQCPaySDK_Objc/Classes/Frameworks/YSEPaySDK.framework'
  #s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
