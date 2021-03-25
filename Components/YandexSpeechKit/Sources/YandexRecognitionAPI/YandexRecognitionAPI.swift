//
//  YandexRecognitionAPI.swift
//  AimyboxCore
//
//  Created by Vladislav Popovich on 27.01.2020.
//  Copyright © 2020 Just Ai. All rights reserved.
//

import Foundation
import SwiftGRPC

final class YandexRecognitionAPI {

    private let apiAdress: String

    private let dataLoggingEnabled: Bool

    private let iAMToken: String

    private let operationQueue: OperationQueue

    private let recognitionConfig: Yandex_Cloud_Ai_Stt_V2_RecognitionConfig

    private var client: Yandex_Cloud_Ai_Stt_V2_SttServiceServiceClient?

    private var stream: Yandex_Cloud_Ai_Stt_V2_SttServiceStreamingRecognizeCall?

    init(
        iAM token: String,
        folderID: String,
        language code: String = "ru-RU",
        api adress: String = "stt.api.cloud.yandex.net:443",
        config: Yandex_Cloud_Ai_Stt_V2_RecognitionConfig? = nil,
        dataLoggingEnabled: Bool,
        operation queue: OperationQueue
    ) {
        self.apiAdress = adress
        self.dataLoggingEnabled = dataLoggingEnabled
        self.iAMToken = token
        self.operationQueue = queue
        self.recognitionConfig = config ?? .defaultConfig(folderID: folderID, language: code)
    }

    public func openStream(
        onOpen: @escaping (Yandex_Cloud_Ai_Stt_V2_SttServiceStreamingRecognizeCall?) -> Void,
        onResponse: @escaping (Yandex_Cloud_Ai_Stt_V2_StreamingRecognitionResponse) -> Void,
        error handler: @escaping (Error) -> Void,
        completion: @escaping () -> Void
    ) {

        let channel = Channel(address: apiAdress)
        channel.addConnectivityObserver { state in
            print("ConnectivityObserverState: \(state)")
        }

        client = Yandex_Cloud_Ai_Stt_V2_SttServiceServiceClient(channel: channel)

        do {

            try client?.metadata.add(key: "authorization", value: "Bearer \(iAMToken)")
            if dataLoggingEnabled {
                try client?.metadata.add(key: xDataLoggingEnabledKey, value: "true")
            }

            stream = try client?.streamingRecognize { [weak self] result in
                self?.operationQueue.addOperation {
                    result.success
                        ? completion()
                        : handler(NSError(domain: result.description, code: result.statusCode.rawValue, userInfo: nil))
                }
            }

            try stream?.send(
                Yandex_Cloud_Ai_Stt_V2_StreamingRecognitionRequest.with {
                    $0.config = recognitionConfig
                }
            )

            onOpen(stream)

            operationQueue.addOperation { [weak self] in
                try? self?.receiveMessages(on: onResponse, error: handler, stream: self?.stream)
            }

        } catch let grpc_error {
            handler(grpc_error)
        }
    }

    public func closeStream() {
        try? stream?.closeSend { [weak self] in
            self?.stream = nil
        }
        client = nil
    }

    private func receiveMessages(
        on response: @escaping (Yandex_Cloud_Ai_Stt_V2_StreamingRecognitionResponse) -> Void,
        error handler: @escaping (Error) -> Void,
        stream: Yandex_Cloud_Ai_Stt_V2_SttServiceStreamingRecognizeCall?
    ) throws {
        try stream?.receive { [weak self, weak stream] result in
            self?.operationQueue.addOperation {
                switch result {
                case .result(let object) where object != nil:
                    // swiftlint:disable:next force_unwrapping
                    response(object!)

                case .error(let error):
                    handler(error)

                default:
                    break
                }

                self?.operationQueue.addOperation { [weak self] in
                    try? self?.receiveMessages(on: response, error: handler, stream: stream)
                }
            }
        }
    }

}

extension Yandex_Cloud_Ai_Stt_V2_RecognitionConfig {

    static func defaultConfig(folderID: String, language code: String) -> Yandex_Cloud_Ai_Stt_V2_RecognitionConfig {
        Yandex_Cloud_Ai_Stt_V2_RecognitionConfig.with {
            $0.folderID = folderID
            $0.specification = Yandex_Cloud_Ai_Stt_V2_RecognitionSpec.with {
                $0.model = "general"
                $0.profanityFilter = true
                $0.partialResults = true
                $0.audioEncoding = .linear16Pcm
                $0.sampleRateHertz = 48000
                $0.audioChannelCount = 1
                $0.singleUtterance = true
                $0.languageCode = code
            }
        }
    }
}

let xDataLoggingEnabledKey = "x-data-logging-enabled"
