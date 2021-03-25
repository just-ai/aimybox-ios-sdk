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
    private var defaultMaxPollAttempts = 10
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
        self.defaultMaxPollAttempts = dialogAPI.timeoutPollAttempts
    }

    override public func main() {

        let request = dialogAPI.customSkills.reduce(into: dialogAPI.createRequest(query: query)) { _request, _skill in
            _request = _skill.onRequest(_request)
        }

        do {

            let _dialogAPI = dialogAPI

            _dialogAPI.notify?(.success(.requestSent(request)))

            result = try perform {
                try _dialogAPI.send(request: request)
            }

        } catch DialogAPIError.Internal.requestTimeout {
            dialogAPI.notify?(.failure(.requestTimeout(request)))
        } catch DialogAPIError.Internal.requestCancellation {
            dialogAPI.notify?(.failure(.requestCancellation(request)))
        } catch let error {
            dialogAPI.notify?(.failure(.clientSide(error)))
        }
    }

    private func perform<T>(_ block: @escaping () throws -> T) throws -> T {

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

        pollLoop: while pollAttempt < defaultMaxPollAttempts {

            switch timeoutSemaphore.wait(timeout: .now() + defaultRequestTimeout) {
            case .success:
                try throwIfCanceled()

                break pollLoop // Stop polling and look for response we got

            case .timedOut:
                try throwIfCanceled()
            }

            pollAttempt += 1
        }

        // Convert response to one of known event type
        switch response {
        case .success(let result):
            return result

        case .failure(let error):
            throw error

        case .none:
            throw DialogAPIError.Internal.requestTimeout
        }
    }

    private func throwIfCanceled() throws {
        if isCancelled {
            throw DialogAPIError.Internal.requestCancellation
        }
    }
}

/**
 Domain of internal errors.
 */
fileprivate extension DialogAPIError {
    enum Internal: Error {
        case requestTimeout
        case requestCancellation
        case clientSide
    }
}
