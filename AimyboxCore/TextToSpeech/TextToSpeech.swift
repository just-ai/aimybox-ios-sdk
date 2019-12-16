//
//  TextToSpeech.swift
//  Aimybox
//
//  Created by Vladyslav Popovych on 01.12.2019.
//

import Foundation

/**
 Class conforming to this protocol is able to synthesize a speech from the text in real time.
 */
public protocol TextToSpeech: class {
    /**
     Synthesizes in FIFO order.
     */
    func synthesize(contentsOf speeches: [AimyboxSpeech], completion: TextToSpeechCallback)
    /**
     Stops speech synthesis.
     */
    func stop()
    /**
     Used to notify *Aimybox* state machine about events.
     */
    var notify: (TextToSpeechCallback)? { get set }
}

public typealias TextToSpeechCallback = (TextToSpeechResult)->()
