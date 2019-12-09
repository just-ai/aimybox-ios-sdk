//
//  CustomSkill.swift
//  Aimybox
//
//  Created by Vladyslav Popovych on 07.12.2019.
//

import Foundation

public protocol CustomSkillProto: class {
}

/**
 Interface for custom client-side skill.
 To enable it in Aimybox, add an instance of the skill to `Aimybox.Config.skills`.
 */
public protocol CustomSkill: CustomSkillProto {
    /**
     Adopting object must use request that conforms to `Request` protocol.
     */
    associatedtype TRequest: Request
    /**
     Adopting object must use response that conforms to `Response` protocol.
     */
    associatedtype TResponse: Response
    /**
     This method will be called just before any request to dialog api.
     You can modify the request or return it without changes.
     - Note: This method is optional. If not implemented does nothing.
     */
    func onRequest(_ request: TRequest) -> TRequest
    /**
     Determines whether the current skill can handle the `response`.
     */
    func canHandle(response: TResponse) -> Bool
    /**
     Called if `canHandle` returned true for the `response`.
     
     - Attention: Default response handler will not be called, so you should manually implement `Aimybox` behavior.
     In the most cases it is enough to call ```Aimybox.standby()``` when you finish processing.
     
     If you're going to use speech synthesis, consider to look at `Aimybox.NextAction` behavior modifier.
     */
    func onResponse(_ response: TResponse, _ aimybox: Aimybox, default handler: ResponseDefaultHandler) -> TResponse
}

public typealias ResponseDefaultHandler = (Response)->()

/**
 All methods listed here are optional for delegates to implement.
*/
public extension CustomSkill {
    func onRequest(_ request: TRequest) {}
}
