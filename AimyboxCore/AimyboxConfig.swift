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

protocol ConfigProto {
    
    associatedtype TDialogAPI: DialogAPI
    
    var dialogAPI: AimyboxDialogAPI { get set }
}

struct Config2: ConfigProto {
    
    typealias TDialogAPI = AimyboxDialogAPI
    
    var dialogAPI: AimyboxDialogAPI
}


public extension Aimybox {
    
    struct Config<TDialogAPI: DialogAPI> {
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
    

    

}
