# Yandex Speechkit for Aimybox iOS SDK

Speech recognition and synthesis by [Yandex Cloud Speechkit](https://cloud.yandex.ru/services/speechkit)

## How to start using

1. Login or register at [Yandex Cloud Console](https://console.cloud.yandex.ru/)
2. Make sure that your [billing account](https://cloud.yandex.ru/docs/billing/concepts/billing-account) is active
3. Get a [folder ID](https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id)
4. Get an [oAuth token](https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token)
5. Add dependencies to your Podfile:
```ruby

pod 'AimyboxUI'
pod 'Aimybox/Core'
pod 'Aimybox/AimyboxDialogAPI'
pod 'Aimybox/YandexSpeechKit'

```
6. Provide Yandex Speechkit components into Aimybox configuration object:
```swift
func aimybox() -> Aimybox? {
    
    let provider = IAMTokenGenerator(passport: #oAuth_Token#)
    let folderID = #folder_ID#
    
    guard let speechToText = YandexSpeechToText(tokenProvider: provider, folderID: folderID) else {
        fatalError("Locale is not supported.")
    }
    guard let textToSpeech = YandexTextToSpeech(tokenProvider: provider, folderID: folderID) else {
        fatalError("Locale is not supported.")
    }
    let dialogAPI = AimyboxDialogAPI(api_key: #Aimybox_API_Key#,
                                     unit_key: UIDevice.current.identifierForVendor!.uuidString)
    
    let config = AimyboxBuilder.config(speechToText, textToSpeech, dialogAPI)
    
    return AimyboxBuilder.aimybox(with: config)
}
```

## Documentation

There is a full Aimybox documentation available [here](https://help.aimybox.com)
