platform :ios, '13.0'
inhibit_all_warnings!
use_frameworks!

def pods
	pod 'Kingfisher'
    pod 'Parse'
    pod 'lottie-ios'
    pod 'MarqueeLabel'
    pod 'RealmSwift', '10.5.1'
    pod 'IceCream', '1.13.2'
    pod 'Swinject'
    pod 'ThirdPartyMailer'
end

target 'Tasty Radio' do
  	pods
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
      config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
    end
  end
end
