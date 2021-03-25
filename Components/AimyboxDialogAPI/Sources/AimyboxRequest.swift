//
//  AimyboxRequest.swift
//  Aimybox
//
//  Created by Vladislav Popovich on 13.12.2019.
//

#if canImport(Aimybox)
import Aimybox

public class AimyboxRequest: Request {
    public init(query: String, apiKey: String, unitKey: String, data: [String : Data]) {
        self.query = query
        self.apiKey = apiKey
        self.unitKey = unitKey
        self.data = data
    }
    
    public var query: String
    
    public var apiKey: String
    
    public var unitKey: String
    
    public var data: [String: Data]
}

extension AimyboxRequest: Encodable {
    enum CodingKeys: String, CodingKey {
        case query
        case apiKey = "key"
        case unitKey = "unit"
        case data
    }
}

#endif
