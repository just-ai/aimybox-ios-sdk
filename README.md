# Aimybox

[![License](https://img.shields.io/cocoapods/l/Aimybox.svg?style=flat)](https://github.com/just-ai/aimybox-ios-sdk/blob/master/LICENSE)
![iOS 11.4+](https://img.shields.io/badge/iOS-11.4%2B-blue.svg)
![Swift 4.2+](https://img.shields.io/badge/Swift-4.2%2B-orange.svg)

## Installation

Aimybox is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
  pod 'Aimybox/Core'
  # Specific components for DialogAPI, SpeechToText and TextToSpeech
  pod 'Aimybox/AimyboxDialogAPI'
  pod 'Aimybox/SFSpeechToText'
  pod 'Aimybox/AVTextToSpeech'
```

List of available components listed below.

Then you need add following in your `Info.plist` file to describe why your app need microphone and speech recognition permissions.

```
	<key>NSMicrophoneUsageDescription</key>
	<string>This app use a microphone to record your speech</string>
  
	<key>NSSpeechRecognitionUsageDescription</key>
	<string>This app will use speech recognition</string>
```

Add following in your `ViewController`

```swift

    var aimybox: Aimybox? = {
        let locale = Locale(identifier: "en")
        
        guard let speechToText = SFSpeechToText(locale: locale) else {
            fatalError("Locale is not supported.")
        }
        guard let textToSpeech = AVTextToSpeech(locale: locale) else {
            fatalError("Locale is not supported.")
        }
        
        let dialogAPI = AimyboxDialogAPI(api_key: "Awesome_API_Key",
                                         unit_key: UIDevice.current.identifierForVendor!.uuidString)
        
        let config = AimyboxBuilder.config(speechToText, textToSpeech, dialogAPI)
        
        return AimyboxBuilder.aimybox(with: config)
    }()
```

Then call `startRecognition()` method of `Aimybox` to start talking with your voice assistant.

## Available Components
### TextToSpeech

- **SFSpeechToText**

Speech recognition component that uses iOS [Speech Framework](https://developer.apple.com/documentation/speech).

Pods installation: 

`pod 'Aimybox/SFSpeechToText'`

### TextToSpeech

- **AVTextToSpeech**

Speech synthesizer component that uses iOS speech synthesis of [AVFoundation Framework](https://developer.apple.com/documentation/avfoundation/speech_synthesis).

Uses `AVSpeechUtterance` and `AVSpeechSynthesizer` for core functionality.

Pods installation: 

`pod 'Aimybox/AVTextToSpeech'`

### DialogAPI

- **AimyboxDialogAPI**

DialogAPI component that uses [Aimybox HTTP API](https://help.aimybox.com/en/category/http-api-1vrvqsw/).

Pods installation: 

`pod 'Aimybox/AimyboxDialogAPI'`

## Author

vpopovyc, mailuatc@gmail.com

## License

Aimybox is available under the Apache 2.0 license. See the LICENSE file for more info.
