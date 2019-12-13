//
//  AimyboxCustomSkill.swift
//  Aimybox
//
//  Created by Vladislav Popovich on 13.12.2019.
//

import Foundation

public class AimyboxCustomSkill: CustomSkill {

    public typealias TRequest = AimyboxRequest
    
    public typealias TResponse = AimyboxResponse
    
    public func onRequest(_ request: AimyboxRequest) -> AimyboxRequest {
        return AimyboxRequest()
    }
    
    public func canHandle(response: AimyboxResponse) -> Bool {
        return false
    }
    
    public func onResponse(_ response: AimyboxResponse, _ aimybox: Aimybox, default handler: (Response) -> ()) -> AimyboxResponse {
        return response
    }
}
