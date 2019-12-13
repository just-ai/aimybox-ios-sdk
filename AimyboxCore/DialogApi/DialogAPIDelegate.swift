//
//  DialogAPIDelegate.swift
//  Aimybox
//
//  Created by Vladislav Popovich on 13.12.2019.
//

import Foundation

public protocol DialogAPIDelegate: class {
    /**
     */
    func dialogAPI(sent request: Request)
    /**
     */
    func dialogAPI(cancelled request: Request)
    /**
     */
    func dialogAPI(response received: Response)
}
