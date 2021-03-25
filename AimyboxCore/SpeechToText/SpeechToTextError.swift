//
//  SpeechToTextError.swift
//  AimyboxCore
//
//  Created by Vladyslav Popovych on 30.11.2019.
//  Copyright © 2019 Just Ai. All rights reserved.
//

import Foundation

/**
Speech to text possible errors.
*/
public
enum SpeechToTextError: Error {
    /**
    User didn't grant a permission to use a device microphone.
     
    Check info in **NSMicrophoneUsageDescription**.
    */
    case microphonePermissionReject
    /**
    User didn't grant a permission to use, a native, Speech Frameworks recognition.
     
    Check info in **NSSpeechRecognitionUsageDescription**
    or use another STT component.
    */
    case speechRecognitionPermissionReject
    /**
    Microphone is unreachable for recording.
    */
    case microphoneUnreachable
    /**
    Speech recognition is unavailable.
    */
    case speechRecognitionUnavailable

}

public
extension SpeechToTextError {
    func forward(to delegate: SpeechToTextDelegate?, by stt: SpeechToText?) {
        guard let delegate = delegate, let stt = stt else {
            return
        }

        switch self {
        case .microphonePermissionReject:
            delegate.sttMicrophonePermissionReject(stt)
        case .speechRecognitionPermissionReject:
            delegate.sttSpeechRecognitionPermissionReject(stt)
        case .microphoneUnreachable:
            delegate.sttMicrophoneUnreachable(stt)
        case .speechRecognitionUnavailable:
            delegate.sttSpeechRecognitionUnavailable(stt)
        }
    }
}
