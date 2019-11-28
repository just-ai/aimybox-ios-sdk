//
//  Utils.swift
//  Aimybox
//
//  Created by Vladyslav Popovych on 01.12.2019.
//

import Foundation

/**
 Handy debouncer.
 */
class DispatchDebouncer {
    private var timer: Timer?

    public init() {
    }
    
    public func debounce(delay seconds: TimeInterval, _ block: @escaping () -> Void ) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: seconds, repeats: false) { _ in
            block()
        }
    }
}
