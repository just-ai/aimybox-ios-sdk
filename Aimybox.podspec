Pod::Spec.new do |s|
  s.name = 'Aimybox'
  s.version = '0.0.25'
  s.summary = 'The only solution if you need to embed your own intelligent voice assistant into your existing application or device.'
  s.description = 'Aimybox is a world-first open source independent voice assistant SDK and voice skills marketplace platform that enables you to create your own voice assistant or embed it into any application or device like robots or Raspberry Pi.'
  s.homepage = 'https://github.com/just-ai/aimybox-ios-sdk.git'
  s.screenshots = 'https://bit.ly/2pOomUs'
  s.license = { :type => 'APACHE 2.0', :file => 'LICENSE' }
  s.author = { 'vasolutions' => 'vasolutions@just-ai.com' }
  s.source = { :git => 'https://github.com/just-ai/aimybox-ios-sdk.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/aimybox'
  s.ios.deployment_target = '12.0'
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
    sp.source_files = 'Components/SFSpeechToText/Sources/*.{swift}'
    sp.dependency 'Aimybox/Core'
    sp.dependency 'Aimybox/Utils'
  end

  s.subspec 'YandexSpeechKit' do |sp|
    sp.source_files  = 'Components/YandexSpeechKit/Sources/**/*.{swift}', 'Components/YandexSpeechKit/Sources/**/**/*.{swift}', 'Components/YandexSpeechKit/Sources/**/**/**/*.{swift}'
    sp.exclude_files = 'Components/YandexSpeechKit/Sources/*.{plist}'
    sp.dependency 'Aimybox/Core'
    sp.dependency 'Aimybox/Utils'
    sp.dependency 'SwiftProtobuf'
    sp.dependency 'gRPC-Swift'
    sp.dependency 'SwiftNIO'
    sp.dependency 'SwiftNIOCore'
    sp.dependency 'SwiftNIOTLS'
    sp.dependency 'SwiftNIOSSL'
  end	

end
