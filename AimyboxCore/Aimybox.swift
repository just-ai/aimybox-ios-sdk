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
    }

    // MARK: - Text to speech lifecycle
    public func startRecognition() {
        state = .listening
        
        config.speechToText.cancelRecognition()
        config.speechToText.startRecognition { [weak self] result in
            guard let _self = self else {
                return
            }
//            _self.delegate?.aimybox(_self, didStartRecognition: result)
        }
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
    private func forward(_ result: Aimybox.SpeechToTextResult) {
        switch result {
        case .
        }
    }
}
