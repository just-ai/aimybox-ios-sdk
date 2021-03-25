//
//  AimyboxConfig.swift
//  AimyboxCore
//
//  Created by Vladyslav Popovych on 30.11.2019.
//  Copyright © 2019 Just Ai. All rights reserved.
//

import Foundation

/**
 Holds all actual implementations of *SpeechToText*, *TextToSpeech*, *VoiceTrigger* and *DialogApi*.
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

/**
 Type-erased object as it used in Swift Core Lib.
 */
public struct AimyboxConfigConcrete<TDialogAPI: DialogAPI>: AimyboxConfig {
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

    public init(_ speechToText: SpeechToText, _ textToSpeech: TextToSpeech, _ dialogAPI: TDialogAPI) {
        self.speechToText = speechToText
        self.textToSpeech = textToSpeech
        self.dialogAPI = dialogAPI
    }
}
