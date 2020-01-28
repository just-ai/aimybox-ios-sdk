<h1 align="center">
    <br>
    <a href="https://aimybox.com"><img src="https://app.aimybox.com/assets/images/aimybox.png"
                                                                    height="200"></a>
    <br><br>
    Aimybox iOS SDK
</h1>

<h4 align="center">Open source voice assistant SDK written in Swift</h4>

<p align="center">
    <a href="https://gitter.im/aimybox/community"><img src="https://badges.gitter.im/amitmerchant1990/electron-markdownify.svg"></a>
    <a href="https://twitter.com/intent/follow?screen_name=aimybox"><img alt="Twitter Follow" src="https://img.shields.io/twitter/follow/aimybox.svg?label=Follow%20on%20Twitter&style=popout"></a>
</p>

Embed your own intelligent voice assistant into your existing iOS application.

### Android version is available [here](https://github.com/just-ai/aimybox-android-sdk)

# Key Features

* Provides ready to use [UI components](https://github.com/just-ai/aimybox-ios-assistant) for fast building of your voice assistant app
* Modular and independent from speech-to-text and text-to-speech vendors
* Provides ready to use speech-to-text and text-to-speech implementations
* Works with any NLU providers like [Aimylogic](https://help.aimybox.com/en/article/aimylogic-webhook-5quhb1/)
* Fully customizable and extendable, you can connect any other speech-to-text, text-to-speech and NLU services
* Open source under Apache 2.0, written in pure Swift
* Embeddable into any iOS application
* Voice skills logic and complexity is not limited by any restrictions
* Can interact with any local device services and local networks

## How to start using

Aimybox SDK is available through [CocoaPods](https://cocoapods.org). To install it, simply add the following line to your Podfile:

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

# More details

Please refer to the [demo voice assistant](https://github.com/just-ai/aimybox-ios-assistant/) to see how to use Aimybox library in your project.

# Documentation

There is a full Aimybox documentation available [here](https://help.aimybox.com)

## License

Aimybox is available under the Apache 2.0 license. See the LICENSE file for more info.
