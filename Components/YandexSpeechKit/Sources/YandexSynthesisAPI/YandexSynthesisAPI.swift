//
//  YandexSynthesisAPI.swift
//  YandexSpeechKit
//
//  Created by Vladislav Popovich on 30.01.2020.
//  Copyright © 2020 Just Ai. All rights reserved.
//

import Foundation
import AVFoundation

final class YandexSynthesisAPI {

    private let address: URL

    private let dataLoggingEnabled: Bool

    private let folderId: String

    private let operationQueue: OperationQueue

    private let token: String

    init(
        iAMToken: String,
        folderId: String,
        api address: URL,
        operation queue: OperationQueue,
        dataLoggingEnabled: Bool
    ) {
        self.address = address
        self.dataLoggingEnabled = dataLoggingEnabled
        self.folderId = folderId
        self.operationQueue = queue
        self.token = iAMToken
    }
    
    func request(
        text: String,
        language code: String,
        config: YandexSynthesisConfig,
        onResponse completion: @escaping (URL?) -> Void
    ) {
        var components = URLComponents(url: address, resolvingAgainstBaseURL: true)!
        
        var queries = [
            URLQueryItem(name: "folderId", value: folderId),
            URLQueryItem(name: "text", value: text),
            URLQueryItem(name: "lang", value: code)
        ]

        queries.append(contentsOf: config.asParams.map { URLQueryItem(name: $0.0, value: $0.1) })
        
        components.queryItems = queries

        guard let url = components.url else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        if dataLoggingEnabled {
            request.addValue(xDataLoggingEnabledKey, forHTTPHeaderField: "true")
        }
        perform(request, onResponse: completion)
    }
    
    private func perform(_ request: URLRequest, onResponse: @escaping (URL?) -> Void) {
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                return onResponse(nil)
            }
            
            guard let code = (response as? HTTPURLResponse)?.statusCode, 200..<300 ~= code else {
                return onResponse(nil)
            }
            
            guard let _local_data = data else {
                return onResponse(nil)
            }
            
            guard let _local_url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
                .first?
                .appendingPathComponent("\(UUID().uuidString).wav") else {
                return onResponse(nil)
            }
            
            try? WAVFileGenerator().createWAVFile(using: _local_data).write(to: _local_url)
            
            onResponse(_local_url)
            
            try? FileManager.default.removeItem(at: _local_url)
        }
         
        DispatchQueue.global(qos: .userInitiated).async {
            task.resume()
        }
    }

}

public struct YandexSynthesisConfig {
    
    let emotion: String

    let format: String

    let sampleRateHertz: Int

    let speed: Float

    let voice: String

    public init(
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
        self.sampleRateHertz = sampleRateHertz ?? 48000
    }

}

public extension YandexSynthesisConfig {

    var asParams: [String : String] {
        var params = [String : String]()
        
        params["emotion"] = emotion
        params["format"] = format
        params["sampleRateHertz"] = String(sampleRateHertz)
        params["speed"] = String(speed)
        params["voice"] = voice

        return params
    }
}
