//
//  SpeechToTextCoreTests.swift
//  AimyboxCoreTests
//
//  Created by Vladislav Popovich on 16.12.2019.
//  Copyright © 2019 Just Ai. All rights reserved.
//

import XCTest
@testable import AimyboxCore

class AimyboxSpeechToText: XCTestCase {
    
    var partialResultCount: Int = 0
    let partialResultMaxCount: Int = 3
    
    var aimybox: Aimybox!
    var stt: SpeechToTextFake!

    /// For Events
    var recognitionStartedSemaphore: DispatchSemaphore!
    var recognitionPartialResultSemaphore: DispatchSemaphore!
    var recognitionResultSemaphore: DispatchSemaphore!
    var recognitionEmptyResultSemaphore: DispatchSemaphore!
    var recognitionCancelledSemaphore: DispatchSemaphore!
    /// For Errors
    var microphonePermissionRejectSemaphore: DispatchSemaphore!
    var speechRecognitionPermissionRejectSemaphore: DispatchSemaphore!
    var microphoneUnreachableSemaphore: DispatchSemaphore!
    var speechRecognitionUnavailableSemaphore: DispatchSemaphore!
    
    override func setUp() {
        stt = SpeechToTextFake()
        stt.partialResultCount = partialResultMaxCount
        
        let config = getConfig(stt)
        
        config.speechToText.notify = { [weak self] result in
            switch result {
            case .success(let event):
                switch event {
                case .recognitionStarted:
                    self?.recognitionStartedSemaphore.signal()
                case .recognitionPartialResult:
                    self?.partialResultCount += 1
                    if self?.partialResultCount == self?.partialResultMaxCount {
                        self?.recognitionPartialResultSemaphore.signal()
                    }
                case .recognitionResult:
                    self?.recognitionResultSemaphore.signal()
                case .recognitionCancelled:
                    self?.recognitionCancelledSemaphore.signal()
                case .emptyRecognitionResult:
                    self?.recognitionEmptyResultSemaphore.signal()
                default:
                    XCTAssert(false)
                }
                
            case .failure(let error):
                switch error {
                case .microphonePermissionReject:
                    self?.microphonePermissionRejectSemaphore.signal()
                case .speechRecognitionPermissionReject:
                    self?.speechRecognitionPermissionRejectSemaphore.signal()
                case .microphoneUnreachable:
                    self?.microphoneUnreachableSemaphore.signal()
                case .speechRecognitionUnavailable:
                    self?.speechRecognitionUnavailableSemaphore.signal()
                }
            }
        }
        partialResultCount = 0
        aimybox = AimyboxBuilder.aimybox(with: config)
        recognitionStartedSemaphore = DispatchSemaphore(value: 0)
        recognitionPartialResultSemaphore = DispatchSemaphore(value: 0)
        recognitionResultSemaphore = DispatchSemaphore(value: 0)
        recognitionCancelledSemaphore = DispatchSemaphore(value: 0)
        recognitionEmptyResultSemaphore = DispatchSemaphore(value: 0)
        microphonePermissionRejectSemaphore = DispatchSemaphore(value: 0)
        speechRecognitionPermissionRejectSemaphore = DispatchSemaphore(value: 0)
        microphoneUnreachableSemaphore = DispatchSemaphore(value: 0)
        speechRecognitionUnavailableSemaphore = DispatchSemaphore(value: 0)
    }

    func getConfig(_ stt: SpeechToText = SpeechToTextFake()) -> AimyboxConfigConcrete<DialogAPIFake> {
        let tts = TextToSpeechFake()
        let dapi = DialogAPIFake()
        return AimyboxBuilder.config(stt, tts, dapi)
    }
    
    override func tearDown() {
        aimybox = nil
    }
    
    override func invokeTest() {
//        (0..<10).forEach { _ in
            super.invokeTest()
//        }
    }
    
    func testStateAfterStartSpeechRecognizing() {
        
        aimybox.startRecognition()
        recognitionStartedSemaphore.waitOrFail()
        
        XCTAssert(aimybox.state == .listening)
    }
    
    func testStandbyAfterStartSpeechRecognizing() {
        
        aimybox.startRecognition()

        aimybox.standby()
        recognitionCancelledSemaphore.waitOrFail()

        XCTAssert(aimybox.state == .standby)
    }
    
    func testStateAfterStopSpeechRecognition() {
        
        aimybox.startRecognition()
        
        aimybox.stopRecognition()
        recognitionResultSemaphore.waitOrFail()
        
        XCTAssert(aimybox.state == .processing)
    }
    
    func testStateAfterCancelSpeechRecognition() {
        
        aimybox.startRecognition()
        
        aimybox.cancelRecognition()
        recognitionCancelledSemaphore.waitOrFail()
        
        XCTAssert(aimybox.state == .standby)
    }
    
    func testStateAfterSpeechReconitionComplete() {
        
        aimybox.startRecognition()
        
        recognitionPartialResultSemaphore.waitOrFail()
        
        recognitionResultSemaphore.waitOrFail()
        
        XCTAssert(aimybox.state == .processing)
    }
    
    func testStateAfterEmptyRecognitionResult() {

        stt.finalResult = ""
        
        aimybox.startRecognition()
        
        recognitionEmptyResultSemaphore.waitOrFail()
        
        XCTAssert(aimybox.state == .standby)
    }
    
    func testStartRecognitionTwice() {
        
        aimybox.startRecognition()
        recognitionStartedSemaphore.waitOrFail()
        
        aimybox.startRecognition()
        recognitionCancelledSemaphore.waitOrFail()
        recognitionStartedSemaphore.waitOrFail()
    }
    
    func testStateAfterMicrophonePermissionReject() {
        
        stt.errorState = .microphonePermissionReject
        
        aimybox.startRecognition()
        
        microphonePermissionRejectSemaphore.waitOrFail()
        
        XCTAssert(aimybox.state == .standby)
    }
    
    func testStateAfterMicrophoneUnreachableError() {
        
        stt.errorState = .microphoneUnreachable
        
        aimybox.startRecognition()
        
        microphoneUnreachableSemaphore.waitOrFail()
        
        XCTAssert(aimybox.state == .standby)
    }
    
    func testStateAfterSpeechRecognitionPermissionReject() {
        
        stt.errorState = .speechRecognitionPermissionReject
        
        aimybox.startRecognition()
        
        speechRecognitionPermissionRejectSemaphore.waitOrFail()
        
        XCTAssert(aimybox.state == .standby)
    }
    
    func testStateAfterspeechRecognitionUnavailableError() {
        
        stt.errorState = .speechRecognitionUnavailable
        
        aimybox.startRecognition()
        
        speechRecognitionUnavailableSemaphore.waitOrFail()
        
        XCTAssert(aimybox.state == .standby)
    }
}

extension DispatchSemaphore {
    func waitOrFail() {
        XCTAssertEqual(wait(timeout: .now() + 5.0), .success, "Timeout for event wait.")
    }
}
