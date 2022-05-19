//
//  YandexRecognitionAPI.swift
//  AimyboxCore
//
//  Created by Vladislav Popovich on 27.01.2020.
//  Copyright © 2020 Just Ai. All rights reserved.
//

import Foundation
import GRPC
import NIOCore
import AimyboxCore

typealias Request = Yandex_Cloud_Ai_Stt_V2_StreamingRecognitionRequest
typealias Response = Yandex_Cloud_Ai_Stt_V2_StreamingRecognitionResponse
typealias StreamingRecognizeCall = BidirectionalStreamingCall

final
class YandexRecognitionAPI {
    
    

    private
    let dataLoggingEnabled: Bool

    private
    let iAMToken: String
    
    private
    let operationQueue: OperationQueue
    
    private
    let maxAudioChunks : Int?
    
    private
    let recognitionTimeout: Int

    private
    let recognitionConfig: Yandex_Cloud_Ai_Stt_V2_RecognitionConfig

    private
    var channel: GRPCChannel?

    private
    var client: Yandex_Cloud_Ai_Stt_V2_SttServiceClient?
    
    private
    var callOptions : CallOptions

//    private
//    var stream: Yandex_Cloud_Ai_Stt_V2_SttServiceStreamingRecognizeCall?

    init(
        iAM token: String,
        folderID: String,
        language code: String = "ru-RU",
        config : YandexSpeechToText.Config,
        maxAudioChunks : Int? = nil,
        recognitionTimeout: Int = 10000,
        operation queue: OperationQueue
       
    ) {
        
        self.dataLoggingEnabled = config.enableDataLogging
        self.iAMToken = token
        self.operationQueue = queue
        //self.recognitionConfig = config ?? .defaultConfig(folderID: folderID, language: code)
        self.maxAudioChunks = maxAudioChunks
        self.recognitionTimeout = recognitionTimeout
        
        let group = PlatformSupport.makeEventLoopGroup(loopCount: 1)
        defer {
          try? group.syncShutdownGracefully()
        }
        
        if let pinningConfig = config.pinningConfig {
            self.channel = PinningChannelBuilder().createPinningChannel(with: pinningConfig, group: group)
        } else {
            do{
            self.channel = try GRPCChannelPool.with(
                target: .host(config.apiUrl, port:config.apiPort),
              transportSecurity: .plaintext,
              eventLoopGroup: group
            )
            } catch{
                
            }
        }
        
    
        self.callOptions = CallOptions(customMetadata: [
          "authorization": "Bearer \(iAMToken)",
          "x-data-logging-enabled" : "\(config.enableDataLogging)",
          "x-normalize-partials" : "\(config.normalizePartialData)"
        ])
        
        recognitionConfig = Yandex_Cloud_Ai_Stt_V2_RecognitionConfig.setConfig(folderID: folderID, code, config)

    }
    
    public
    func openStream(
            onResponse: @escaping (Yandex_Cloud_Ai_Stt_V2_StreamingRecognitionResponse) -> Void,
            error handler: @escaping (Error) -> Void) ->  StreamingRecognizeCall<Request, Response>?{
                
        if let initedChannel = self.channel {
            client = Yandex_Cloud_Ai_Stt_V2_SttServiceClient(channel: initedChannel , defaultCallOptions: self.callOptions)
        } else {
            //handler()
        }
        
        let call = client?.streamingRecognize{ response in
            onResponse(response)
        }
         
        let request = Request.with{
                $0.config = recognitionConfig
        }
        call?.sendMessage(request, promise: nil)
        
        return call
    }

//    public
//    func openStream(
//        onOpen: @escaping (Yandex_Cloud_Ai_Stt_V2_SttServiceStreamingRecognizeCall?) -> Void,
//        onResponse: @escaping (Yandex_Cloud_Ai_Stt_V2_StreamingRecognitionResponse) -> Void,
//        error handler: @escaping (Error) -> Void,
//        completion: @escaping () -> Void
//    ) {
//
//
//        do {
//
//
//
//            try client?.metadata.add(key: "authorization", value: "Bearer \(iAMToken)")
//            if dataLoggingEnabled {
//                try client?.metadata.add(key: xDataLoggingEnabledKey, value: "true")
//            }
//
//            stream = try client?.streamingRecognize { [weak self] result in
//                self?.operationQueue.addOperation {
//                    result.success
//                        ? completion()
//                        : handler(NSError(domain: result.description, code: result.statusCode.rawValue, userInfo: nil))
//                }
//            }
//
//            let streamingRecognitionRequest = Yandex_Cloud_Ai_Stt_V2_StreamingRecognitionRequest.with {
//                $0.config = recognitionConfig
//            }
//            try stream?.send(streamingRecognitionRequest) { _ in }
//
//            onOpen(stream)
//
//            operationQueue.addOperation { [weak self] in
//                try? self?.receiveMessages(on: onResponse, error: handler, stream: self?.stream)
//            }
//
//        } catch {
//            handler(error)
//        }
//    }

    public
    func closeStream() {
//        try? client?.closeSend { [weak self] in
//            self?.stream = nil
//        }
        client = nil
    }

//    private
//    func receiveMessages(
//        on response: @escaping (Response) -> Void,
//        error handler: @escaping (Error) -> Void,
//        stream: StreamingRecognizeCall<Request, Response>?
//    ) throws {
//        try stream?.receive { [weak self, weak stream] result in
//            self?.operationQueue.addOperation {
//                switch result {
//                case .result(let object) where object != nil:
//                    // swiftlint:disable:next force_unwrapping
//                    response(object!)
//
//                case .error(let error):
//                    handler(error)
//
//                default:
//                    break
//                }
//
//                self?.operationQueue.addOperation { [weak self] in
//                    try? self?.receiveMessages(on: response, error: handler, stream: stream)
//                }
//            }
//        }
//    }

}

extension Yandex_Cloud_Ai_Stt_V2_RecognitionConfig {

    static func setConfig(folderID: String, _ code: String, _ config : YandexSpeechToText.Config) -> Yandex_Cloud_Ai_Stt_V2_RecognitionConfig {
        Yandex_Cloud_Ai_Stt_V2_RecognitionConfig.with {
            $0.folderID = folderID
            $0.specification = Yandex_Cloud_Ai_Stt_V2_RecognitionSpec.with {
                $0.model = "general"
                $0.profanityFilter = config.enableProfanityFilter
                $0.partialResults = config.enablePartialResults
                $0.audioEncoding = .linear16Pcm
                $0.sampleRateHertz = config.sampleRate.rawValue
                $0.audioChannelCount = 1
                $0.singleUtterance = true
                $0.languageCode = code
                $0.rawResults = config.rawResults
                $0.literatureText = config.literatureText
            }
        }
    }
}

let xDataLoggingEnabledKey = "x-data-logging-enabled"
