//
//  SpeechToTextDelegate.swift
//  Aimybox
//
//  Created by Vladyslav Popovych on 01.12.2019.
//

import Foundation

/**
 Speech to text delegate is notified to all events that relate to speech recognition process.
 */
public protocol SpeechToTextDelegate: class {
    /**
     Called when user grants permission to use microphone and recognition API's. Optional.
     */
    func sttRecognitionPermissionsGranted(_ stt: SpeechToTextProtocol)
    /**
    Called when recognition starts. Optional.
    */
    func sttRecognitionStarted(_ stt: SpeechToTextProtocol)
    /**
    Called when SpeechToText recognised the intermediate text. Optional.
    */
    func stt(_ stt: SpeechToTextProtocol, recognitionPartial result: String)
    /**
    Called when SpeechToText recognised the final text. Optional.
    */
    func stt(_ stt: SpeechToTextProtocol, recognitionFinal result: String)
    /**
    Called when SpeechToText recognised the final text and it's empty. Optional.
    */
    func sttEmptyRecognitionResult(_ stt: SpeechToTextProtocol)
    /**
    Called when recognition was canceled. Optional.
    */
    func sttRecognitionCancelled(_ stt: SpeechToTextProtocol)
    /**
    Called when recognition detected user speech start. Optional.
    */
    func sttSpeechStartDetected(_ stt: SpeechToTextProtocol)
    /**
    Called when recognition detected user speech end. Optional.
    */
    func sttSpeechEndDetected(_ stt: SpeechToTextProtocol)
    /**
    Called when sound volume of microphone input changes. Optional.
    */
    func stt(_ stt: SpeechToTextProtocol, soundVolumeRmsChanged: Int)
}

/**
 All methods listed here are optional for delegates to implement.
*/
public extension SpeechToTextDelegate {
    func sttRecognitionPermissionsGranted(_ stt: SpeechToTextProtocol) {}
    func sttRecognitionStarted(_ stt: SpeechToTextProtocol) {}
    func stt(_ stt: SpeechToTextProtocol, recognitionPartial result: String) {}
    func stt(_ stt: SpeechToTextProtocol, recognitionFinal result: String) {}
    func sttEmptyRecognitionResult(_ stt: SpeechToTextProtocol) {}
    func sttRecognitionCancelled(_ stt: SpeechToTextProtocol) {}
    func sttSpeechStartDetected(_ stt: SpeechToTextProtocol) {}
    func sttSpeechEndDetected(_ stt: SpeechToTextProtocol) {}
    func stt(_ stt: SpeechToTextProtocol, soundVolumeRmsChanged: Int) {}
}
