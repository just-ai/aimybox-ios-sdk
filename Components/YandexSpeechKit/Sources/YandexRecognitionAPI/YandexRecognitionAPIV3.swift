//
//  YandexRecognitionAPI.swift
//  AimyboxCore
//
//  Created by Vladislav Popovich on 27.01.2020.
//  Copyright © 2020 Just Ai. All rights reserved.
//

import GRPC
import Logging
import NIO
import NIOCore
import NIOSSL
import SwiftProtobuf

final
class YandexRecognitionAPIV3 {

    typealias StreamingCall = BidirectionalStreamingCall<Request, Response>

    typealias SttServiceClient = Speechkit_Stt_V3_RecognizerClient

    typealias Request = Speechkit_Stt_V3_StreamingRequest

    typealias Response = Speechkit_Stt_V3_StreamingResponse

    typealias TextNormalization = Speechkit_Stt_V3_TextNormalizationOptions.TextNormalization

    private
    let operationQueue: OperationQueue

    private
    let sttServiceClient: SttServiceClient

    private
    var streamingCall: YandexRecognitionAPIV3.StreamingCall?

    private
    var config: YandexSpeechToText.Config

    private
    var language: [String]

    init(
        iAM iAMToken: String,
        folderId: String,
        language code: String,
        config: YandexSpeechToText.Config,
        operation queue: OperationQueue
    ) {
        var logger = Logger(label: "gRPC STT", factory: StreamLogHandler.standardOutput(label:))
        logger.logLevel = .debug

        self.config = config
        self.language = [code]

        let group = PlatformSupport.makeEventLoopGroup(loopCount: 1, networkPreference: .best, logger: logger)

        let callOptions = CallOptions(
            customMetadata: [
                "authorization": "Bearer \(iAMToken)",
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

        self.sttServiceClient = SttServiceClient(channel: channel, defaultCallOptions: callOptions)

        self.operationQueue = queue
    }

    public
    func openStream(
        onOpen: @escaping (StreamingCall?) -> Void,
        onResponse: @escaping (Response) -> Void
    ) {
        guard streamingCall == nil else {
            return
        }

        streamingCall = sttServiceClient.recognizeStreaming { [weak self] response in
            self?.operationQueue.addOperation {
                onResponse(response)
            }
        }

        let request = Request.with {
            $0.sessionOptions.recognitionModel.audioFormat.rawAudio.sampleRateHertz = config.sampleRate.rawValue
            $0.sessionOptions.recognitionModel.audioFormat.rawAudio.audioEncoding = .linear16Pcm
            $0.sessionOptions.recognitionModel.audioFormat.rawAudio.audioChannelCount = 1
            $0.sessionOptions.recognitionModel.languageRestriction.restrictionType = .whitelist
            $0.sessionOptions.recognitionModel.languageRestriction.languageCode = language
            $0.sessionOptions.recognitionModel
                .textNormalization.textNormalization = (config.rawResults ? .enabled : .disabled)
            $0.sessionOptions.recognitionModel.textNormalization.literatureText = config.literatureText
            $0.sessionOptions.recognitionModel.textNormalization.profanityFilter = config.enableProfanityFilter

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

let xDataLoggingEnabledKey = "x-data-logging-enabled"
let normalizePartialDataKey = "x-normalize-partials"

private
let uuid: String = {
    guard let uuid = UIDevice.current.identifierForVendor?.uuidString else {
        fatalError()
    }
    return uuid
}()
