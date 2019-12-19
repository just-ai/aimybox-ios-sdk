//
//  AimyboxBaseTestCase.swift
//  AimyboxCoreTests
//
//  Created by Vladyslav Popovych on 23.11.2019.
//  Copyright © 2019 Just Ai. All rights reserved.
//

import XCTest
@testable import AimyboxCore

class AimyboxBaseTestCase: XCTestCase {

    var aimybox: Aimybox!
    
    var stt: SpeechToTextFake!
    var dapi: DialogAPIFake!
    var tts: TextToSpeechFake!
    
    // MARK: - SpeechToText
    /// For Events
    var recognitionStartedSemaphore: DispatchSemaphore?
    var recognitionPartialResultSemaphore: DispatchSemaphore?
    var recognitionResultSemaphore: DispatchSemaphore?
    var recognitionEmptyResultSemaphore: DispatchSemaphore?
    var recognitionCancelledSemaphore: DispatchSemaphore?
    /// For Errors
    var microphonePermissionRejectSemaphore: DispatchSemaphore?
    var speechRecognitionPermissionRejectSemaphore: DispatchSemaphore?
    var microphoneUnreachableSemaphore: DispatchSemaphore?
    var speechRecognitionUnavailableSemaphore: DispatchSemaphore?
    /// For other
    var partialResultCount: Int = 0
    var partialResultMaxCount: Int = 3
    // MARK: - DialogAPI
    /// Events
    var requestSentSemaphore: DispatchSemaphore?
    var responseReceivedSemaphore: DispatchSemaphore?
    /// Errors
    var requestTimeoutSemaphore: DispatchSemaphore?
    var requestCancelledSemaphore: DispatchSemaphore?
    var clientSideErrorSemaphore: DispatchSemaphore?
    /// CustomSkills
    /// 1
    var skill_1_onResponseSemaphore: DispatchSemaphore?
    var skill_1_onRequestSemaphore: DispatchSemaphore?
    /// 2
    var skill_2_onResponseSemaphore: DispatchSemaphore?
    var skill_2_onRequestSemaphore: DispatchSemaphore?
    // MARK: - TextToSpeech
    /// Events
    var speechSequenceStartedSemaphore: DispatchSemaphore?
    var speechStartedSemaphore: DispatchSemaphore?
    var speechEndedSemaphore: DispatchSemaphore?
    var speechSequenceCompletedSemaphore: DispatchSemaphore?
    var speechSkippedSemaphore: DispatchSemaphore?
    /// Errors
    var emptySpeechSemaphore: DispatchSemaphore?
    var speakersUnavailableSemaphore: DispatchSemaphore?
    var speechSequenceCancelledSemaphore: DispatchSemaphore?
    
