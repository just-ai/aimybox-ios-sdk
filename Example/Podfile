source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '11.4'
inhibit_all_warnings!

target 'AimyboxExample' do
  use_frameworks!

  pod 'Aimybox',
    :subspecs => ['AimyboxDialogAPI', 'YandexSpeechKit', "AVTextToSpeech", "SFSpeechToText"],
    :path => '../'
  pod 'SDWebImage'
  pod 'SwiftLint'
  pod 'gRPC-Swift-Plugins'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
    end
  end
end
