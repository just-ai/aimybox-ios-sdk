//
//  Aimybox.swift
//  AimyboxCore
//
//  Created by Vladyslav Popovych on 23.11.2019.
//  Copyright © 2019 Just Ai. All rights reserved.
//

import Foundation

public class Aimybox {
    
    public weak var delegate: AimyboxDelegate?
    
    public private(set) var state: State
    
    public private(set) var config: Config
    
    public init(with config: Config) {
        self.state = .standby
        self.config = config
        self.config.speechToText.notify = onSpeechToText
    }

    // MARK: - Text to speech lifecycle
    public func startRecognition() {
        state = .listening
        
        config.speechToText.cancelRecognition()
        config.speechToText.startRecognition()
    }
    
    public func stopRecognition() {
        guard case .listening = state else {
            return
        }
        config.speechToText.stopRecognition()
    }
    
    public func cancelRecognition() {
        standby()
    }
    
    // MARK: - State independent methods
    /**
     Force transition to standby mode.
     */
    public func standby() {
        switch state {
        case .listening:
            config.speechToText.cancelRecognition()
        default:
            break
        }
        
        state = .standby
    }
}

extension Aimybox {
    private func onSpeechToText(_ result: Aimybox.SpeechToTextResult) {
        switch result {
        case .success(let event):
            onSpeechToTextSuccess(event)
        case .faillure(let error):
            onSpeechToTextFaillure(error)
        }
    }
    
    private func onSpeechToTextSuccess(_ event: SpeechToTextEvent) {
        switch event {
        case .recognitionPermissionsGranted:
            delegate?.aimybox(self, recognitionPermissionsGranted: event)
        case .recognitionStarted:
            delegate?.aimybox(self, recognitionStarted: event)
        case .recognitionPartialResult:
            delegate?.aimybox(self, recognitionPartialResult: event)
        case .recognitionResult:
            delegate?.aimybox(self, recognitionResult: event)
        case .emptyRecognitionResult:
            delegate?.aimybox(self, emptyRecognitionResult: event)
        case .recognitionCancelled:
            delegate?.aimybox(self, recognitionCancelled: event)
        case .speechStartDetected:
            delegate?.aimybox(self, speechStartDetected: event)
        case .speechEndDetected:
            delegate?.aimybox(self, speechEndDetected: event)
        case .soundVolumeRmsChanged:
            delegate?.aimybox(self, soundVolumeRmsChanged: event)
        }
    }
    
    private func onSpeechToTextFaillure(_ error: SpeechToTextError) {
        switch error {
        case .microphonePermissionReject:
            break
        case .speechRecognitionPermissionReject:
            break
        case .microphoneUnreachable:
            break
        case .speechRecognitionUnavailable:
            break
        }
    }
}
