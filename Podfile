# add pods for desired Firebase products
# https://firebase.google.com/docs/ios/setup#available-pods
platform :ios, '13.0'

target 'Tasty Radio' do
  	use_frameworks!

	pod 'Kingfisher'
    pod 'Parse'
    pod 'lottie-ios'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
             config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.3'
            if config.name == 'Debug'
                config.build_settings['OTHER_SWIFT_FLAGS'] = ['$(inherited)', '-Onone']
                config.build_settings['SWIFT_OPTIMIZATION_LEVEL'] = '-Owholemodule'
            end
        end
    end
end
