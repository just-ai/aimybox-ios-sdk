//
//  AVTextToSpeech.swift
//  Aimybox
//
//  Created by Vladyslav Popovych on 01.12.2019.
//

import AVFoundation
import Foundation

public
class AVTextToSpeech: AimyboxComponent, TextToSpeech {
    /**
    The rate at which the utterance will be spoken. The default rate is *AVSpeechUtteranceDefaultSpeechRate*
    */
    public
    var rate: Float
    /**
    The voice used to speak the utterance.
    */
    public
    var voice: AVSpeechSynthesisVoice?
    /**
    The volume used when speaking the utterance. Allowed values are in t
    he range from 0.0 (silent) to 1.0 (loudest). The default volume is 1.0.
    */
    public
    var volume: Float
    /**
    The default pitch is 1.0. Allowed values are in the range from 0.5 (for lower pitch) to 2.0 (for higher pitch).
    */
    public
    var pitchMultiplier: Float
    /**
    Used to notify *Aimybox* state machine about events.
    */
    public
    var notify: (TextToSpeechCallback)?
    /**
    Speech synthesizer. You can customize it using public props above.
    */
    private
    var speechSynthesizer: AVSpeechSynthesizer
    /**
    To notify about start/end of synthesizing.
    */
    var textQueue: [AVSpeechUtterance: AimyboxSpeech]
    /**
    */
    public
    var blockGroup: DispatchGroup

    // swiftlint:disable:next weak_delegate
    var speechDelegate: AVTextToSpeechDelegate

    var audioPlayer: AVAudioPlayer?

    var notificationQueue: OperationQueue

    var isCancelled = false

    private
    override
    init() {
        rate = AVSpeechUtteranceDefaultSpeechRate
        volume = 1.0
        pitchMultiplier = 1.0
        speechSynthesizer = AVSpeechSynthesizer()
        textQueue = [:]
        blockGroup = DispatchGroup()
        speechDelegate = AVTextToSpeechDelegate()
        notificationQueue = OperationQueue()
        super.init()
        speechDelegate.tts = self
        speechSynthesizer.delegate = speechDelegate
    }

    public
    init?(locale: Locale? = nil) {
        rate = AVSpeechUtteranceDefaultSpeechRate
        voice = AVSpeechSynthesisVoice(language: locale?.languageCode)
        volume = 1.0
        pitchMultiplier = 1.0
        speechSynthesizer = AVSpeechSynthesizer()
        textQueue = [:]
        blockGroup = DispatchGroup()
        speechDelegate = AVTextToSpeechDelegate()
        notificationQueue = OperationQueue()
        super.init()
        speechDelegate.tts = self
        speechSynthesizer.delegate = speechDelegate
    }

    // MARK: - TextToSpeech

    public
    func synthesize(contentsOf speeches: [AimyboxSpeech], onlyText: Bool) {
        operationQueue.addOperation { [weak self] in
            self?.prepareAudioEngineForMultiRoute { engineIsReady in
                if engineIsReady {
                    self?.synthesize(speeches, onlyText)
                } else {
                    self?.notify?(.failure(.speakersUnavailable))
                }
            }
        }
        operationQueue.waitUntilAllOperationsAreFinished()
    }

    public
    func stop() {
        operationQueue.addOperation { [weak self] in
            self?.speechSynthesizer.stopSpeaking(at: .word)
        }
    }

    public
    func cancelSynthesis() {
        isCancelled = true
    }

    // MARK: - Internals

    private
    func synthesize(_ speeches: [AimyboxSpeech], _ onlyText: Bool) {
        guard let notify = notify else {
            return
        }

        notify(.success(.speechSequenceStarted(speeches)))
        
        let elementProc = {[weak self] (speechIn: AimyboxSpeech) in
            guard speechIn.isValid() && self?.isCancelled == false else {
                notify(.failure(.emptySpeech(speechIn)))
                return
            }

            self?.synthesize(speechIn)
        }

        if onlyText {
            speeches.forEach { speech in
                elementProc(speech)
            }
        } else {
            speeches.unwrapSSML.forEach { speech in
                elementProc(speech)
            }
        }
        
        notify(.success(.speechSequenceCompleted(speeches)))
    }

    private
    func synthesize(_ speech: AimyboxSpeech) {
        if let textSpeech = speech as? TextSpeech {
            synthesize(textSpeech)
        } else if let audioSpeech = speech as? AudioSpeech {
            synthesize(audioSpeech)
        }
    }

    private
    func synthesize(_ textSpeech: TextSpeech) {
        let utterance = AVSpeechUtterance(string: textSpeech.text)
        utterance.rate = rate
        utterance.voice = voice
        utterance.volume = volume
        utterance.pitchMultiplier = pitchMultiplier

        blockGroup.enter()
        notify?(.success(.speechDataReceived(textSpeech)))
        speechSynthesizer.speak(utterance)

        textQueue[utterance] = textSpeech
        blockGroup.wait()
    }

    private
    func synthesize(_ audioSpeech: AudioSpeech) {
        blockGroup.enter()

        let player = AVPlayer(url: audioSpeech.audioURL)

        let statusObservation = player.currentItem?.observe(\.status) { [weak self] item, _ in
            switch item.status {
            case .failed:
                self?.blockGroup.leave()
                self?.notify?(.failure(.emptySpeech(audioSpeech)))
            default:
                break
            }
        }

        let didPlayToEndObservation = NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: player.currentItem,
            queue: notificationQueue
        ) { [weak self] _ in
            self?.notify?(.success(.speechEnded(audioSpeech)))
            self?.blockGroup.leave()
        }
        let failedToPlayToEndObservation = NotificationCenter.default.addObserver(
            forName: .AVPlayerItemFailedToPlayToEndTime,
            object: player.currentItem,
            queue: notificationQueue
        ) { [weak self] _ in
            self?.notify?(.failure(.emptySpeech(audioSpeech)))
            self?.blockGroup.leave()
        }

        player.play()
        blockGroup.wait()

        statusObservation?.invalidate()
        NotificationCenter.default.removeObserver(didPlayToEndObservation)
        NotificationCenter.default.removeObserver(failedToPlayToEndObservation)
    }

}

class AVTextToSpeechDelegate: NSObject, AVSpeechSynthesizerDelegate {

    weak var tts: AVTextToSpeech?

    public
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        guard let aimySpeech = tts?.textQueue[utterance] else {
            return
        }

        tts?.notify?(.success(.speechStarted(aimySpeech)))
    }

    public
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        guard let aimySpeech = tts?.textQueue[utterance] else {
            return
        }

        tts?.notify?(.success(.speechEnded(aimySpeech)))

        tts?.textQueue.removeValue(forKey: utterance)

        tts?.blockGroup.leave()
    }

    public
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        tts?.blockGroup.leave()
    }

    public
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didPause utterance: AVSpeechUtterance) {
        tts?.blockGroup.leave()
    }

}
