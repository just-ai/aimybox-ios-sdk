//
//  Utils.swift
//  AimyboxCore
//
//  Created by Vladyslav Popovych on 30.11.2019.
//  Copyright © 2019 Just Ai. All rights reserved.
//

import Foundation

public protocol AimyboxDelegate: class {
    /**
     Called before new state is set. Optional.
     */
    func aimybox(_ aimybox: Aimybox, willMoveFrom oldState: Aimybox.State, to newState: Aimybox.State)
    /**
     Called when user grants permission to use microphone and recognition API's. Optional.
     */
    func aimybox(_ aimybox: Aimybox, recognitionPermissionsGranted: Aimybox.SpeechToTextEvent)
    /**
    Called when recognition starts. Optional.
    */
    func aimybox(_ aimybox: Aimybox, recognitionStarted: Aimybox.SpeechToTextEvent)
    /**
    Called when SpeechToText recognised the intermediate text. Optional.
    */
    func aimybox(_ aimybox: Aimybox, recognitionPartialResult: Aimybox.SpeechToTextEvent)
    /**
    Called when SpeechToText recognised the final text. Optional.
    */
    func aimybox(_ aimybox: Aimybox, recognitionResult: Aimybox.SpeechToTextEvent)
    /**
    Called when SpeechToText recognised the final text and it's empty. Optional.
    */
    func aimybox(_ aimybox: Aimybox, emptyRecognitionResult: Aimybox.SpeechToTextEvent)
    /**
    Called when recognition was canceled. Optional.
    */
    func aimybox(_ aimybox: Aimybox, recognitionCancelled: Aimybox.SpeechToTextEvent)
    /**
    Called when recognition detected user speech start. Optional.
    */
    func aimybox(_ aimybox: Aimybox, speechStartDetected: Aimybox.SpeechToTextEvent)
    /**
    Called when recognition detected user speech end. Optional.
    */
    func aimybox(_ aimybox: Aimybox, speechEndDetected: Aimybox.SpeechToTextEvent)
    /**
    Called when sound volume of microphone input changes. Optional.
    */
    func aimybox(_ aimybox: Aimybox, soundVolumeRmsChanged: Aimybox.SpeechToTextEvent)
}

/**
 All methods listed here are optional for delegates to implement.
 */
public extension AimyboxDelegate {
    func aimybox(_ aimybox: Aimybox, willMoveFrom oldState: Aimybox.State, to newState: Aimybox.State) {}
    func aimybox(_ aimybox: Aimybox, recognitionPermissionsGranted: Aimybox.SpeechToTextEvent) {}
    func aimybox(_ aimybox: Aimybox, recognitionStarted: Aimybox.SpeechToTextEvent) {}
    func aimybox(_ aimybox: Aimybox, recognitionPartialResult: Aimybox.SpeechToTextEvent) {}
    func aimybox(_ aimybox: Aimybox, recognitionResult: Aimybox.SpeechToTextEvent) {}
    func aimybox(_ aimybox: Aimybox, emptyRecognitionResult: Aimybox.SpeechToTextEvent) {}
    func aimybox(_ aimybox: Aimybox, recognitionCancelled: Aimybox.SpeechToTextEvent) {}
    func aimybox(_ aimybox: Aimybox, speechStartDetected: Aimybox.SpeechToTextEvent) {}
    func aimybox(_ aimybox: Aimybox, speechEndDetected: Aimybox.SpeechToTextEvent) {}
    func aimybox(_ aimybox: Aimybox, soundVolumeRmsChanged: Aimybox.SpeechToTextEvent) {}
}
