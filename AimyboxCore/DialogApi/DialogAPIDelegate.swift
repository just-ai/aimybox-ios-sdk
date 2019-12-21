//
//  DialogAPIDelegate.swift
//  Aimybox
//
//  Created by Vladislav Popovich on 13.12.2019.
//

import Foundation

public protocol DialogAPIDelegate: class {
    
    // MARK: - Lifecycle
    /**
     Happens when `Aimybox` sends request.
     */
    func dialogAPI(sent request: Request)
    /**
     Happens when `DialogAPI` received response.
     */
    func dialogAPI(received response: Response)
    
    // MARK:- Errors
    /**
      Happens when request timeouts.
     */
    func dialogAPI(timeout request: Request)
    /**
     Happens when `Aimybox` cancels `DialogAPI` request.
     */
    func dialogAPI(cancelled request: Request)
    /**
     Happens when `DialogAPI` catches errors at request creation etc.
    */
    func dialogAPI(client error: Error)
    /**
     Happens when `Aimybox` forced to `DialogAPI` to cancel while response being processed.
     */
    func dialogAPIProcessingCancellation()
}

/**
 All methods listed here are optional for delegates to implement.
 */
public extension DialogAPIDelegate {
    func dialogAPI(sent request: Request) {}
    func dialogAPI(cancelled request: Request) {}
    func dialogAPI(received response: Response) {}
    func dialogAPI(timeout request: Request) {}
    func dialogAPI(client error: Error) {}
    func dialogAPIProcessingCancellation() {}
}

