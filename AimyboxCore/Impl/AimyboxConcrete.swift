//
//  AimyboxConcrete.swift
//  Aimybox
//
//  Created by Vladislav Popovich on 09.12.2019.
//

import Foundation


/**
 Concrete object that conforms to a `Aimybox` protocol.
 
 For detailed info about methods available, refer to `Aimybox` protocol.
 */
internal class AimyboxConcrete<TDialogAPI, TConfig>: Aimybox where TConfig: AimyboxConfig {
    
    public weak var delegate: AimyboxDelegate?
    
    public private(set) var state: AimyboxState
    
    public private(set) var config: TConfig
    
    public init(with config: TConfig) {
        self.state = .standby
        self.config = config
        self.config.speechToText.notify = onSpeechToText
        self.config.textToSpeech.notify = onTextToSpeech
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
    /// TMP
    public func synthesize(_ array: [AimyboxSpeech]) {
        state = .speaking
        
        config.speechToText.cancelRecognition()
        config.textToSpeech.synthesize(contentsOf: array)
    }
    
    // MARK: - State independent methods

    public func standby() {
        switch state {
        case .listening:
            config.speechToText.cancelRecognition()
        case .speaking:
            config.textToSpeech.stop()
        default:
            break
        }
        
        state = .standby
    }
}

extension AimyboxConcrete {
    private func onSpeechToText(_ result: SpeechToTextResult) {
        switch result {
        case .success(let event):
            event.forward(to: delegate, by: config.speechToText)
        case .failure(let error):
            error.forward(to: delegate, by: config.speechToText)
        }
    }

    private func onTextToSpeech(_ result: TextToSpeechResult) {
        switch result {
        case .success(let event):
            event.forward(to: delegate, by: config.textToSpeech)
        case .failure(let error):
            error.forward(to: delegate, by: config.textToSpeech)
        }
    }
}

