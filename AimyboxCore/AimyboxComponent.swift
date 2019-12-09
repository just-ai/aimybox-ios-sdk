//
//  AimyboxComponent.swift
//  Aimybox
//
//  Created by Vladyslav Popovych on 08.12.2019.
//

import Foundation

public class AimyboxComponent {
    
    public var operationQueue: OperationQueue
    
    public init(name: String) {
        let queue = OperationQueue()
        queue.name = "com.justai.aimybox-\("\(type(of: self))".lowercased())-thread"
        queue.maxConcurrentOperationCount = 1
        operationQueue = queue
    }
}
