//
//  AimyboxSpeech.swift
//  Aimybox
//
//  Created by Vladyslav Popovych on 01.12.2019.
//

import Foundation

/**
 Base protocol for any speeches.
 */
public protocol AimyboxSpeech: class {
    
    func isValid() -> Bool
}

/**
 Text to be spoken.
 */
public class TextSpeech: AimyboxSpeech {

    public let text: String
    
    public init(text: String) {
        self.text = text
    }
    
    public func isValid() -> Bool {
        return !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
