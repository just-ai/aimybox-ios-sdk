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
public
class DispatchDebouncer {

    private
    var timer: Timer?

    private
    var fired: Bool = false

    public
    init() {
    }

    func debounce(delay seconds: TimeInterval, _ block: @escaping () -> Void ) {
        DispatchQueue.main.async { [weak self] in
            self?.timer?.invalidate()
            self?.timer = Timer.scheduledTimer(withTimeInterval: seconds, repeats: false) { _ in
                block()
            }
        }
    }

}

public
extension URL {

    init(static string: StaticString) {
        guard let result = URL(string: String(describing: string)) else {
            preconditionFailure("Can not represent a URL")
        }
        self = result
    }

}

/**
Decoding extensions.
*/
public
extension KeyedDecodingContainer {

    func decode<T: Decodable>(_ key: Key, as type: T.Type = T.self) throws -> T {
        try self.decode(T.self, forKey: key)
    }

    func decodeIfPresent<T: Decodable>(_ key: KeyedDecodingContainer.Key) throws -> T? {
        try decodeIfPresent(T.self, forKey: key)
    }

}

/**
Functional style optional chaining.
*/
public
extension Optional {

    func or(_ defaultUnwrapped: Wrapped) -> Wrapped {
        switch self {
        case .none:
            return defaultUnwrapped
        case .some(let wrapped):
            return wrapped
        }
    }

}
