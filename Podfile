platform :ios, '13.0'
inhibit_all_warnings!

target 'Tasty Radio' do
  	use_frameworks!

	pod 'Kingfisher'
    pod 'Parse'
    pod 'lottie-ios'
    pod 'MarqueeLabel'
    pod 'RealmSwift'
    pod 'IceCream'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            if config.name == 'Debug'
                config.build_settings['OTHER_SWIFT_FLAGS'] = ['$(inherited)', '-Onone']
                config.build_settings['SWIFT_OPTIMIZATION_LEVEL'] = '-Owholemodule'

                config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
				config.build_settings['ONLY_ACTIVE_ARCH'] = 'YES'
            end
        end
    end
end
