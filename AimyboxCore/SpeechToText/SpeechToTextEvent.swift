//
//  SpeechToTextEvent.swift
//  Aimybox
//
//  Created by Vladyslav Popovych on 30.11.2019.
//

import Foundation

public extension Aimybox {
    
    enum SpeechToTextEvent {
        /**
         Happens when user granted permission to microphone and recognizer.
         */
        case recognitionPermissionsGranted
        /**
         Happens when SpeechToText actually starts the recognition.
         */
        case recognitionStarted
        /**
         Happens when SpeechToText has recognised the intermediate text from the chunk of speech.
         */
        case recognitionPartialResult(String)
        /**
         Happens when SpeechToText has recognised the final text from the speech.
         */
        case recognitionResult(String)
        /**
         Happens when SpeechToText cannot recognise anything.
         */
        case emptyRecognitionResult
        /**
         Happens when user cancels the recognition.
         */
        case recognitionCancelled
        /**
         Happens when user starts to talk.
         */
        case speechStartDetected
        /**
         Happens when user stops talking.
         */
        case speechEndDetected
        /**
         Happens when sound volume of microphone input changes.
         */
        case soundVolumeRmsChanged(Int)
    }
}