    override func setUp() {
        stt = SpeechToTextFake()
        tts = TextToSpeechFake()
        dapi = DialogAPIFake()
        let config = AimyboxBuilder.config(stt, tts, dapi)
        
        // MARK: - SpeechToText
        config.speechToText.notify = { [weak self] result in
            switch result {
            case .success(let event):
                switch event {
                case .recognitionStarted:
                    self?.recognitionStartedSemaphore?.signal()
                case .recognitionPartialResult:
                    self?.partialResultCount += 1
                    if self?.partialResultCount == self?.partialResultMaxCount {
                        self?.recognitionPartialResultSemaphore?.signal()
                    }
                case .recognitionResult:
                    self?.recognitionResultSemaphore?.signal()
                case .recognitionCancelled:
                    self?.recognitionCancelledSemaphore?.signal()
                case .emptyRecognitionResult:
                    self?.recognitionEmptyResultSemaphore?.signal()
                default:
                    XCTAssert(false)
                }
                
            case .failure(let error):
                switch error {
                case .microphonePermissionReject:
                    self?.microphonePermissionRejectSemaphore?.signal()
                case .speechRecognitionPermissionReject:
                    self?.speechRecognitionPermissionRejectSemaphore?.signal()
                case .microphoneUnreachable:
                    self?.microphoneUnreachableSemaphore?.signal()
                case .speechRecognitionUnavailable:
                    self?.speechRecognitionUnavailableSemaphore?.signal()
                }
            }
        }

        recognitionStartedSemaphore = DispatchSemaphore(value: 0)
        recognitionPartialResultSemaphore = DispatchSemaphore(value: 0)
        recognitionResultSemaphore = DispatchSemaphore(value: 0)
        recognitionCancelledSemaphore = DispatchSemaphore(value: 0)
        recognitionEmptyResultSemaphore = DispatchSemaphore(value: 0)
        microphonePermissionRejectSemaphore = DispatchSemaphore(value: 0)
        speechRecognitionPermissionRejectSemaphore = DispatchSemaphore(value: 0)
        microphoneUnreachableSemaphore = DispatchSemaphore(value: 0)
        speechRecognitionUnavailableSemaphore = DispatchSemaphore(value: 0)
        
        // MARK: - DialogAPI
        config.dialogAPI.notify = { [weak self] (result) in
            switch result {
            case .success(let event):
                switch event {
                case .requestSent:
                    self?.requestSentSemaphore?.signal()
                case .responseReceived:
                    self?.responseReceivedSemaphore?.signal()
                }
            case .failure(let error):
                switch error {
                case .requestTimeout:
                    self?.requestTimeoutSemaphore?.signal()
                case .requestCancellation:
                    self?.requestCancelledSemaphore?.signal()
                case .clientSide:
                    self?.clientSideErrorSemaphore?.signal()
                case .processingCancellation:
                    break
                }
            }
        }
        
        requestSentSemaphore = DispatchSemaphore(value: 0)
        responseReceivedSemaphore = DispatchSemaphore(value: 0)
        requestTimeoutSemaphore = DispatchSemaphore(value: 0)
        requestCancelledSemaphore = DispatchSemaphore(value: 0)
        clientSideErrorSemaphore = DispatchSemaphore(value: 0)
        /// CustomSkills
        /// 1
        dapi.skill_1.canHandle = false
        dapi.skill_1.onRequestHandler = { [weak self] request in
            self?.skill_1_onRequestSemaphore?.signal()
            return request
        }
        dapi.skill_1.onResponseHandler = { [weak self] response, _, _ in
            self?.skill_1_onResponseSemaphore?.signal()
            return response
        }
        skill_1_onResponseSemaphore = DispatchSemaphore(value: 0)
        skill_1_onRequestSemaphore = DispatchSemaphore(value: 0)
        /// 2
        dapi.skill_2.canHandle = false
        dapi.skill_2.onRequestHandler = { [weak self] request in
            self?.skill_2_onRequestSemaphore?.signal()
            return request
        }
        dapi.skill_2.onResponseHandler = { [weak self] response, _, _ in
            self?.skill_2_onResponseSemaphore?.signal()
            return response
        }
        skill_2_onResponseSemaphore = DispatchSemaphore(value: 0)
        skill_2_onRequestSemaphore = DispatchSemaphore(value: 0)

        // MARK: - TextToSpeech
        config.textToSpeech.notify = { [weak self] (result) in
            switch result {
            case .success(let event):
                switch event {
                case .speechSequenceStarted:
                    self?.speechStartedSemaphore?.signal()
                case .speechStarted:
                    self?.speechStartedSemaphore?.signal()
                case .speechSkipped:
                    self?.speechSkippedSemaphore?.signal()
                case .speechEnded:
                    self?.speechEndedSemaphore?.signal()
                case .speechSequenceCompleted:
                    self?.speechSequenceCompletedSemaphore?.signal()
                }
            case .failure(let error):
                switch error {
                case .emptySpeech:
                    self?.emptySpeechSemaphore?.signal()
                case .speakersUnavailable:
                    self?.speakersUnavailableSemaphore?.signal()
                case .speechSequenceCancelled:
                    self?.speechSequenceCancelledSemaphore?.signal()
                }
            }
        }
        /// Events
        speechSequenceStartedSemaphore = DispatchSemaphore(value: 0)
        speechStartedSemaphore = DispatchSemaphore(value: 0)
        speechEndedSemaphore = DispatchSemaphore(value: 0)
        speechSequenceCompletedSemaphore = DispatchSemaphore(value: 0)
        speechSkippedSemaphore = DispatchSemaphore(value: 0)
        /// Errors
        emptySpeechSemaphore = DispatchSemaphore(value: 0)
        speakersUnavailableSemaphore = DispatchSemaphore(value: 0)
        speechSequenceCancelledSemaphore = DispatchSemaphore(value: 0)
        
        aimybox = AimyboxBuilder.aimybox(with: config)
    }
    
    override func tearDown() {
        aimybox = nil
        stt = nil
        dapi = nil

        recognitionStartedSemaphore = nil
        recognitionPartialResultSemaphore = nil
        recognitionResultSemaphore = nil
        recognitionEmptyResultSemaphore = nil
        recognitionCancelledSemaphore = nil
        /// For Errors
        microphonePermissionRejectSemaphore = nil
        speechRecognitionPermissionRejectSemaphore = nil
        microphoneUnreachableSemaphore = nil
        speechRecognitionUnavailableSemaphore = nil
        /// For other
        partialResultCount = 0
        partialResultMaxCount = 3
        // MARK: - DialogAPI
        /// Events
        requestSentSemaphore = nil
        requestCancelledSemaphore = nil
        responseReceivedSemaphore = nil
        /// Errors
        requestTimeoutSemaphore = nil
        clientSideErrorSemaphore = nil
        /// CustomSkills
        /// 1
        skill_1_onResponseSemaphore = nil
        skill_1_onRequestSemaphore = nil
        /// 2
        skill_2_onResponseSemaphore = nil
        skill_2_onRequestSemaphore = nil
        // MARK: - TextToSpeech
        /// Events
        speechSequenceStartedSemaphore = nil
        speechStartedSemaphore = nil
        speechEndedSemaphore = nil
        speechSequenceCompletedSemaphore = nil
        speechSkippedSemaphore = nil
        /// Errors
        emptySpeechSemaphore = nil
        speakersUnavailableSemaphore = nil
        speechSequenceCancelledSemaphore = nil
    }
}


public extension DispatchSemaphore {
    @inline(__always) func waitOrFail(timeout: DispatchTime = .now() + 5.0) {
        XCTAssertEqual(wait(timeout: timeout), .success, "Timeout for event wait.")
    }
    
    @inline(__always) func waitOrPass(timeout: DispatchTime = .now() + 5.0) {
        XCTAssertEqual(wait(timeout: timeout), .timedOut, "Timeout for event pass.")
    }
}

