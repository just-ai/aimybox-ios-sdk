//
//  AimyboxCoreTests.swift
//  AimyboxCoreTests
//
//  Created by Vladyslav Popovych on 23.11.2019.
//  Copyright © 2019 Just Ai. All rights reserved.
//

import XCTest
@testable import AimyboxCore

class AimyboxCoreTests: XCTestCase {

    var aimybox: Aimybox!
    
    override func setUp() {
        let stt = SpeechToTextFake()
        let tts = TextToSpeechFake()
        let dapi = DialogAPIFake()
        let config = AimyboxBuilder.config(stt, tts, dapi)
        
        aimybox = AimyboxBuilder.aimybox(with: config)
    }

    override func tearDown() {
        aimybox = nil
    }

    func testInitialState() {
        
        let isValid = aimybox.state == .standby
        XCTAssert(isValid, "Initial state should be standby.")
    }
}

class AimyboxSpeechToText: XCTestCase {
    
    let partialResultCount: Int = 3
    
    var aimybox: Aimybox!

    var recognitionStartedSemaphore: DispatchSemaphore!
    var recognitionPartialResultSemaphore: DispatchSemaphore!
    var recognitionResultSemaphore: DispatchSemaphore!
    var recognitionCancelledSemaphore: DispatchSemaphore!
    
    override func setUp() {
        let stt = SpeechToTextFake()
        stt.partialResultCount = partialResultCount
        
        let config = getConfig(stt)
        
        config.speechToText.notify = { [weak self] result in
            switch result {
            case .success(let event):
                switch event {
                case .recognitionStarted:
                    self?.recognitionStartedSemaphore.signal()
                case .recognitionPartialResult:
                    self?.recognitionPartialResultSemaphore.signal()
                case .recognitionResult:
                    self?.recognitionResultSemaphore.signal()
                case .recognitionCancelled:
                    self?.recognitionCancelledSemaphore.signal()
                default:
                    XCTAssert(false)
                }
                
            case .failure:
                XCTAssert(false)
            }
        }
        aimybox = AimyboxBuilder.aimybox(with: config)
        recognitionStartedSemaphore = DispatchSemaphore(value: 0)
        recognitionPartialResultSemaphore = DispatchSemaphore(value: partialResultCount)
        recognitionResultSemaphore = DispatchSemaphore(value: 0)
        recognitionCancelledSemaphore = DispatchSemaphore(value: 0)
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
        (0..<1).forEach { _ in
            super.invokeTest()
        }
    }
    
    func testStateAfterStartSpeechRecognizing() {
        aimybox.startRecognition()
        recognitionStartedSemaphore.wait()
        
        XCTAssert(aimybox.state == .listening)
    }
    
    func testStandbyAfterStartSpeechRecognizing() {
        
        aimybox.startRecognition()

        aimybox.standby()
        recognitionCancelledSemaphore.wait()

        XCTAssert(aimybox.state == .standby)
    }
    
    func testStateAfterStopSpeechRecognition() {
        
        aimybox.startRecognition()
        
        aimybox.stopRecognition()
        recognitionResultSemaphore.wait()
        
        XCTAssert(aimybox.state == .processing)
    }
    
    func testStateAfterSpeechReconitionComplete() {
        
        aimybox.startRecognition()
        
        recognitionPartialResultSemaphore.wait()
        
        recognitionResultSemaphore.wait()
        
        XCTAssert(aimybox.state == .processing)
    }
}
