//
//  YandexRecognitionAPI.swift
//  AimyboxCore
//
//  Created by Vladislav Popovich on 27.01.2020.
//  Copyright © 2020 Just Ai. All rights reserved.
//

import GRPC
import Logging
import SwiftProtobuf
import NIO
import NIOCore
import NIOSSL

final
class YandexRecognitionAPIV3 {

    typealias StreamingCall = BidirectionalStreamingCall<Request, Response>

    typealias SttServiceClient = Yandex_Cloud_Ai_Stt_V2_SttServiceClient

    typealias Config = Yandex_Cloud_Ai_Stt_V2_RecognitionConfig

    typealias Request = Yandex_Cloud_Ai_Stt_V2_StreamingRecognitionRequest

    typealias Response = Yandex_Cloud_Ai_Stt_V2_StreamingRecognitionResponse

    private
    let operationQueue: OperationQueue

    private
    let config: Config

    private
    let sttServiceClient: SttServiceClient

    private
    var streamingCall: YandexRecognitionAPIV3.StreamingCall?

    init(
        iAM iAMToken: String,
        folderID: String,
        language code: String,
        config: YandexSpeechToText.Config,
        operation queue: OperationQueue
    ) {
        var logger = Logger(label: "gRPC STT", factory: StreamLogHandler.standardOutput(label:))
        logger.logLevel = .debug

        let group = PlatformSupport.makeEventLoopGroup(loopCount: 1, networkPreference: .best, logger: logger)

        let callOptions = CallOptions(
            customMetadata: [
                "authorization": "Bearer \(iAMToken)",
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

        self.sttServiceClient = SttServiceClient(channel: channel, defaultCallOptions: callOptions)

        self.operationQueue = queue
        self.config = .defaultConfig(folderID: folderID, language: code)
    }

    public
    func openStream(
        onOpen: @escaping (StreamingCall?) -> Void,
        onResponse: @escaping (Response) -> Void
    ) {
        guard streamingCall == nil else {
            return
        }
        streamingCall = sttServiceClient.streamingRecognize { [weak self] response in
            self?.operationQueue.addOperation {
                onResponse(response)
            }
        }

        let request = Request.with {
            $0.config = config
        }
        streamingCall?.sendMessage(request, promise: nil)
        onOpen(streamingCall)
    }

    public
    func closeStream() {
        streamingCall?.cancel(promise: nil)
        streamingCall?.sendEnd()
        streamingCall = nil
    }

}

extension Yandex_Cloud_Ai_Stt_V2_RecognitionConfig {

    static func defaultConfig(folderID: String, language code: String) -> YandexRecognitionAPIV3.Config {
        YandexRecognitionAPIV3.Config.with {
            $0.folderID = folderID
            $0.specification = Yandex_Cloud_Ai_Stt_V2_RecognitionSpec.with {
                $0.audioChannelCount = 1
                $0.audioEncoding = .linear16Pcm
                $0.languageCode = code
                $0.model = "general"
                $0.partialResults = true
                $0.profanityFilter = true
                $0.sampleRateHertz = 48_000
                $0.singleUtterance = true
                $0.rawResults = false
            }
        }
    }
}

let xDataLoggingEnabledKey = "x-data-logging-enabled"
let normalizePartialDataKey = "x-normalize-partials"

private
let uuid: String = {
    guard let uuid = UIDevice.current.identifierForVendor?.uuidString else {
        fatalError()
    }
    return uuid
}()
