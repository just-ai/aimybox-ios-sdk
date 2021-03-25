//
//  AimyboxCustomSkill.swift
//  Aimybox
//
//  Created by Vladislav Popovich on 13.12.2019.
//

#if canImport(Aimybox)
import Aimybox

public class AimyboxCustomSkill: CustomSkill {

    public typealias TRequest = AimyboxRequest
    
    public typealias TResponse = AimyboxResponse
    
    public func onRequest(_ request: AimyboxRequest) -> AimyboxRequest {
        request
    }
    
    public func canHandle(response: AimyboxResponse) -> Bool {
        false
    }
    
    public func onResponse(
        _ response: AimyboxResponse,
        _ aimybox: Aimybox,
        default handler: (Response) -> Void) -> AimyboxResponse
    {
        response
    }
}

#endif
