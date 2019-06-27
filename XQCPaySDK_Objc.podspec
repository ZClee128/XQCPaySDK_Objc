#
# Be sure to run `pod lib lint XQCPaySDK_Objc.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'XQCPaySDK_Objc'
  s.version          = '1.1.6'
  s.summary          = '薪起程聚合支付'

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
  
  s.resource_bundles = {
       'XQCPaySDK_Objc' => ['XQCPaySDK_Objc/Assets/*.png']
  }

  s.static_framework = true
  
  s.libraries = 'sqlite3', 'c++', 'z.1.2.5'
  s.frameworks = 'WebKit', 'SystemConfiguration', 'CoreTelephony', 'UIKit', 'CoreMotion', 'CoreGraphics', 'ImageIO', 'CFNetwork', 'MobileCoreServices', 'MessageUI', 'AddressBook', 'AddressBookUI', 'Security', 'AudioToolbox', 'CoreLocation', 'CoreMedia', 'CoreVideo', 'Accelerate', 'AVFoundation'
  s.vendored_frameworks = 'XQCPaySDK_Objc/Frameworks/YSEPaySDK.framework'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'ENABLE_BITCODE' => 'NO' }
  s.xcconfig = { 'LD_RUNPATH_SEARCH_PATHS' => 'XQCPaySDK/Frameworks'}
#  s.public_header_files = 'pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'SVProgressHUD'
  s.dependency 'SDWebImage'
  s.dependency 'WechatOpenSDK'
  s.dependency 'XQCPaymentPasswordInputView'
end
