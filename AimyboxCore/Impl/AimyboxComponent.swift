//
//  AimyboxComponent.swift
//  Aimybox
//
//  Created by Vladyslav Popovych on 08.12.2019.
//

import Foundation

/**
 Base class that provides async behavior.
 */
public class AimyboxComponent {
    /**
     Background, serial queue for component operations.
     */
    public var operationQueue: OperationQueue
    /**
     Desigated initializer that creates op queue for component.
     
     - Note: If you ovveride `init()` in sub-class, you must call super.init().
     */
    internal init() {
        let queue = OperationQueue()
        queue.name = "com.justai.aimybox-\("\(type(of: self))".lowercased())-thread"
        queue.maxConcurrentOperationCount = 1
        operationQueue = queue
    }
}
