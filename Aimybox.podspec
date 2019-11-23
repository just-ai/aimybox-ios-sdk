#
# Be sure to run `pod lib lint Aimybox.podspec' to ensure this is a
# valid spec before submitting.

Pod::Spec.new do |s|
  s.name             = 'Aimybox'
  s.version          = '0.1.0'
  s.summary          = 'The only solution if you need to embed your own intelligent voice assistant into your existing application or device.'

  s.description      = 'Aimybox is a world-first open source independent voice assistant SDK and voice skills marketplace platform that enables you to create your own voice assistant or embed it into any application or device like robots or Raspberry Pi.'

  s.homepage         = 'https://github.com/just-ai/aimybox-ios-sdk.git'
  s.screenshots    = 'https://bit.ly/2pOomUs'
  s.license          = { :type => 'APACHE 2.0', :file => 'LICENSE' }
  s.author           = { 'vpopovyc' => 'vpopovyc@student.unit.ua' }
  s.source           = { :git => 'https://github.com/just-ai/aimybox-ios-sdk.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/aimybox'
  s.ios.deployment_target = '10.0'
  s.swift_versions = '4.2'
  s.source_files = 'AimyboxCore/**/*.{swift}'
end
