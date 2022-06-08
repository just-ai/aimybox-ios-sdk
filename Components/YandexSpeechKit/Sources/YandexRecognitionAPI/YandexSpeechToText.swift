//
//  YandexSpeechToText.swift
//  YandexSpeechKit
//
//  Created by Vladislav Popovich on 28.01.2020.
//  Copyright © 2020 Just Ai. All rights reserved.
//

// swiftlint:disable closure_body_length

import AVFoundation
import Foundation
import GRPC
import NIO
import NIOCore

#if SDK_BUILD
import AimyboxCore
import Utils
#endif

public
class YandexSpeechToText: AimyboxComponent, SpeechToText {

    public
    struct Config {

        public
        var apiUrl = "stt.api.cloud.yandex.net"

        public
        var apiPort = 443

        public
        var enableProfanityFilter = true

        public
        var enablePartialResults = true

        public
        var sampleRate = SampleRate.sampleRate48KHz

        public
        var rawResults = false

        public
        var literatureText = false

        public
        var enableDataLogging = false

        public
        var normalizePartialData = false

        public
        var pinningConfig: PinningConfig?

        public
        init() {}

    }

    /**
    Customize `config` parameter if you change recognition audioFormat in recognition config.
    */
    public
    var audioFormat: AVAudioFormat = .defaultFormat
    /**
    Used to notify *Aimybox* state machine about events.
    */
    public
    var notify: (SpeechToTextCallback)?
    /**
    Used for audio signal processing.
    */
    private
    let audioEngine: AVAudioEngine
    /**
    Node on which audio stream is routed.
    */
    private
    var audioInputNode: AVAudioNode?
    /**
    */
    private
    lazy var recognitionAPI = YandexRecognitionAPIV3(
        iAM: iamToken,
        folderId: folderID,
        language: languageCode,
        config: config,
        operation: operationQueue
    )
    /**
    */
    private
    var wasSpeechStopped = true

    private
    let iamToken: String

    private
    let folderID: String

    private
    let languageCode: String

    private
    let config: YandexSpeechToText.Config

    private
    let dataLoggingEnabled: Bool

    /**
    Init that uses provided params.
    */
    public
    init?(
        tokenProvider: IAMTokenProvider,
        folderID: String,
        language code: String = "ru-RU",
        config: YandexSpeechToText.Config = YandexSpeechToText.Config()
    ) {
        let token = tokenProvider.token()

        guard let iamToken = token?.iamToken else {
            return nil
        }

        self.iamToken = iamToken
        self.folderID = folderID
        self.languageCode = code
        self.config = config
        self.audioEngine = AVAudioEngine()
        self.dataLoggingEnabled = config.enableDataLogging
        super.init()
    }

    public
    func startRecognition() {
        guard wasSpeechStopped else {
            return
        }
        wasSpeechStopped = false

        checkPermissions { [weak self] result in
            switch result {
            case .success:
                self?.onPermissionGranted()
            default:
                self?.notify?(result)
            }
        }
    }

    public
    func stopRecognition() {
        wasSpeechStopped = true
        audioEngine.stop()
        audioInputNode?.removeTap(onBus: 0)
        audioInputNode = nil
        recognitionAPI.closeStream()
    }

    public
    func cancelRecognition() {
        wasSpeechStopped = true
        audioEngine.stop()
        audioInputNode?.removeTap(onBus: 0)
        audioInputNode = nil
        operationQueue.addOperation { [weak self] in
            self?.recognitionAPI.closeStream()
            self?.notify?(.success(.recognitionCancelled))
        }
    }

    // MARK: - Internals

    private
    func onPermissionGranted() {
        prepareRecognition()
        guard !wasSpeechStopped else {
            return
        }

        do {
            try audioEngine.start()
            notify?(.success(.recognitionStarted))
        } catch {
            notify?(.failure(.microphoneUnreachable))
        }
    }

