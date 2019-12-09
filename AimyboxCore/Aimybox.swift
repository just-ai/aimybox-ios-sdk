//
//  Aimybox.swift
//  AimyboxCore
//
//  Created by Vladyslav Popovych on 23.11.2019.
//  Copyright © 2019 Just Ai. All rights reserved.
//

import Foundation

/**
 Top level object that manages voice assistant behavior.
 
 - Attention: Use `AimyboxBuilder` to instanciate object conforming to a `Aimybox` protocol.
 */
public protocol Aimybox: class {
    /**
     Transitions listening state.
     - Note: For more detailed overview of side effects involved, refer to `AimyboxState.listening`.
     */
    func startRecognition()
    /**
     Stops recognition, but didn't discard user queries.
     After a call `Aimybox` will trasition to `AimyboxState.processing` state.
     - Note: For more detailed overview of side effects involved, refer to `AimyboxState.processing`.
    */
    func stopRecognition()
    /**
     Forces transition to `AimyboxState.standby` state.
     User query that was recognized before will be discarded.
     - Note: For detailed overview of side effects involved, refer to `AimyboxState.standby`.
    */
    func cancelRecognition()
    /**
     Force transition to standby mode.
     */
    func standby()
    /**
     Receives state and domain(tts, stt, ...) specific events.
     
     - Note: `Aimybox` do not retain it's delegate.
     */
    var delegate: AimyboxDelegate? { get set }
    /**
     Current state of `Aimybox`.
     
     - Note: Not observable. Use delegate `AimyboxDelegate` to get notified about changes.
     */
    var state: AimyboxState { get }
}

/**
 `AimyboxBuilder` is class that utilizes Swift's type inference to provide easy to use API.
 
 ```
 let speechToText = FooSTT()
 let textToSpeech = FooTTS()
 let dialogAPI = FooDialogAPI()
 
 /// Used to create type-erased object that conforms to `AimyboxConfig` protocol.
 let config = AimyboxBuilder.config(speechToText, textToSpeech, dialogAPI)

 /// And here we use config created above, to create `Aimybox` instance.
 let aimybox = AimyboxBuilder.aimybox(with: config)
 ```
 
 - Note: Type match is checked at compile time, so be aware of that.
 */
public class AimyboxBuilder {
    /**
     Creates concrete object that conforms to a `Aimybox` protocol.
     
     - Parameter config: Object that conforms to `AimyboxConfig` protocol, created using `AimyboxBuilder.config(_, _, _)`.
     
     - Returns: A concrete object up-casted to `Aimybox` protocol.
     */
    public static func aimybox<TDialogAPI, TConfig>(with config: TConfig) -> Aimybox where TConfig: AimyboxConfig,
                                                                                            TConfig.TDialogAPI == TDialogAPI {
        return AimyboxConcrete<TDialogAPI, TConfig>(with: config) as Aimybox
    }
    /**
     Used to create type-erased object that conforms to `AimyboxConfig` protocol.
     
     - Parameter speechToText: Concrete object that conforms to `SpeechToText` protocol.
     
     - Parameter textToSpeech: Concrete object that conforms to `TextToSpeech` protocol.
     
     - Parameter dialogAPI: Concrete object that conforms to `DialogAPI` protocol.
     
     - Returns: A type-erased object that conforms to `AimyboxConfig` protocol.
     */
    public static func config<TDialogAPI>(_ speechToText: SpeechToText,
                                         _ textToSpeech: TextToSpeech,
                                         _ dialogAPI: TDialogAPI) -> AimyboxConfigConcrete<TDialogAPI>
    {
        return AimyboxConfigConcrete<TDialogAPI>(speechToText, textToSpeech, dialogAPI)
    }
}
