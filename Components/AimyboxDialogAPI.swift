//
//  AimyboxDialogAPI.swift
//  Aimybox
//
//  Created by Vladyslav Popovych on 08.12.2019.
//

import Foundation

public class AimyboxDialogAPI: AimyboxComponent, DialogAPI {

    public typealias TRequest = AimyboxRequest

    public typealias TResponse = AimyboxResponse

    public typealias TCustomSkill = AimyboxCustomSkill

    public var customSkills: [AimyboxCustomSkill] = []

    public func createRequest(query: String) -> AimyboxRequest {
        return AimyboxRequest()
    }

    public func send(request: AimyboxRequest) -> AimyboxResponse {
        return AimyboxResponse()
    }
    
    public init(projectID: String) {
        print(projectID)
    }
}

public class AimyboxRequest: Request {
    public var query: String = ""
}

public class AimyboxResponse: Response {
    public var query: String = ""
    
    public var action: String = ""
    
    public var intent: String = ""
    
    public var question: Bool = false
    
    public var replies: [Reply] = []
}

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
