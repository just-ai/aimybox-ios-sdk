//
//  Aimybox.swift
//  AimyboxCore
//
//  Created by Vladyslav Popovych on 23.11.2019.
//  Copyright © 2019 Just Ai. All rights reserved.
//

import Foundation

public protocol Aimybox {
    
    func startRecognition()
    
    func stopRecognition()
    
    func cancelRecognition()
    
    func standby()
    
    var delegate: AimyboxDelegate? { get set }
}

public class AimyboxBuilder {
    
    public static func build<T, U: AnyAimyboxConfig<T>>(_ config: U) -> Aimybox {
        return AimyboxConcrete<T, U>(with: config) as Aimybox
    }
}

private class AimyboxConcrete<TDialogAPI, TConfig>: Aimybox where TConfig: AnyAimyboxConfig<TDialogAPI> {
    
    public weak var delegate: AimyboxDelegate?
    
    public private(set) var state: AimyboxState
    
    public private(set) var config: TConfig
    
    public init(with config: TConfig) {
        self.state = .standby
        self.config = config
//        self.config.speechToText.notify = onSpeechToText
//        self.config.textToSpeech.notify = onTextToSpeech
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
    /**
     Force transition to standby mode.
     */
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

//extension Aimybox {
//    private func onSpeechToText(_ result: SpeechToTextResult) {
//        switch result {
//        case .success(let event):
//            event.forward(to: delegate, by: config.speechToText)
//        case .failure(let error):
//            error.forward(to: delegate, by: config.speechToText)
//        }
//    }
//    
//    private func onTextToSpeech(_ result: TextToSpeechResult) {
//        switch result {
//        case .success(let event):
//            event.forward(to: delegate, by: config.textToSpeech)
//        case .failure(let error):
//            error.forward(to: delegate, by: config.textToSpeech)
//        }
//    }
//}
