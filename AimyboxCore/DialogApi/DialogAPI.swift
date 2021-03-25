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
public
protocol DialogAPI: AimyboxComponent {
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
    func send(request: TRequest) throws -> TResponse
    /**
    Used to notify *Aimybox* state machine about events.
    */
    var notify: (DialogAPICallback)? { get set }
    /**
    Number of one second polls for request result.
     
    - Note: Use ```10``` attempts as default value.
    */
    var timeoutPollAttempts: Int { get set }
}

public
typealias DialogAPICallback = (DialogAPIResult) -> Void

extension DialogAPI {

    public
    func send(query: String, sender aimybox: Aimybox) {

        cancelRunningOperation()

        let apiOperation = DialogAPISendOperation<Self>(query: query, dialogAPI: self)

        apiOperation.completionBlock = { [weak self] in

            guard let result = apiOperation.result else {
                return
            }

            self?.handle(response: result, sender: aimybox)
        }

        operationQueue.addOperation(apiOperation)
    }
    /**
    Cancels request if any is pending.
    */
    public
    func cancelRequest() {
        cancelRunningOperation()
    }

    private
    func handle(response: TResponse, sender aimybox: Aimybox) {
        let handleOperation = DialogAPIHandleOperation<Self>(response: response, dialogAPI: self, aimybox: aimybox)
        notify?(.success(.responseReceived(response)))
        operationQueue.addOperation(handleOperation)

    }

}
