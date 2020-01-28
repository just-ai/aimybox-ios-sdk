//
//  IAMTokenGenerator.swift
//  AimyboxCore
//
//  Created by Vladislav Popovich on 23.01.2020.
//  Copyright © 2020 Just Ai. All rights reserved.
//
import Foundation


public struct IAMToken: Codable {
    
    var iamToken: String
}

public class IAMTokenGenerator {
    
    public static func token(api tokenURL: URL, passport token: String) -> IAMToken? {
    
        var request = URLRequest(url: tokenURL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.httpBody = "{ \"yandexPassportOauthToken\": \"\(token)\"}".data(using: .utf8)

        return perform(request: request) // blocking
    }
    
    private static func perform<T: Codable>(request: URLRequest) -> T? {
        
        let group = DispatchGroup()

        var result: T? = nil
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            defer {
                group.leave()
            }
            
            guard error == nil else {
                return
            }
            
            guard let code = (response as? HTTPURLResponse)?.statusCode, 200..<300 ~= code else {
                return
            }
            
            guard let _data = data else {
                return
            }
            
            result = try? JSONDecoder().decode(T.self, from: _data)
        }
        
        group.enter()
        DispatchQueue.global().async {
            task.resume()
        }
        
        let _ = group.wait(timeout: .now() + 10.0)

        return result
    }
}
