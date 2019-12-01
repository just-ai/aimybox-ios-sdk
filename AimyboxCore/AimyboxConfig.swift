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

public extension Aimybox {
    
    struct Config {
        /**
         Recognises a text from the user's speech in real time.
         */
        public var speechToText: SpeechToText
        /**
         Synthesizes a speech from the text in real time.
         */
        public var textToSpeech: TextToSpeech
        
        public init(speechToText: SpeechToText, textToSpeech: TextToSpeech) {
            self.speechToText = speechToText
            self.textToSpeech = textToSpeech
        }
    }
}
