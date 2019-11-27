//
//  SpeechToTextError.swift
//  AimyboxCore
//
//  Created by Vladyslav Popovych on 30.11.2019.
//  Copyright © 2019 Just Ai. All rights reserved.
//

import Foundation

public extension Aimybox {
    /**
     Speech to text possible errors.
     */
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
}
