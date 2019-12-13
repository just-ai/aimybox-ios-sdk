//
//  DialogAPIEvent.swift
//  Aimybox
//
//  Created by Vladislav Popovich on 13.12.2019.
//

import Foundation


public enum DialogAPIEvent {
    /**
     */
    case requestSent(Request)
    /**
     */
    case requestCancelled(Request)
    /**
     */
    case responseReceived(Response)
}

public extension DialogAPIEvent {
    func forward<TDialogAPI: DialogAPI>(to delegate: DialogAPIDelegate?, by dialogAPI: TDialogAPI?) {
        guard let delegate = delegate, let _ = dialogAPI else {
            return
        }

        switch self {
        case .requestSent(let request):
            delegate.dialogAPI(sent: request)
        case .requestCancelled(let request):
            delegate.dialogAPI(cancelled: request)
        case .responseReceived(let response):
            delegate.dialogAPI(response: response)
        }
    }
}

