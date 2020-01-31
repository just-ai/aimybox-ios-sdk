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
    internal var audioPlayer: AVAudioPlayer?
    /**
     */
    internal var notificationQueue: OperationQueue
    /**
     */
    internal var blockGroup: DispatchGroup
    /**
     */
    internal var isCancelled: Bool = false
    /**
     */
    internal var synthesisConfig: YandexSynthesisConfig
    
    public init?(
        tokenProvider: IAMTokenProvider,
        folderID: String,
        language code: String = "ru-RU",
        config: YandexSynthesisConfig = .defaultConfig,
        api address: URL = URL(string: "https://tts.api.cloud.yandex.net/speech/v1/tts:synthesize")!
    ) {
        synthesisConfig = config
        languageCode = code
        blockGroup = DispatchGroup()
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
        isCancelled = true
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
        blockGroup.enter()
        
        synthesisAPI.request(text: textSpeech.text, language: languageCode, config: synthesisConfig) { [weak self] url in
            
            guard let _local_url = url else {
                self?.notify?(.failure(.emptySpeech(textSpeech)))
                return
            }
            
            let myGroup = DispatchGroup()
            
            let player = AVPlayer(url: _local_url)
            
            let statusObservation = player.currentItem?.observe(\.status) { [weak self] (item, _) in
                switch item.status {
                case .failed:
                    myGroup.leave()
                    self?.notify?(.failure(.emptySpeech(textSpeech)))
                    break
                default:
                    break
                }
            }

            let didPlayToEndObservation = NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime,
                                                                          object: player.currentItem,
                                                                          queue: self!.notificationQueue) { [weak self] _ in
                self?.notify?(.success(.speechEnded(textSpeech)))
                myGroup.leave()
            }
            let failedToPlayToEndObservation = NotificationCenter.default.addObserver(forName: .AVPlayerItemFailedToPlayToEndTime,
                                                                                      object: player.currentItem,
                                                                                      queue: self!.notificationQueue) { [weak self] _ in
                self?.notify?(.failure(.emptySpeech(textSpeech)))
                myGroup.leave()
            }
            DispatchQueue.main.async {
                player.play()
            }
            
            myGroup.wait()
            
            statusObservation?.invalidate()
            NotificationCenter.default.removeObserver(didPlayToEndObservation)
            NotificationCenter.default.removeObserver(failedToPlayToEndObservation)
    
        }
        
        blockGroup.wait()
    }
    
    private func synthesize(_ audioSpeech: AudioSpeech) {
        blockGroup.enter()
        
        let player = AVPlayer(url: audioSpeech.audioURL)
        
        let statusObservation = player.currentItem?.observe(\.status) { [weak self] (item, _) in
            switch item.status {
            case .failed:
                self?.blockGroup.leave()
                self?.notify?(.failure(.emptySpeech(audioSpeech)))
                break
            default:
                break
            }
        }

        let didPlayToEndObservation = NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime,
                                                                      object: player.currentItem,
                                                                      queue: notificationQueue) { [weak self] _ in
            self?.notify?(.success(.speechEnded(audioSpeech)))
            self?.blockGroup.leave()
        }
        let failedToPlayToEndObservation = NotificationCenter.default.addObserver(forName: .AVPlayerItemFailedToPlayToEndTime,
                                                                                  object: player.currentItem,
                                                                                  queue: notificationQueue) { [weak self] _ in
            self?.notify?(.failure(.emptySpeech(audioSpeech)))
            self?.blockGroup.leave()
        }
        
        player.play()
        blockGroup.wait()
        
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
