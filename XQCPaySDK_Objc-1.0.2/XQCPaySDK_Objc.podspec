Pod::Spec.new do |s|
  s.name = "XQCPaySDK_Objc"
  s.version = "1.0.2"
  s.summary = "\u{85aa}\u{8d77}\u{7a0b}\u{805a}\u{5408}\u{652f}\u{4ed8}"
  s.license = {"type"=>"MIT", "file"=>"LICENSE"}
  s.authors = {"ZClee128"=>"876231865@qq.com"}
  s.homepage = "https://github.com/ZClee128/XQCPaySDK_Objc"
  s.description = "\u{85aa}\u{8d77}\u{7a0b}\u{805a}\u{5408}\u{652f}\u{4ed8}"
  s.frameworks = ["WebKit", "SystemConfiguration", "CoreTelephony", "UIKit", "CoreMotion", "CoreGraphics", "ImageIO", "CFNetwork", "MobileCoreServices", "MessageUI", "AddressBook", "AddressBookUI", "Security", "AudioToolbox", "CoreLocation", "CoreMedia", "CoreVideo", "Accelerate", "AVFoundation"]
  s.libraries = ["sqlite3", "c++", "z.1.2.5"]
  s.source = { :path => '.' }

  s.ios.deployment_target    = '9.0'
  s.ios.vendored_framework   = 'ios/XQCPaySDK_Objc.framework'
end
