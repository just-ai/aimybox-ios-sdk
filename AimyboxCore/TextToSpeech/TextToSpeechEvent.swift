//
//  TextToSpeechEvent.swift
//  Aimybox
//
//  Created by Vladyslav Popovych on 01.12.2019.
//

import Foundation

public enum TextToSpeechEvent {
    /**
     Happens when TextToSpeech actually starts to synthesise a list of speeches.
     */
    case speechSequenceStarted([AimyboxSpeech])
    /**
     Happens when TextToSpeech starts to synthesise the next speech from the list of speeches.
     */
    case speechStarted(AimyboxSpeech)
    /**
     Happens when TextToSpeech ends to synthesise the current speech.
     */
    case speechEnded(AimyboxSpeech)
    /**
     Happens when TextToSpeech ends to synthesise the whole list of speeches.
     */
    case speechSequenceCompleted([AimyboxSpeech])
    /**
     Happens when TextToSpeech skips any of speeches (if it's empty for example).
     */
    case speechSkipped(AimyboxSpeech)
}

public extension TextToSpeechEvent {
    func forward(to delegate: TextToSpeechDelegate?, by tts: TextToSpeech?) {
        guard let delegate = delegate, let tts = tts else {
            return
        }

        switch self {
        case .speechSequenceStarted(let sequence):
            delegate.tts(tts, speechSequenceStarted: sequence)
        case .speechStarted(let speech):
            delegate.tts(tts, speechStarted: speech)
        case .speechEnded(let speech):
            delegate.tts(tts, speechEnded: speech)
        case .speechSequenceCompleted(let sequence):
            delegate.tts(tts, speechSequenceCompleted: sequence)
        case .speechSkipped(let speech):
            delegate.tts(tts, speechSkipped: speech)
        }
    }
}
