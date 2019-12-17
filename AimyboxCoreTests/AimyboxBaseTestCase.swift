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
                }
            }
        }
        
        requestSentSemaphore = DispatchSemaphore(value: 0)
        responseReceivedSemaphore = DispatchSemaphore(value: 0)
        requestTimeoutSemaphore = DispatchSemaphore(value: 0)
        requestCancelledSemaphore = DispatchSemaphore(value: 0)
        clientSideErrorSemaphore = DispatchSemaphore(value: 0)
        
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
    }
}


public extension DispatchSemaphore {
    @inline(__always) func waitOrFail(timeout: DispatchTime = .now() + 5.0) {
        XCTAssertEqual(wait(timeout: timeout), .success, "Timeout for event wait.")
    }
}

