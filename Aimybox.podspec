Pod::Spec.new do |s|
  s.name = 'Aimybox'
  s.version = '0.0.23'
  s.summary = 'The only solution if you need to embed your own intelligent voice assistant into your existing application or device.'
  s.description = 'Aimybox is a world-first open source independent voice assistant SDK and voice skills marketplace platform that enables you to create your own voice assistant or embed it into any application or device like robots or Raspberry Pi.'
  s.homepage = 'https://github.com/just-ai/aimybox-ios-sdk.git'
  s.screenshots = 'https://bit.ly/2pOomUs'
  s.license = { :type => 'APACHE 2.0', :file => 'LICENSE' }
  s.author = { 'vasolutions' => 'vasolutions@just-ai.com' }
  s.source = { :git => 'https://github.com/just-ai/aimybox-ios-sdk.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/aimybox'
  s.ios.deployment_target = '11.4'
  s.swift_versions = '5.2'
  s.default_subspecs = 'Core'

  s.subspec 'Core' do |sp|
    sp.source_files = 'AimyboxCore/**/*.{swift}', 'AimyboxCore/**/**/*.{swift}', 'AimyboxCore/**/**/**/*.{swift}'
  end

  s.subspec 'Utils' do |sp|
    sp.source_files  = 'Utils/**/*.{swift}'
    sp.exclude_files = 'Utils/**/*.{plist}'
  end

  s.subspec 'AimyboxDialogAPI' do |sp|
    sp.source_files  = 'Components/AimyboxDialogAPI/Sources/*.{swift}'
    sp.dependency 'Aimybox/Core'
    sp.dependency 'Aimybox/Utils'
  end

  s.subspec 'AVTextToSpeech' do |sp|
    sp.source_files  = 'Components/AVTextToSpeech/Sources/*.{swift}'
    sp.dependency 'Aimybox/Core'
    sp.dependency 'Aimybox/Utils'
  end

  s.subspec 'SFSpeechToText' do |sp|
    sp.source_files  = 'Components/SFSpeechToText/Sources/*.{swift}'
    sp.dependency 'Aimybox/Core'
    sp.dependency 'Aimybox/Utils'
  end

  s.subspec 'YandexSpeechKit' do |sp|
    sp.source_files  = 'Components/YandexSpeechKit/Sources/**/*.{swift}'
    sp.dependency 'Aimybox/Core'
    sp.dependency 'Aimybox/Utils'
    sp.dependency 'SwiftGRPC'
    sp.dependency 'SwiftProtobuf'
  end

  s.subspec 'YandexSpeechKitV3' do |sp|
    sp.source_files  = 'Components/YandexSpeechKitV3/Sources/**/*.{swift}'
    sp.dependency 'Aimybox/Core'
    sp.dependency 'Aimybox/Utils'
    sp.dependency 'SwiftProtobuf', '1.17.0'
    sp.dependency 'gRPC-Swift', '1.2.0'
  end

end