    private
    func prepareRecognition() {

        guard let notify = notify else {
            return
        }

        prepareAudioEngineForMultiRoute {
            if !$0 {
                notify(.failure(.microphoneUnreachable))
            }
        }

        // swiftlint:disable:next closure_body_length
        recognitionAPI.openStream { [audioEngine, weak self, audioFormat] stream in
            let inputNode = audioEngine.inputNode
            let inputFormat = inputNode.inputFormat(forBus: 0)
            let recordingFormat = audioFormat

            try? AVAudioSession.sharedInstance().setPreferredSampleRate(inputFormat.sampleRate)

            let converter = AVAudioConverter(from: inputFormat, to: recordingFormat)
            let ratio = Float(inputFormat.sampleRate) / Float(
                recordingFormat.sampleRate > 0 ? recordingFormat.sampleRate : AVAudioFormat.defaultFormat.sampleRate
            )

            inputNode.removeTap(onBus: 0)
            // swiftlint:disable:next closure_body_length
            inputNode.installTap(onBus: 0, bufferSize: 1024, format: inputFormat) { buffer, _ in
                // swiftlint:disable:next closure_body_length
                let request = YandexRecognitionAPIV3.Request.with { request in
                    let capacity = UInt32(Float(buffer.frameCapacity) / Float(ratio > 0 ? ratio : 1))
                    guard let outputBuffer = AVAudioPCMBuffer(
                        pcmFormat: recordingFormat,
                        frameCapacity: capacity
                    ) else {
                        return
                    }

                    outputBuffer.frameLength = outputBuffer.frameCapacity

                    let inputBlock: AVAudioConverterInputBlock = { _, outStatus in
                        outStatus.pointee = AVAudioConverterInputStatus.haveData
                        return buffer
                    }

                    let status = converter?.convert(
                        to: outputBuffer,
                        error: nil,
                        withInputFrom: inputBlock
                    )

                    switch status {
                    case .error:
                        return
                    default:
                        break
                    }

                    guard let bytes = outputBuffer.int16ChannelData else {
                        return
                    }

                    let channels = UnsafeBufferPointer(start: bytes, count: Int(audioFormat.channelCount))

                    request.chunk.data = Data(
                        bytesNoCopy: channels[0],
                        count: Int(buffer.frameCapacity * audioFormat.streamDescription.pointee.mBytesPerFrame),
                        deallocator: .none
                    )
                }
                stream?.sendMessage(request, promise: nil)
            }

            self?.audioInputNode = inputNode
            audioEngine.prepare()

        } onResponse: { [weak self] response in
            self?.proccessResults(response)
        }
    }

    private
    func proccessResults(_ response: YandexRecognitionAPIV3.Response) {

        switch response.event {
        case .partial:
            let alternativeList = response.partial.alternatives
            if !alternativeList.isEmpty {
                let bestAlternative = alternativeList.first
                let partialResult = bestAlternative?.text.trimmingCharacters(in: .whitespacesAndNewlines)
                if let resultText = partialResult {
                    notify?(.success(.recognitionPartialResult(resultText)))
                }
            }

        case .final:
            let alternativeList = response.final.alternatives
            if !alternativeList.isEmpty {
                let bestAlternative = alternativeList.first
                let partialResult = bestAlternative?.text.trimmingCharacters(in: .whitespacesAndNewlines)
                if let resultText = partialResult {
                    notify?(.success(.recognitionPartialResult(resultText)))
                    notify?(.success(.recognitionResult(resultText)))
                }
            }

        default:
            let event = response.event
            
        }

    }

    // MARK: - User Permissions

    private
    func checkPermissions(_ completion: @escaping (SpeechToTextResult) -> Void ) {

        var recordAllowed = false
        let permissionsDispatchGroup = DispatchGroup()

        permissionsDispatchGroup.enter()
        DispatchQueue.main.async {
            // Microphone recording permission
            AVAudioSession.sharedInstance().requestRecordPermission { isAllowed in
                recordAllowed = isAllowed
                permissionsDispatchGroup.leave()
            }
        }

        permissionsDispatchGroup.notify(queue: .main) {
            if recordAllowed {
                completion(.success(.recognitionPermissionsGranted))
            } else {
                completion(.failure(.microphonePermissionReject))
            }
        }
    }
}

extension AVAudioFormat {
    static var defaultFormat: AVAudioFormat {
        guard let audioFormat = AVAudioFormat(
            commonFormat: .pcmFormatInt16,
            sampleRate: 48_000,
            channels: 1,
            interleaved: false
        ) else {
            fatalError()
        }
        return audioFormat
    }
}
