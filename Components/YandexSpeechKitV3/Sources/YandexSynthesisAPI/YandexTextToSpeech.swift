//
//  YandexTextToSpeech.swift
//  YandexSpeechKit
//
//  Created by Vladislav Popovich on 30.01.2020.
//  Copyright © 2020 Just Ai. All rights reserved.
//

import AVFoundation

public
class YandexTextToSpeech: AimyboxComponent, TextToSpeech {
    /**
    Used to notify *Aimybox* state machine about events.
    */
    public
    var notify: (TextToSpeechCallback)?
    /**
    */
    private
    var languageCode: String
    /** Yandex Cloud Synthesis
    */
    private
    lazy var synthesisAPI = YandexSynthesisAPI(
        iAMToken: token,
        folderId: folderID,
        host: host,
        port: port,
        operation: operationQueue,
        dataLoggingEnabled: dataLoggingEnabled,
        normalizePartialData: normalizePartialData
    )
    /**
    */
    var player: AVPlayer?
    /**
    */
    var notificationQueue: OperationQueue
    /**
    */
    var isCancelled = false
    /**
    */
    var synthesisConfig: YandexSynthesisConfig

    private
    let token: String

    private
    let folderID: String

    private
    let host: String

    private
    let port: Int

    private
    let dataLoggingEnabled: Bool

    private
    let normalizePartialData: Bool

    public
    init?(
        tokenProvider: IAMTokenProvider,
        folderID: String,
        language code: String = "ru-RU",
        config: YandexSynthesisConfig = YandexSynthesisConfig(),
        dataLoggingEnabled: Bool = false,
        normalizePartialData: Bool = false,
        host: String = "tts.api.cloud.yandex.net",
        port: Int = 443
    ) {
        self.synthesisConfig = config
        self.languageCode = code
        self.notificationQueue = OperationQueue()
        guard let token = tokenProvider.token()?.iamToken else {
            return nil
        }
        self.token = token
        self.folderID = folderID
        self.dataLoggingEnabled = dataLoggingEnabled
        self.normalizePartialData = normalizePartialData
        self.host = host
        self.port = port
        super.init()
    }

    public
    func synthesize(contentsOf speeches: [AimyboxSpeech]) {
        isCancelled = false
        operationQueue.addOperation { [weak self] in
            self?.prepareAudioEngineForMultiRoute { engineIsReady in
                if engineIsReady {
                    self?.synthesize(speeches)
                } else {
                    self?.notify?(.failure(.speakersUnavailable))
                }
            }
        }
        operationQueue.waitUntilAllOperationsAreFinished()
    }

    public
    func stop() {
        isCancelled = true
        player?.pause()
    }

    public
    func cancelSynthesis() {
        operationQueue.addOperation { [weak self] in
            self?.isCancelled = true
        }
    }
    // MARK: - Internals

    private
    func synthesize(_ speeches: [AimyboxSpeech]) {
        guard let notify = notify else {
            return
        }

        notify(.success(.speechSequenceStarted(speeches)))

        speeches.unwrapSSML.forEach { speech in

            guard speech.isValid() && !isCancelled else {
                return notify(.failure(.emptySpeech(speech)))
            }

            synthesize(speech)
        }

        notify(
            isCancelled
                ? .failure(.speechSequenceCancelled(speeches))
                : .success(.speechSequenceCompleted(speeches))
        )
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
        let synthesisGroup = DispatchGroup()

        synthesisGroup.enter()
        synthesisAPI.request(
            text: textSpeech.text,
            language: languageCode,
            config: synthesisConfig
        ) { [weak self] in
            if let url = $0, self?.isCancelled == false {
                self?.notify?(.success(.speechDataReceived(textSpeech)))
                self?.synthesize(textSpeech, using: url)
            } else if self?.isCancelled == true {
                self?.notify?(.failure(.speechSequenceCancelled([textSpeech])))
            } else {
                self?.notify?(.failure(.speakersUnavailable))
            }
            synthesisGroup.leave()
        }
        synthesisGroup.wait()
    }

    private
    func synthesize(_ audioSpeech: AudioSpeech) {
        synthesize(audioSpeech, using: audioSpeech.audioURL)
    }

    private
    func synthesize(_ speech: AimyboxSpeech, using url: URL) {
        guard let notify = notify else {
            return
        }

        let synthesisGroup = DispatchGroup()

        let player = AVPlayer(url: url)

        let statusObservation = player.currentItem?.observe(\.status) { item, _ in
            switch item.status {
            case .failed:
                notify(.failure(.emptySpeech(speech)))
                synthesisGroup.leave()
            default:
                break
            }
        }

        let stopObservation = player.observe(\.rate) { _, _ in
            guard player.rate == 0 else {
                return
            }
            notify(.success(.speechEnded(speech)))
            synthesisGroup.leave()
        }
        let failedToPlayToEndObservation = NotificationCenter.default.addObserver(
            forName: .AVPlayerItemFailedToPlayToEndTime,
            object: player.currentItem,
            queue: notificationQueue
        ) { _ in
            notify(.failure(.emptySpeech(speech)))
            synthesisGroup.leave()
        }

        synthesisGroup.enter()
        self.player = player
        if isCancelled {
            synthesisGroup.leave()
        } else {
            player.play()
            notify(.success(.speechStarted(speech)))
        }
        synthesisGroup.wait()

        self.player = nil
        stopObservation.invalidate()
        statusObservation?.invalidate()
        NotificationCenter.default.removeObserver(failedToPlayToEndObservation)
    }

}
