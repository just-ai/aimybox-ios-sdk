//
//  YandexSynthesisAPI.swift
//  YandexSpeechKit
//
//  Created by Vladislav Popovich on 30.01.2020.
//  Copyright © 2020 Just Ai. All rights reserved.
//

import AVFoundation
import Foundation
import GRPC
import Logging
import SwiftProtobuf

final
class YandexSynthesisAPI {

    typealias TtsServiceClient = Speechkit_Tts_V3_SynthesizerClient

    typealias Request = Speechkit_Tts_V3_UtteranceSynthesisRequest

    typealias Response = Speechkit_Tts_V3_UtteranceSynthesisResponse

    typealias StreamingCall = ServerStreamingCall<Request, Response>

    typealias AudioFormatOptions = Speechkit_Tts_V3_AudioFormatOptions

    typealias ContainerAudio = Speechkit_Tts_V3_ContainerAudio

    private
    let folderId: String

    private
    let operationQueue: OperationQueue

    private
    let token: String

    private
    let ttsServiceClient: TtsServiceClient

    private
    var streamingCall: YandexSynthesisAPI.StreamingCall?

    init(
        iAMToken: String,
        folderId: String,
        config: YandexTextToSpeech.Config,
        operation queue: OperationQueue

    ) {
        self.folderId = folderId
        self.operationQueue = queue
        self.token = iAMToken

        var logger = Logger(label: "gRPC TTS", factory: StreamLogHandler.standardOutput(label:))
        logger.logLevel = .debug

        let group = PlatformSupport.makeEventLoopGroup(loopCount: 1, networkPreference: .best, logger: logger)

        let callOptions = CallOptions(
            customMetadata: [
                "authorization": "Bearer \(token)",
                "x-folder-id": folderId,
                xDataLoggingEnabledKey: config.enableDataLogging ? "true" : "false",
                normalizePartialDataKey: config.normalizePartialData ? "true" : "false",
            ],
            logger: logger
        )


        var channel: GRPCChannel!

        if let pinningConfig = config.pinningConfig {
            channel = PinningChannelBuilder.createPinningChannel(with: pinningConfig, group: group)
        } else {
            channel = ClientConnection
                .usingTLSBackedByNIOSSL(on: group)
                .withBackgroundActivityLogger(logger)
                .connect(host: config.apiUrl, port: config.apiPort)
        }
        
        self.ttsServiceClient = TtsServiceClient(channel: channel, defaultCallOptions: callOptions)
    }

    func request(
        text: String,
        language code: String,
    //    config: YandexSynthesisConfig,
        config: YandexTextToSpeech.Config,
        onResponse completion: @escaping (URL?) -> Void
    ) {
        let request = Speechkit_Tts_V3_UtteranceSynthesisRequest.with {
            $0.text = text
            $0.outputAudioSpec = AudioFormatOptions.with {
                $0.containerAudio = ContainerAudio.with {
                    $0.containerAudioType = .wav
                }
            }
            $0.hints.append(Speechkit_Tts_V3_Hints.with { $0.voice = config.voice.rawValue })
            $0.hints.append(Speechkit_Tts_V3_Hints.with { $0.speed = config.speed.rawValue })
            $0.hints.append(Speechkit_Tts_V3_Hints.with { $0.volume = config.volume.rawValue })
        }

        streamingCall = ttsServiceClient.utteranceSynthesis(request) { [weak self] response in
            if response.hasAudioChunk {
                self?.perform(response.audioChunk.data, onResponse: completion)
            } else {
                completion(nil)
            }
        }
    }

    private
    func perform(_ data: Data, onResponse: @escaping (URL?) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            guard let localUrl = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
                .first?
                .appendingPathComponent("\(UUID().uuidString).wav")
            else {
                return onResponse(nil)
            }

            do {
                try data.write(to: localUrl)
                onResponse(localUrl)
                try? FileManager.default.removeItem(at: localUrl)
            } catch {
                onResponse(nil)
            }
        }
    }

}

//public
//struct YandexSynthesisConfig {
//
//    let emotion: String
//
//    let format: String
//
//    let sampleRateHertz: Int
//
//    let speed: Double
//
//    let voice: String
//
//    let volume: Double
//
//    let rawResults: Bool
//
//    public
//    init(
//        voice: String? = nil,
//        emotion: String? = nil,
//        speed: Double? = nil,
//        format: String? = nil,
//        sampleRateHertz: Int? = nil,
//        volume: Double? = nil,
//        rawResults: Bool = false
//    ) {
//        self.voice = voice ?? "alena"
//        self.emotion = emotion ?? "neutral"
//        self.speed = speed ?? 1.0
//        self.format = format ?? "lpcm"
//        self.sampleRateHertz = sampleRateHertz ?? 48_000
//        self.volume = volume ?? 1.0
//        self.rawResults = rawResults
//    }
//
//}
