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
    
    // MARK: - Lifecycle
    /**
     Called when user grants permission to use microphone and recognition API's. Optional.
     */
    func sttRecognitionPermissionsGranted(_ stt: SpeechToText)
    /**
    Called when recognition starts. Optional.
    */
    func sttRecognitionStarted(_ stt: SpeechToText)
    /**
    Called when SpeechToText recognised the intermediate text. Optional.
    */
    func stt(_ stt: SpeechToText, recognitionPartial result: String)
    /**
    Called when SpeechToText recognised the final text. Optional.
    */
    func stt(_ stt: SpeechToText, recognitionFinal result: String)
    /**
    Called when SpeechToText recognised the final text and it's empty. Optional.
    */
    func sttEmptyRecognitionResult(_ stt: SpeechToText)
    /**
    Called when recognition was canceled. Optional.
    */
    func sttRecognitionCancelled(_ stt: SpeechToText)
    /**
    Called when recognition detected user speech start. Optional.
    */
    func sttSpeechStartDetected(_ stt: SpeechToText)
    /**
    Called when recognition detected user speech end. Optional.
    */
    func sttSpeechEndDetected(_ stt: SpeechToText)
    /**
    Called when sound volume of microphone input changes. Optional.
    */
    func stt(_ stt: SpeechToText, soundVolumeRmsChanged: Int)
    
    // MARK:- Errors
    /**
     User didn't grant a permission to use a device microphone.
     */
    func sttMicrophonePermissionReject(_ stt: SpeechToText)
    /**
     User didn't grant a permission to use, a native, Speech Frameworks recognition.
     */
    func sttSpeechRecognitionPermissionReject(_ stt: SpeechToText)
    /**
     Microphone is unreachable for recording.
     */
    func sttMicrophoneUnreachable(_ stt: SpeechToText)
    /**
     Speech recognition is unavailable.
     */
    func sttSpeechRecognitionUnavailable(_ stt: SpeechToText)
}

/**
 All methods listed here are optional for delegates to implement.
*/
public extension SpeechToTextDelegate {
    func sttRecognitionPermissionsGranted(_ stt: SpeechToText) {}
    func sttRecognitionStarted(_ stt: SpeechToText) {}
    func stt(_ stt: SpeechToText, recognitionPartial result: String) {}
    func stt(_ stt: SpeechToText, recognitionFinal result: String) {}
    func sttEmptyRecognitionResult(_ stt: SpeechToText) {}
    func sttRecognitionCancelled(_ stt: SpeechToText) {}
    func sttSpeechStartDetected(_ stt: SpeechToText) {}
    func sttSpeechEndDetected(_ stt: SpeechToText) {}
    func stt(_ stt: SpeechToText, soundVolumeRmsChanged: Int) {}
    func sttMicrophonePermissionReject(_ stt: SpeechToText) {}
    func sttSpeechRecognitionPermissionReject(_ stt: SpeechToText) {}
    func sttMicrophoneUnreachable(_ stt: SpeechToText) {}
    func sttSpeechRecognitionUnavailable(_ stt: SpeechToText) {}
}
