//
//  SpeechToTextCoreTests.swift
//  AimyboxCoreTests
//
//  Created by Vladislav Popovich on 16.12.2019.
//  Copyright © 2019 Just Ai. All rights reserved.
//

@testable import AimyboxCore
import XCTest

class SpeechToTextCoreTests: AimyboxBaseTestCase {

    override func invokeTest() {
        (0..<1).forEach { _ in
            super.invokeTest()
        }
    }

    func testStateAfterStartSpeechRecognizing() {

        aimybox.startRecognition()
        recognitionStartedSemaphore?.waitOrFail()

        XCTAssert(aimybox.state == .listening)
    }

    func testStandbyAfterStartSpeechRecognizing() {

        aimybox.startRecognition()

        aimybox.standby()
        recognitionCancelledSemaphore?.waitOrFail()

        XCTAssert(aimybox.state == .standby)
    }

    func testStateAfterStopSpeechRecognition() {

        aimybox.startRecognition()

        aimybox.stopRecognition()
        recognitionResultSemaphore?.waitOrFail()

        XCTAssert(aimybox.state == .processing)
    }

    func testStateAfterCancelSpeechRecognition() {

        aimybox.startRecognition()

        aimybox.cancelRecognition()
        recognitionCancelledSemaphore?.waitOrFail()

        XCTAssert(aimybox.state == .standby)
    }

    func testStateAfterSpeechReconitionComplete() {

        aimybox.startRecognition()

        recognitionPartialResultSemaphore?.waitOrFail()

        recognitionResultSemaphore?.waitOrFail()

        XCTAssert(aimybox.state == .processing)
    }

    func testStateAfterEmptyRecognitionResult() {

        stt.finalResult = ""

        aimybox.startRecognition()

        recognitionEmptyResultSemaphore?.waitOrFail()

        XCTAssert(aimybox.state == .standby)
    }

    func testStartRecognitionTwice() {

        aimybox.startRecognition()
        recognitionStartedSemaphore?.waitOrFail()

        aimybox.startRecognition()
        recognitionCancelledSemaphore?.waitOrFail()
        recognitionStartedSemaphore?.waitOrFail()
    }

    func testStateAfterMicrophonePermissionReject() {

        stt.errorState = .microphonePermissionReject

        aimybox.startRecognition()

        microphonePermissionRejectSemaphore?.waitOrFail()

        XCTAssert(aimybox.state == .standby)
    }

    func testStateAfterMicrophoneUnreachableError() {

        stt.errorState = .microphoneUnreachable

        aimybox.startRecognition()

        microphoneUnreachableSemaphore?.waitOrFail()

        XCTAssert(aimybox.state == .standby)
    }

    func testStateAfterSpeechRecognitionPermissionReject() {

        stt.errorState = .speechRecognitionPermissionReject

        aimybox.startRecognition()

        speechRecognitionPermissionRejectSemaphore?.waitOrFail()

        XCTAssert(aimybox.state == .standby)
    }

    func testStateAfterspeechRecognitionUnavailableError() {

        stt.errorState = .speechRecognitionUnavailable

        aimybox.startRecognition()

        speechRecognitionUnavailableSemaphore?.waitOrFail()

        XCTAssert(aimybox.state == .standby)
    }
}
