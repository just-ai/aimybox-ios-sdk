//
//  AVTextToSpeech.swift
//  Aimybox
//
//  Created by Vladyslav Popovych on 01.12.2019.
//

import Foundation
import AVFoundation

public class AVTextToSpeech: NSObject, TextToSpeech {
    /**
     The rate at which the utterance will be spoken. The default rate is *AVSpeechUtteranceDefaultSpeechRate*
     */
    public var rate: Float
    /**
     The voice used to speak the utterance.
     */
    public var voice: AVSpeechSynthesisVoice?
    /**
     The volume used when speaking the utterance. Allowed values are in the range from 0.0 (silent) to 1.0 (loudest). The default volume is 1.0.
     */
    public var volume: Float
    /**
     The default pitch is 1.0. Allowed values are in the range from 0.5 (for lower pitch) to 2.0 (for higher pitch).
     */
    public var pitchMultiplier: Float
    /**
     Used to notify *Aimybox* state machine about events.
     */
    public var notify: (TextToSpeechCallback)?
    /**
     Speech synthesizer. You can customize it using public props above.
     */
    private var speechSynthesizer: AVSpeechSynthesizer
    /**
     To notify about start/end of synthesizing.
     */
    internal var textQueue: [AVSpeechUtterance : AimyboxSpeech]
    
    private override init() {
        rate = AVSpeechUtteranceDefaultSpeechRate
        volume = 1.0
        pitchMultiplier = 1.0
        speechSynthesizer = AVSpeechSynthesizer()
        textQueue = [:]
        super.init()
        speechSynthesizer.delegate = self
    }
    
    public init?(locale: Locale? = nil) {
        rate = AVSpeechUtteranceDefaultSpeechRate
        voice = AVSpeechSynthesisVoice(language: locale?.languageCode)
        volume = 1.0
        pitchMultiplier = 1.0
        speechSynthesizer = AVSpeechSynthesizer()
        textQueue = [:]
        super.init()
        speechSynthesizer.delegate = self
    }
    
    // MARK: - TextToSpeech
    
    public func synthesize(contentsOf speeches: [AimyboxSpeech]) {
        
        prepareAudioEngine { [weak self] engineIsReady in
            if engineIsReady {
                self?.synthesize(speeches)
            } else {
                self?.notify?(.failure(.speakersUnavailable))
            }
        }
    }
    
    public func stop() {
        speechSynthesizer.stopSpeaking(at: .word)
    }
    
    // MARK: - Internals
    
    private func synthesize(_ speeches: [AimyboxSpeech]) {
        guard let _notify = notify else { return }
        
        _notify(.success(.speechSequenceStarted(speeches)))

        speeches.forEach { speech in
            
            guard speech.isValid() else {
                return _notify(.failure(.emptySpeech(speech)))
            }
            
            synthesize(speech)
        }

        _notify(.success(.speechSequenceCompleted(speeches)))
    }
    
    private func synthesize(_ speech: AimyboxSpeech) {
        if let textSpeech = speech as? TextSpeech {
            synthesize(textSpeech)
        }
    }
    
    private func synthesize(_ textSpeech: TextSpeech) {
        let utterance = AVSpeechUtterance(string: textSpeech.text)
        utterance.rate = rate
        utterance.voice = voice
        utterance.volume = volume
        utterance.pitchMultiplier = pitchMultiplier

        speechSynthesizer.speak(utterance)
        
        textQueue[utterance] = textSpeech
    }
    
    private func prepareAudioEngine(_ completion: (Bool)->()) {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playback)
            try audioSession.setMode(.default)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            completion(true)
        } catch {
            completion(false)
        }
    }
}

extension AVTextToSpeech: AVSpeechSynthesizerDelegate {
    
    public func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        guard let aimySpeech = textQueue[utterance] else { return }
        
        notify?(.success(.speechStarted(aimySpeech)))
    }

    public func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        guard let aimySpeech = textQueue[utterance] else { return }
        
        notify?(.success(.speechEnded(aimySpeech)))
        
        textQueue.removeValue(forKey: utterance)
    }
}
