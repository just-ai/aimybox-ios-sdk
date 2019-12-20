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
public class DispatchDebouncer {
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

/**
 Decoding extensions.
 */
extension KeyedDecodingContainer {
    public func decode<T: Decodable>(_ key: Key, as type: T.Type = T.self) throws -> T {
        return try self.decode(T.self, forKey: key)
    }

    public func decodeIfPresent<T: Decodable>(_ key: KeyedDecodingContainer.Key) throws -> T? {
        return try decodeIfPresent(T.self, forKey: key)
    }
}

/**
 Functional style optional chaining.
 */
extension Optional {
    
    public func or(_ defaultUnwrapped: Wrapped) -> Wrapped {
        switch self {
        case .none:              return defaultUnwrapped
        case .some(let wrapped): return wrapped
        }
    }
    
}

