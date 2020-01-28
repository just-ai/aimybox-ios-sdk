//
//  YandexRecognitionAPI.swift
//  AimyboxCore
//
//  Created by Vladislav Popovich on 27.01.2020.
//  Copyright © 2020 Just Ai. All rights reserved.
//

import Foundation
import SwiftGRPC

class YandexRecognitionAPI {
    
    private var iAMToken: String
    
    private var apiAdress: String
    
    private var recognitionConfig: Yandex_Cloud_Ai_Stt_V2_RecognitionConfig
    
    private var client: Yandex_Cloud_Ai_Stt_V2_SttServiceServiceClient!
    
    private var operationQueue: OperationQueue
    
    init(
        iAM token: String,
        folderID: String,
        language code: String = "ru-RU",
        api adress: String = "stt.api.cloud.yandex.net:443",
        config: Yandex_Cloud_Ai_Stt_V2_RecognitionConfig? = nil,
        operation queue: OperationQueue
    ) {
        recognitionConfig = config == nil ? .defaultConfig : config!
        
        recognitionConfig.specification.languageCode = code
        recognitionConfig.folderID = folderID
        
        operationQueue = queue
        apiAdress = adress
        iAMToken = token
    }
    
    public func openStream(
        onOpen: @escaping (Yandex_Cloud_Ai_Stt_V2_SttServiceStreamingRecognizeCall)->(),
        onResponse: @escaping (Yandex_Cloud_Ai_Stt_V2_StreamingRecognitionResponse)->(),
        error handler: @escaping (Error)->(),
        completion: @escaping ()->()
    ) {
        
        let channel = Channel(address: apiAdress)
        channel.addConnectivityObserver { (state) in
            print("ConnectivityObserverState: \(state)")
        }
        
        client = Yandex_Cloud_Ai_Stt_V2_SttServiceServiceClient(channel: channel)
        
        do {
            
            try client.metadata.add(key: "authorization", value: "Bearer \(iAMToken)")
            
            let stream = try client.streamingRecognize { [weak self] (result) in
                self?.operationQueue.addOperation {
                    result.success ? completion() : handler(NSError(domain: result.description, code: result.statusCode.rawValue, userInfo: nil))
                }
            }
            
            try stream.send(
                Yandex_Cloud_Ai_Stt_V2_StreamingRecognitionRequest.with {
                    $0.config = recognitionConfig
                }
            )
            
            onOpen(stream)
            
            operationQueue.addOperation { [weak self] in
                try? self?.receiveMessages(on: onResponse, error: handler, stream: stream)
            }
            
        } catch let grpc_error {
            handler(grpc_error)
        }
    }
    
    private func receiveMessages(
        on response: @escaping (Yandex_Cloud_Ai_Stt_V2_StreamingRecognitionResponse)->(),
        error handler: @escaping (Error)->(),
        stream: Yandex_Cloud_Ai_Stt_V2_SttServiceStreamingRecognizeCall
    ) throws {
        try stream.receive { [weak self] result in
        
            switch result {
            case .result(let object) where object != nil:
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

extension Yandex_Cloud_Ai_Stt_V2_RecognitionConfig {
    
    static var defaultConfig: Yandex_Cloud_Ai_Stt_V2_RecognitionConfig {
        Yandex_Cloud_Ai_Stt_V2_RecognitionConfig.with {
            $0.specification = Yandex_Cloud_Ai_Stt_V2_RecognitionSpec.with {
                $0.model = "general"
                $0.profanityFilter = true
                $0.partialResults = true
                $0.audioEncoding = .linear16Pcm
                $0.sampleRateHertz = 48000
                $0.audioChannelCount = 1
                $0.singleUtterance = true
            }
        }
    }
}
