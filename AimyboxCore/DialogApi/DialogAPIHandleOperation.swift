//
//  DialogAPIHandleOperation.swift
//  Aimybox
//
//  Created by Vladislav Popovich on 13.12.2019.
//

import Foundation

class DialogAPIHandleOperation<TDialogAPI: DialogAPI>: Operation {
    /**
     */
    private let defaultMaxPollAttempts = 10
    /**
     */
    private let defaultRequestTimeout = 1.0
    /**
     */
    private var response: TDialogAPI.TResponse?
    /**
    */
    private var dialogAPI: TDialogAPI
    /**
    */
    public private(set) var result: TDialogAPI.TResponse?
    
    public init(response: TDialogAPI.TResponse, dialogAPI: TDialogAPI, aimybox: Aimybox) {
        self.response = response
        self.dialogAPI = dialogAPI
    }
    
    override public func main() {
        
    }
}
