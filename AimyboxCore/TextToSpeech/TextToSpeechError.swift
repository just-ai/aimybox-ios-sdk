//
//  TextToSpeechError.swift
//  Aimybox
//
//  Created by Vladyslav Popovych on 01.12.2019.
//

import Foundation

public enum TextToSpeechError: Error {
    /**
     Speech is empty and will be skipped.
     */
    case emptySpeech(AimyboxSpeech)
    /**
     Sent when speakers are unvailable.
     */
    case speakersUnavailable
}

public extension TextToSpeechError {
    func forward(to delegate: TextToSpeechDelegate?, by tts: TextToSpeech?) {
        guard let delegate = delegate, let tts = tts else {
            return
        }
        
        switch self {
        case .emptySpeech(let speech):
            delegate.tts(tts, speechSkipped: speech)
        case .speakersUnavailable:
            delegate.ttsSpeakersUnavailable(tts)
        }
    }
}
