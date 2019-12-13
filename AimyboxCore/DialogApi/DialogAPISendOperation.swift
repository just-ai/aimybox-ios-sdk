//
//  DialogAPISendOperation.swift
//  Aimybox
//
//  Created by Vladislav Popovich on 13.12.2019.
//

import Foundation

class DialogAPISendOperation<TDialogAPI: DialogAPI>: Operation {
    /**
     */
    private let defaultMaxPollAttempts = 10
    /**
     */
    private let defaultRequestTimeout = 1.0
    /**
     */
    private var query: String
    /**
    */
    private var dialogAPI: TDialogAPI
    /**
    */
    public private(set) var result: TDialogAPI.TResponse?
    
    init(query: String, dialogAPI: TDialogAPI) {
        self.query = query
        self.dialogAPI = dialogAPI
    }
    
    override public func main() {
        
        let request = dialogAPI.customSkills.reduce(into: dialogAPI.createRequest(query: query)) { (_request, _skill) in
            _skill.onRequest(_request)
        }
        
        do {
            
            let _dialogAPI = dialogAPI
            
            result = try perform(with: .now() + defaultRequestTimeout) {
                return try _dialogAPI.send(request: request)
            }
            
        } catch DialogAPIError.requestTimeout {
            dialogAPI.notify?(.failure(.requestTimeout))
        } catch DialogAPIError.requestCancellation {
            dialogAPI.notify?(.failure(.requestCancellation))
        } catch let error {
            dialogAPI.notify?(.failure(.clientSide(error)))
        }
    }
    
    private func perform<T>(with timeout: DispatchTime, _ block: @escaping () throws -> T) throws -> T {
        
        try throwIfCanceled()
        
        let timeoutSemaphore = DispatchSemaphore(value: 0)

        var response: AimyboxResult<T, Error>?
        
        // Perform block on background thread
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                response = .success(try block())
            } catch let error {
                response = .failure(error)
            }
            timeoutSemaphore.signal()
        }

        
        // Poll for cancel or timeout or success event
        var pollAttempt = 0

        while pollAttempt < defaultMaxPollAttempts {
            
            switch timeoutSemaphore.wait(timeout: timeout) {
            case .success:
                try throwIfCanceled()
                
                break // Stop polling and look for response we got

            case .timedOut:
                try throwIfCanceled()
            }
            
            pollAttempt += 1
            
            if pollAttempt == defaultMaxPollAttempts {
                throw DialogAPIError.requestTimeout
            }
        }

        // Convert response to one of known event type
        switch response {
        case .success(let result):
            return result

        case .failure(let error):
            throw error
            
        case .none:
            throw DialogAPIError.requestTimeout
        }
    }
    
    private func throwIfCanceled() throws {
        if isCancelled {
            throw DialogAPIError.requestCancellation
        }
    }
}

