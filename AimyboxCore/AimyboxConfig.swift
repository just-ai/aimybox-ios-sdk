//
//  AimyboxConfig.swift
//  AimyboxCore
//
//  Created by Vladyslav Popovych on 30.11.2019.
//  Copyright © 2019 Just Ai. All rights reserved.
//

import Foundation

/**
 Object that holds all actual implementations of *SpeechToText*, *TextToSpeech*, *VoiceTrigger* and *DialogApi*.
 */

public protocol AimyboxConfig {
    /**
     Recognises a text from the user's speech in real time.
     */
    var speechToText: SpeechToText { get set }
    /**
     Synthesizes a speech from the text in real time.
     */
    var textToSpeech: TextToSpeech { get set }
    /**
     DialogAPI is a protocol with assosiated types constraints.
     */
    associatedtype TDialogAPI: DialogAPI
    /**
    Communicates with NLU engine and provides responses for user queries.
    */
    var dialogAPI: TDialogAPI { get set }
}


public class AimyboxConfigBuilder {
    /**
    Use this method to create AimyboxConfig.
    ```
    let stt = SpeechToTextConcrete()
    let tts = TextToSpeechConcrete()
    let dialogAPI = DialogAPIConcrete()
    
    let config = AimyboxConfig.build(stt, tts, dialogAPI)
    ```
    */
    public static func build<TDialogAPI>(_ speechToText: SpeechToText,
                                         _ textToSpeech: TextToSpeech,
                                         _ dialogAPI: TDialogAPI) -> AnyAimyboxConfig<TDialogAPI>
    {
        let config = AimyboxConfigConcrete<TDialogAPI>(speechToText: speechToText,
                                                       textToSpeech: textToSpeech,
                                                       dialogAPI: dialogAPI)
        return AnyAimyboxConfig(config)
    }
}

private struct AimyboxConfigConcrete<TDialogAPI: DialogAPI>: AimyboxConfig {
    /**
     Recognises a text from the user's speech in real time.
     */
    public var speechToText: SpeechToText
    /**
     Synthesizes a speech from the text in real time.
     */
    public var textToSpeech: TextToSpeech
    /**
     Communicates with NLU engine and provides responses for user queries.
     */
    public var dialogAPI: TDialogAPI
    
    public init(speechToText: SpeechToText, textToSpeech: TextToSpeech, dialogAPI: TDialogAPI) {
        self.speechToText = speechToText
        self.textToSpeech = textToSpeech
        self.dialogAPI = dialogAPI
    }
}

private class _AimyboxConfigBase<TDialogAPI: DialogAPI>: AimyboxConfig {
    var speechToText: SpeechToText {
        get { fatalError("Must override") }
        set { fatalError("Must override") }
    }
    
    var textToSpeech: TextToSpeech {
        get { fatalError("Must override") }
        set { fatalError("Must override") }
    }
    
    var dialogAPI: TDialogAPI {
        get { fatalError("Must override") }
        set { fatalError("Must override") }
    }
}

private final class _AnyAimyboxConfigBox<TConcreteConfig: AimyboxConfig>: _AimyboxConfigBase<TConcreteConfig.TDialogAPI> {
    
    var concreteConfig: TConcreteConfig
    
    init(_ concreteConfig: TConcreteConfig) {
        self.concreteConfig = concreteConfig
    }
    
    override var speechToText: SpeechToText {
        get { concreteConfig.speechToText }
        set { concreteConfig.speechToText = newValue }
    }
    
    override var textToSpeech: TextToSpeech {
        get { concreteConfig.textToSpeech }
        set { concreteConfig.textToSpeech = newValue }
    }
    
    override var dialogAPI: TDialogAPI {
        get { concreteConfig.dialogAPI }
        set { concreteConfig.dialogAPI = newValue }
    }
}

public final class AnyAimyboxConfig<TDialogAPI: DialogAPI>: AimyboxConfig {
    
    private let box: _AimyboxConfigBase<TDialogAPI>
    
    init<TConcreteConfig: AimyboxConfig>(_ concreteConfig: TConcreteConfig) where TConcreteConfig.TDialogAPI == TDialogAPI {
        box = _AnyAimyboxConfigBox(concreteConfig)
    }
    
    public var speechToText: SpeechToText {
        get { box.speechToText }
        set { box.speechToText = newValue }
    }
    
    public var textToSpeech: TextToSpeech {
        get { box.textToSpeech }
        set { box.textToSpeech = newValue }
    }
    
    public var dialogAPI: TDialogAPI {
        get { box.dialogAPI }
        set { box.dialogAPI = newValue }
    }
}
