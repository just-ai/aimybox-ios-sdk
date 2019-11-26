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
        
        public var speechToText: SpeechToTextProtocol
        
        public init(speechToText: SpeechToTextProtocol) {
            self.speechToText = speechToText
        }
    }
}
