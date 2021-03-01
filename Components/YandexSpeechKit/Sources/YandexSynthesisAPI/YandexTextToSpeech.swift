//
//  YandexTextToSpeech.swift
//  YandexSpeechKit
//
//  Created by Vladislav Popovich on 30.01.2020.
//  Copyright © 2020 Just Ai. All rights reserved.
//

import Foundation
import AVFoundation
import Aimybox


public class YandexTextToSpeech: AimyboxComponent, TextToSpeech {
    /**
     Used to notify *Aimybox* state machine about events.
     */
    public var notify: (TextToSpeechCallback)?
    /**
     */
    private var languageCode: String
    /** Yandex Cloud Synthesis
     */
    private var synthesisAPI: YandexSynthesisAPI!
    /**
    */
    var audioPlayer: AVAudioPlayer?
    /**
     */
    var notificationQueue: OperationQueue
    /**
     */
    var isCancelled: Bool = false
    /**
     */
    var synthesisConfig: YandexSynthesisConfig
    
    public init?(
        tokenProvider: IAMTokenProvider,
        folderID: String,
        language code: String = "ru-RU",
        config: YandexSynthesisConfig = YandexSynthesisConfig(),
        api address: URL = URL(string: "https://tts.api.cloud.yandex.net/speech/v1/tts:synthesize")!
    ) {
        synthesisConfig = config
        languageCode = code
        notificationQueue = OperationQueue()
        super.init()
        guard let token = tokenProvider.token()?.iamToken else {
            return nil
        }
        
        synthesisAPI = YandexSynthesisAPI(iAMToken: token,
                                          folderId: folderID,
                                          api: address,
                                          operation: operationQueue)
    }
    
    public func synthesize(contentsOf speeches: [AimyboxSpeech]) {
        operationQueue.addOperation { [weak self] in
            self?.prepareAudioEngine { engineIsReady in
                if engineIsReady {
                    self?.synthesize(speeches)
                } else {
                    self?.notify?(.failure(.speakersUnavailable))
                }
            }
        }
        operationQueue.waitUntilAllOperationsAreFinished()
    }
    
    public func stop() {
        operationQueue.addOperation { [weak self] in
            self?.audioPlayer?.stop()
        }
    }
    
    public func cancelSynthesis() {
        operationQueue.addOperation { [weak self] in
            self?.isCancelled = true
        }
    }
    // MARK: - Internals
    
    private func synthesize(_ speeches: [AimyboxSpeech]) {
        guard let _notify = notify else { return }
        
        _notify(.success(.speechSequenceStarted(speeches)))

        speeches.unwrapSSML.forEach { speech in
            
            guard speech.isValid() && !isCancelled else {
                return _notify(.failure(.emptySpeech(speech)))
            }
            
            synthesize(speech)
        }

        _notify(.success(.speechSequenceCompleted(speeches)))
    }
    
    private func synthesize(_ speech: AimyboxSpeech) {
        if let textSpeech = speech as? TextSpeech {
            synthesize(textSpeech)
        } else if let audioSpeech = speech as? AudioSpeech {
            synthesize(audioSpeech)
        }
    }
    
    private func synthesize(_ textSpeech: TextSpeech) {
        let synthesisGroup = DispatchGroup()
        
        synthesisGroup.enter()
        synthesisAPI.request(text: textSpeech.text, language: languageCode, config: synthesisConfig) { [unowned self] url in
            if let _wav_url = url {
                self.synthesize(textSpeech, using: _wav_url)
            }
            synthesisGroup.leave()
        }
        synthesisGroup.wait()
    }
    
    private func synthesize(_ audioSpeech: AudioSpeech) {
        synthesize(audioSpeech, using: audioSpeech.audioURL)
    }
    
    private func synthesize(_ speech: AimyboxSpeech, using url: URL) {
        guard let _notify = notify else { return }
        
        let synthesisGroup = DispatchGroup()
        
        let player = AVPlayer(url: url)
        
        let statusObservation = player.currentItem?.observe(\.status) { (item, _) in
            switch item.status {
            case .failed:
                _notify(.failure(.emptySpeech(speech)))
                synthesisGroup.leave()
                
            default:
                break
            }
        }

        let didPlayToEndObservation = NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime,
                                                                      object: player.currentItem,
                                                                      queue: notificationQueue) { _ in
            _notify(.success(.speechEnded(speech)))
            synthesisGroup.leave()
        }
        let failedToPlayToEndObservation = NotificationCenter.default.addObserver(forName: .AVPlayerItemFailedToPlayToEndTime,
                                                                                  object: player.currentItem,
                                                                                  queue: notificationQueue) { _ in
            _notify(.failure(.emptySpeech(speech)))
            synthesisGroup.leave()
        }
        
        synthesisGroup.enter()
        player.play()
        synthesisGroup.wait()
        
        statusObservation?.invalidate()
        NotificationCenter.default.removeObserver(didPlayToEndObservation)
        NotificationCenter.default.removeObserver(failedToPlayToEndObservation)
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
