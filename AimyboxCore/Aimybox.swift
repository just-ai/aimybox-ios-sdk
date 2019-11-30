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
    private func onSpeechToText(_ result: SpeechToTextResult) {
        switch result {
        case .success(let event):
            event.forward(to: delegate, by: config.speechToText)
        case .failure(let error):
            error.forward(to: delegate, by: config.speechToText)
        }
    }
}
