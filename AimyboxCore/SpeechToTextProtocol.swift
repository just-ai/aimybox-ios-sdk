//
//  SpechToTextProtocol.swift
//  AimyboxCore
//
//  Created by Vladyslav Popovych on 30.11.2019.
//  Copyright © 2019 Just Ai. All rights reserved.
//

import Foundation

/**
 Class conforming to this protocol is able to recognise a text from the user's speech in real time.
 */
public protocol SpeechToTextProtocol: class {
    /**
     Start recognition.
     */
    func startRecognition(_ completion: @escaping (Aimybox.SpeechToTextResult)->())
    /**
     Stop audio recording, but await for final result.
     */
    func stopRecognition()
    /**
     Cancel recognition entirely and abandon all results.
     */
    func cancelRecognition()
}
