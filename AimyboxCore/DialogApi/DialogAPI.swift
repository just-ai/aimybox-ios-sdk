//
//  DialogAPI.swift
//  Aimybox
//
//  Created by Vladyslav Popovych on 07.12.2019.
//

import Foundation

/**
 Dialog API component enables your voice assistant to recognise the user's speech intention,
 perform some useful actions and return the meaningful response back to the user that can be synthesised by `TTS`.
 */
public protocol DialogAPI: class {
    /**
     Adopting object must use request type that conforms to `Request` protocol.
     - Note: `DialogAPI.TRequest` type must be tightly coupled with `CustomSkill.TRequest`.
     */
    associatedtype TRequest where Self.TRequest == Self.TCustomSkill.TRequest
    /**
     Adopting object must use response type that conforms to `Response` protocol.
     - Note: `DialogAPI.TResponse` type must be tightly coupled with `CustomSkill.TResponse`.
     */
    associatedtype TResponse where Self.TResponse == Self.TCustomSkill.TResponse
    /**
     Adopting object must use custom skill type that conforms to `CustomSkill` protocol.
     */
    associatedtype TCustomSkill: CustomSkill
    /**
     Holds all custom skills.
     */
    var customSkills: [TCustomSkill] { get set }
    /**
     Creates the dialog api request of type `TRequest`.
     */
    func createRequest(query: String) -> TRequest
    /**
     Sends the dialog api request of type `TRequest` to NLU engine, parses the response in `TResponse` and returns it.
     */
    func send(request: TRequest) -> TResponse
}

extension DialogAPI {
    
    func send(query: String, sender aimybox: Aimybox) {
        
    }
}
