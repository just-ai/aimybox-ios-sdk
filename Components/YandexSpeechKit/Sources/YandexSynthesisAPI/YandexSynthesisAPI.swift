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
        host: String,
        port: Int,
        operation queue: OperationQueue,
        dataLoggingEnabled: Bool
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
                "x-client-request-id": uuid,
                "x-folder-id": folderId,
                xDataLoggingEnabledKey: dataLoggingEnabled ? "true" : "false",
            ],
            logger: logger
        )

        let channel = ClientConnection
            .secure(group: group)
            .withBackgroundActivityLogger(logger)
            .connect(host: host, port: port)

        self.ttsServiceClient = TtsServiceClient(channel: channel, defaultCallOptions: callOptions)
    }

    func request(
        text: String,
        language code: String,
        config: YandexSynthesisConfig,
        onResponse completion: @escaping (URL?) -> Void
    ) {
        let request = Speechkit_Tts_V3_UtteranceSynthesisRequest.with {
            $0.text = text
            $0.model = "general"
            $0.outputAudioSpec = AudioFormatOptions.with {
                $0.containerAudio = ContainerAudio.with {
                    $0.containerAudioType = .wav
                }
            }
            $0.hints.append(
                Speechkit_Tts_V3_Hints.with {
                    $0.voice = config.voice
                }
            )
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
                .appendingPathComponent("\(UUID().uuidString).wav") else {
                return onResponse(nil)
            }

            try? WAVFileGenerator().createWAVFile(using: data).write(to: localUrl)

            onResponse(localUrl)

            try? FileManager.default.removeItem(at: localUrl)
        }
    }

}

public
struct YandexSynthesisConfig {

    let emotion: String

    let format: String

    let sampleRateHertz: Int

    let speed: Float

    let voice: String

    public
    init(
        voice: String? = nil,
        emotion: String? = nil,
        speed: Float? = nil,
        format: String? = nil,
        sampleRateHertz: Int? = nil
    ) {
        self.voice = voice ?? "alena"
        self.emotion = emotion ?? "neutral"
        self.speed = speed ?? 1.0
        self.format = format ?? "lpcm"
        self.sampleRateHertz = sampleRateHertz ?? 48_000
    }

}

public
extension YandexSynthesisConfig {

    var asParams: [String: String] {
        var params = [String: String]()

        params["emotion"] = emotion
        params["format"] = format
        params["sampleRateHertz"] = String(sampleRateHertz)
        params["speed"] = String(speed)
        params["voice"] = voice

        return params
    }
}

private
let uuid: String = {
    guard let uuid = UIDevice.current.identifierForVendor?.uuidString else {
        fatalError()
    }
    return uuid
}()
