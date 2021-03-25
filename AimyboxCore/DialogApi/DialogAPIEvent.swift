//
//  DialogAPIEvent.swift
//  Aimybox
//
//  Created by Vladislav Popovich on 13.12.2019.
//

import Foundation

public
enum DialogAPIEvent {
    /**
    Happens when `Aimybox` sends request.
    */
    case requestSent(Request)
    /**
    Happens when `DialogAPI` received response.
    */
    case responseReceived(Response)

}

public
extension DialogAPIEvent {

    func forward(to delegate: DialogAPIDelegate?) {
        guard let delegate = delegate else {
            return
        }

        switch self {
        case .requestSent(let request):
            delegate.dialogAPI(sent: request)
        case .responseReceived(let response):
            delegate.dialogAPI(received: response)
        }
    }

}
