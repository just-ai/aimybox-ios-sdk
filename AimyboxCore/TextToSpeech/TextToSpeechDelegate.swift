//
//  TextToSpeechDelegate.swift
//  Aimybox
//
//  Created by Vladyslav Popovych on 01.12.2019.
//

import Foundation

public
protocol TextToSpeechDelegate: class {

    // MARK: - Lifecycle
    func tts(_ tts: TextToSpeech, dataReceived speech: AimyboxSpeech)
    /**
    Happens when `TextToSpeech` actually starts to synthesise a list of speeches.
    */
    func tts(_ tts: TextToSpeech, speechSequenceStarted sequence: [AimyboxSpeech])
    /**
    Happens when `TextToSpeech` starts to synthesise the next speech from the list of speeches.
    */
    func tts(_ tts: TextToSpeech, speechStarted speech: AimyboxSpeech)
    /**
    Happens when `TextToSpeech` ends to synthesise the current speech.
    */
    func tts(_ tts: TextToSpeech, speechEnded speech: AimyboxSpeech)
    /**
    Happens when `TextToSpeech` ends to synthesise the whole list of speeches.
    */
    func tts(_ tts: TextToSpeech, speechSequenceCompleted sequence: [AimyboxSpeech])

    // MARK: - Errors
    /**
    Happens when `TextToSpeech` skips any of speeches (if it's empty for example).
    */
    func tts(_ tts: TextToSpeech, speechSkipped speech: AimyboxSpeech)
    /**
    Happens when `TextToSpeech` can't capture speakers.
    */
    func ttsSpeakersUnavailable(_ tts: TextToSpeech)
    /**
    Happens when `TextToSpeech` cancells speech sequence.
    */
    func tts(_ tts: TextToSpeech, speechSequenceCancelled sequence: [AimyboxSpeech])
}

/**
All methods listed here are optional for delegates to implement.
*/
public
extension SpeechToTextDelegate {
    func tts(_ tts: TextToSpeech, dataReceived speech: AimyboxSpeech) {}
    func tts(_ tts: TextToSpeech, speechSequenceStarted sequence: [AimyboxSpeech]) {}
    func tts(_ tts: TextToSpeech, speechStarted speech: AimyboxSpeech) {}
    func tts(_ tts: TextToSpeech, speechEnded speech: AimyboxSpeech) {}
    func tts(_ tts: TextToSpeech, speechSequenceCompleted sequence: [AimyboxSpeech]) {}
    func tts(_ tts: TextToSpeech, speechSkipped speech: AimyboxSpeech) {}
    func ttsSpeakersUnavailable(_ tts: TextToSpeech) {}
    func tts(_ tts: TextToSpeech, speechSequenceCancelled sequence: [AimyboxSpeech]) {}
}
