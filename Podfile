# Uncomment this line to define a global platform for your project
platform :ios, '8.0'
# Uncomment this line if you're using Swift
 use_frameworks!

target 'GitStats' do
    pod 'Alamofire'
    pod 'MBProgressHUD'
    pod 'SwiftyJSON'
    pod 'AlamofireSwiftyJSON'

    pod 'IQKeyboardManagerSwift', '4.0.5'
    pod 'Charts', '2.3.0'
    pod 'FontAwesome.swift', :git => 'https://github.com/thii/FontAwesome.swift.git', :tag => '0.10.1'
end


post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '2.3'
        end
    end
end
