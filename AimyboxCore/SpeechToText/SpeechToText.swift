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
public protocol SpeechToText: AimyboxComponent {
    /**
     Start recognition.
     */
    func startRecognition()
    /**
     Stop audio recording, but await for final result.
     */
    func stopRecognition()
    /**
     Cancel recognition entirely and abandon all results.
     */
    func cancelRecognition()
    /**
     Used to notify *Aimybox* state machine about events.
     */
    var notify: (SpeechToTextCallback)? { get set }
}

public typealias SpeechToTextCallback = (SpeechToTextResult) -> Void
