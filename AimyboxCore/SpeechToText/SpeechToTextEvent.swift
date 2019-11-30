//
//  SpeechToTextEvent.swift
//  Aimybox
//
//  Created by Vladyslav Popovych on 30.11.2019.
//

import Foundation

public enum SpeechToTextEvent {
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

public extension SpeechToTextEvent {
    func forward(to delegate: SpeechToTextDelegate?, by stt: SpeechToText?) {
        guard let delegate = delegate, let stt = stt else {
            return
        }
        
        switch self {
        case .recognitionPermissionsGranted:
            delegate.sttRecognitionPermissionsGranted(stt)
        case .recognitionStarted:
            delegate.sttRecognitionStarted(stt)
        case .recognitionPartialResult(let result):
            delegate.stt(stt, recognitionPartial: result)
        case .recognitionResult(let result):
            delegate.stt(stt, recognitionFinal: result)
        case .emptyRecognitionResult:
            delegate.sttEmptyRecognitionResult(stt)
        case .recognitionCancelled:
            delegate.sttRecognitionCancelled(stt)
        case .speechStartDetected:
            delegate.sttSpeechStartDetected(stt)
        case .speechEndDetected:
            delegate.sttSpeechEndDetected(stt)
        case .soundVolumeRmsChanged(let value):
            delegate.stt(stt, soundVolumeRmsChanged: value)
        }
    }
}
