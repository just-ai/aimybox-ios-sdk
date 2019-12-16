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
        cancelRecognition()

        state = .listening

        config.speechToText.startRecognition()
    }
    
    public func stopRecognition() {
        guard case .listening = state else {
            return
        }
        config.speechToText.stopRecognition()
    }
    
    public func cancelRecognition() {
        guard case .listening = state else {
            return
        }
        config.speechToText.cancelRecognition()
    }
    
    // MARK: - DialogAPI lifecycle

    func sendRequest(query: String) {
        stopSpeaking()
        
        state = .processing
        
        cancelPendingRequest()
        config.dialogAPI.send(query: query, sender: self)
    }
    
    func cancelPendingRequest() {
        guard state == .processing else {
            return
        }
        
        config.dialogAPI.cancelRunningOperation()
    }
    
    // MARK: - TextToSpeech
    public func speak(speech: AimyboxSpeech) {
        speak(speech: speech, next: .standby)
    }
    
    public func speak(speech: AimyboxSpeech, next action: AimyboxNextAction) {
        speak(speech: [speech], next: action)
    }
    
    public func speak(speech: [AimyboxSpeech], next action: AimyboxNextAction) {
        guard state != .speaking else {
            return
        }
        
        state = .speaking
        config.textToSpeech.synthesize(contentsOf: speech) { result in
            //
        }
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
    
    func stopSpeaking() {
        config.textToSpeech.stop()
    }
    
    // MARK: - Init for testing.
    #if TESTING
    public init(config: TConfig) {
        self.state = .standby
        self.config = config

        if let _injectedBlock = config.speechToText.notify {
            config.speechToText.notify = { [weak self] in
                self?.onSpeechToText($0)
                _injectedBlock($0)
            }
        }
        if let _injectedBlock = config.textToSpeech.notify {
            config.textToSpeech.notify = { [weak self] in
                self?.onTextToSpeech($0)
                _injectedBlock($0)
            }
        }
        
        self.config = config
    }
    #endif
}

extension AimyboxConcrete {
    private func onSpeechToText(_ result: SpeechToTextResult) {
        switch result {
        case .success(let event):
            handle(event)
            event.forward(to: delegate, by: config.speechToText)

        case .failure(let error):
            handle(error)
            error.forward(to: delegate, by: config.speechToText)

        }
    }
    
    private func handle(_ event: SpeechToTextEvent) {
        switch event {
        case .recognitionResult(let query):
            sendRequest(query: query)

        case .emptyRecognitionResult:
            standby()
        
        case .recognitionCancelled:
            standby()
            
        default:
            break
        }
    }
    
    private func handle(_ error: SpeechToTextError) {
        standby()
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
