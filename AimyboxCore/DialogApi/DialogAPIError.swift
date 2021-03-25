//
//  DialogAPIError.swift
//  Aimybox
//
//  Created by Vladislav Popovich on 13.12.2019.
//

import Foundation

public enum DialogAPIError: Error {
    /**
    Happens when request timeouts.
    */
    case requestTimeout(Request)
    /**
    Happens when request cancelled.
    */
    case requestCancellation(Request)
    /**
    Happens when `Aimybox` forced to `DialogAPI` to cancel while response being processed.
    */
    case processingCancellation
    /**
    Happens when `DialogAPI` catches errors at request creation etc.
    */
    case clientSide(Error)
}

public extension DialogAPIError {
    func forward(to delegate: DialogAPIDelegate?) {
        guard let delegate = delegate else {
            return
        }

        switch self {
        case .requestTimeout(let request):
            delegate.dialogAPI(timeout: request)
        case .requestCancellation(let request):
            delegate.dialogAPI(cancelled: request)
        case .clientSide(let error):
            delegate.dialogAPI(client: error)
        case .processingCancellation:
            delegate.dialogAPIProcessingCancellation()
        }
    }
}
