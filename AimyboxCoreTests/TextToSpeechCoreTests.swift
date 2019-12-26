//
//  TextToSpeechCoreTests.swift
//  AimyboxCoreTests
//
//  Created by Vladyslav Popovych on 19.12.2019.
//  Copyright © 2019 Just Ai. All rights reserved.
//

import XCTest

class TextToSpeechCoreTests: AimyboxBaseTestCase {
    
    func testStateAfterSpeechSequenceStarted() {
        dapi.replyQuery = "ping"
        
        aimybox.startRecognition()
        
        speechStartedSemaphore?.waitOrFail()
        
        XCTAssert(aimybox.state == .speaking)
    }
    
    func testSpeechStarted() {
        
        dapi.replyQuery = "ping"
        
        aimybox.startRecognition()
        
        speechStartedSemaphore?.waitOrFail()
        
        XCTAssert(aimybox.state == .speaking)
        
        speechSequenceCompletedSemaphore?.waitOrFail()
        
        XCTAssert(aimybox.state == .standby)
    }
    
    func testSpeechEnded() {
        
        dapi.replyQuery = "ping"
        
        aimybox.startRecognition()
        
        speechStartedSemaphore?.waitOrFail()
        
        speechEndedSemaphore?.waitOrFail()
        
        speechSequenceCompletedSemaphore?.waitOrFail()
        
        XCTAssert(aimybox.state == .standby)
    }
    
    func testSpeechSequenceCompleted() {
        
        dapi.replyQuery = "ping"
        
        aimybox.startRecognition()
        
        speechStartedSemaphore?.waitOrFail()
        
        XCTAssert(aimybox.state == .speaking)
        
        speechSequenceCompletedSemaphore?.waitOrFail()
        
        XCTAssert(aimybox.state == .standby)
    }
    
    func testSpeechSkipped() {
        
        aimybox.startRecognition()
        
        speechStartedSemaphore?.waitOrFail()
        
        speechSkippedSemaphore?.waitOrFail()
        
        speechSequenceCompletedSemaphore?.waitOrFail()
        
        XCTAssert(aimybox.state == .standby)
    }
    
    func testStateAfterSpeakersUnavailableError() {
        tts.errorState = .speakersUnavailable
        
        aimybox.startRecognition()
        
        speakersUnavailableSemaphore?.waitOrFail()
        
        XCTAssert(aimybox.state == .standby)
    }
    
    func testStateAfterCancelCurrentSpeech() {
        
        dapi.replyQuery = "ping"
        
        aimybox.startRecognition()
        
        speechStartedSemaphore?.waitOrFail()
        
        XCTAssert(aimybox.state == .speaking)
        
        aimybox.standby()

        speechSequenceCancelledSemaphore?.waitOrFail()
        
        XCTAssert(aimybox.state == .standby)
    }
    
    func testStateAfterEmptySpeechError() {
        
        aimybox.startRecognition()
        
        speechStartedSemaphore?.waitOrFail()

        emptySpeechSemaphore?.waitOrFail()
        
    }

}
