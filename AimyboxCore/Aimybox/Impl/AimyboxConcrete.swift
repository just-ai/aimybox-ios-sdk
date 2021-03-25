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
class AimyboxConcrete<TDialogAPI, TConfig>: Aimybox where TConfig: AimyboxConfig {

    public weak var delegate: AimyboxDelegate?

    public private(set) var state: AimyboxState {
        willSet {
            delegate?.aimybox(self, willMoveFrom: state, to: newValue)
        }
    }

    public private(set) var nextAction: AimyboxNextAction

    public private(set) var config: TConfig

    public init(with config: TConfig) {
        self.state = .standby
        self.nextAction = .nothing
        self.config = config
        self.config.speechToText.notify = { [weak self] event in
            self?.onSpeechToText(event)
        }
        self.config.textToSpeech.notify = { [weak self] event in
            self?.onTextToSpeech(event)
        }
        self.config.dialogAPI.notify = { [weak self] event in
            self?.onDialogAPI(event)
        }
    }

    // MARK: - Text to speech lifecycle
    public func startRecognition() {
        stopSpeaking()
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

    public func sendRequest(query: String) {
        cancelRecognition()
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
        nextAction = action
        config.textToSpeech.synthesize(contentsOf: speech)
    }

    public func cancelSynthesis() {
        config.textToSpeech.cancelSynthesis()
    }

    // MARK: - State independent methods

    public func standby() {
        let oldState = state
        state = .standby

        switch oldState {
        case .listening:
            config.speechToText.cancelRecognition()
        case .processing:
            config.dialogAPI.cancelRequest()
        case .speaking:
            config.textToSpeech.stop()
        default:
            break
        }
    }

    func stopSpeaking() {
        guard case .speaking = state else {
            return
        }

        config.textToSpeech.stop()
    }

    // MARK: - Init for testing.
    #if TESTING
    public init(config: TConfig) {
        self.state = .standby
        self.nextAction = .nothing
        self.config = config

        if let injectedBlock = config.speechToText.notify {
            config.speechToText.notify = { [weak self] in
                self?.onSpeechToText($0)
                injectedBlock($0)
            }
        }
        if let injectedBlock = config.textToSpeech.notify {
            config.textToSpeech.notify = { [weak self] in
                self?.onTextToSpeech($0)
                injectedBlock($0)
            }
        }
        if let injectedBlock = config.dialogAPI.notify {
            config.dialogAPI.notify = { [weak self] in
                self?.onDialogAPI($0)
                injectedBlock($0)
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

        case .emptyRecognitionResult, .recognitionCancelled:
            if state == .processing {
                return
            }

            standby()

        default:
            break
        }
    }

    private func handle(_ error: SpeechToTextError) {
        guard case .listening = state else {
            return
        }

        standby()
    }

    private func onTextToSpeech(_ result: TextToSpeechResult) {
        switch result {
        case .success(let event):
            handle(event)
            event.forward(to: delegate, by: config.textToSpeech)
        case .failure(let error):
            handle(error)
            error.forward(to: delegate, by: config.textToSpeech)
        }
    }

    private func handle(_ event: TextToSpeechEvent) {
        switch event {
        case .speechSequenceCompleted:
            switch nextAction {
            case .nothing:
                break
            case .recognition:
                startRecognition()
            case .standby:
                if state != .processing {
                    standby()
                }
            }
        case .speechSequenceStarted:
             state = .speaking
        default:
            break
        }
    }

    private func handle(_ error: TextToSpeechError) {
        switch error {
        case .emptySpeech:
            break
        default:
            switch error {
            case .speechSequenceCancelled:
                break
            default:
                standby()
            }
        }
    }

    private func onDialogAPI(_ result: DialogAPIResult) {
        switch result {
        case .success(let event):
            handle(event)
            event.forward(to: delegate)

        case .failure(let error):
            error.forward(to: delegate)
            handle(error)

        }
    }

    private func handle(_ event: DialogAPIEvent) {
        switch event {
        default:
            break
        }
    }

    private func handle(_ error: DialogAPIError) {
        switch error {
        case .requestTimeout:
            standby()
        case .clientSide:
            standby()
        default:
            break
        }
    }
}
