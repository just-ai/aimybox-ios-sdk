//
//  DialogAPICoreTests.swift
//  AimyboxCoreTests
//
//  Created by Vladislav Popovich on 16.12.2019.
//  Copyright © 2019 Just Ai. All rights reserved.
//

@testable import AimyboxCore
import XCTest

open class DialogAPICoreTests: AimyboxBaseTestCase {

    override open func invokeTest() {
        (0..<1).forEach { _ in
            super.invokeTest()
        }
    }

    func testStateAfterSendRequest() {

        aimybox.startRecognition()

        recognitionResultSemaphore?.waitOrFail()

        requestSentSemaphore?.waitOrFail()

        XCTAssert(aimybox.state == .processing)
    }

    func testStateAfterSendRequestTranstionToStandby() {

        dapi.sendTimeout = 3.0

        aimybox.startRecognition()

        recognitionResultSemaphore?.waitOrFail()

        requestSentSemaphore?.waitOrFail()

        aimybox.standby()

        requestCancelledSemaphore?.waitOrFail()

        XCTAssert(aimybox.state == .standby)
    }

    func testStateAfterSendRequestTimeout() {

        let timeout = 11.0

        dapi.sendTimeout = timeout

        aimybox.startRecognition()

        recognitionResultSemaphore?.waitOrFail()

        requestSentSemaphore?.waitOrFail()

        requestTimeoutSemaphore?.waitOrFail(timeout: .now() + timeout)

        XCTAssert(aimybox.state == .standby)
    }

    func testStateAfterSendRequestFailedWithClientError() {

        dapi.errorState = NSError(domain: "ClientError", code: 1, userInfo: nil)

        aimybox.startRecognition()

        recognitionResultSemaphore?.waitOrFail()

        clientSideErrorSemaphore?.waitOrFail()

        XCTAssert(aimybox.state == .standby)
    }

    func testPreviousRequestCancelAfterNewRequestTriggered() {

        let timeout = 5.0
        dapi.sendTimeout = timeout

        aimybox.startRecognition()
        requestSentSemaphore?.waitOrFail()

        aimybox.startRecognition()
        requestCancelledSemaphore?.waitOrFail()
        XCTAssert(aimybox.state == .processing)

        requestSentSemaphore?.waitOrFail()

        XCTAssert(aimybox.state == .processing)
    }

    func testCustomSkillCanHandle() {

        dapi.skill_1.canHandle = true

        aimybox.startRecognition()
        requestSentSemaphore?.waitOrFail()

        skill_1_onResponseSemaphore?.waitOrFail()
    }

    func tesCustomSkilltOnlyOneCanHandle() {

        dapi.skill_1.canHandle = true
        dapi.skill_2.canHandle = true

        aimybox.startRecognition()
        requestSentSemaphore?.waitOrFail()

        skill_1_onResponseSemaphore?.waitOrFail()
        skill_2_onResponseSemaphore?.waitOrPass()
    }

    func testCustomSkillOnRequestSend() {

        aimybox.startRecognition()

        skill_1_onRequestSemaphore?.waitOrFail()
        skill_2_onRequestSemaphore?.waitOrFail()

        requestSentSemaphore?.waitOrFail()
    }

    func testCustomSkillOnRequestModifyRequest() {

        let oldHandler = dapi.skill_1.onRequestHandler
        let sentQuery = "ping"

        dapi.skill_1.onRequestHandler = { request in
            request.query = sentQuery
            return oldHandler?(request) ?? request
        }

        aimybox.startRecognition()

        skill_1_onRequestSemaphore?.waitOrFail()

        requestSentSemaphore?.waitOrFail()

        XCTAssert(dapi.sentQuery == sentQuery)
    }

    func testCustomSkillsOnRequestModifyRequest() {

        let oldHandler1 = dapi.skill1.onRequestHandler
        let oldHandler2 = dapi.skill2.onRequestHandler
        let sentQuery1 = "ping"
        let sentQuery2 = "-pong"

        dapi.skill1.onRequestHandler = { request in
            request.query = sentQuery1
            return oldHandler1?(request) ?? request
        }
        dapi.skill2.onRequestHandler = { request in
            request.query += sentQuery2
            return oldHandler2?(request) ?? request
        }

        aimybox.startRecognition()

        skill_1_onRequestSemaphore?.waitOrFail()
        skill_2_onRequestSemaphore?.waitOrFail()

        requestSentSemaphore?.waitOrFail()

        XCTAssert(dapi.sentQuery == sentQuery_1+sentQuery_2)
    }

    func testCustomSkillOnRequestOvverideRequest() {

        let oldHandler = dapi.skill_2.onRequestHandler
        let sentQuery = "pong"

        dapi.skill_2.onRequestHandler = { request in
            request.query = sentQuery
            return oldHandler?(request) ?? request
        }

        aimybox.startRecognition()

        skill_2_onRequestSemaphore?.waitOrFail()

        requestSentSemaphore?.waitOrFail()

        XCTAssert(dapi.sentQuery == sentQuery)
    }

    func testStateAfterCustomSkillHandle() {

        dapi.skill_1.canHandle = true
        let oldHandler = dapi.skill_1.onResponseHandler
        dapi.skill_1.onResponseHandler = { response, aimybox, defaultHandler in
            let response = oldHandler?(response, aimybox, defaultHandler) ?? response
            aimybox.standby()
            return response
        }

        aimybox.startRecognition()

        skill_1_onRequestSemaphore?.waitOrFail()

        XCTAssert(aimybox.state == .processing)

        skill_1_onResponseSemaphore?.waitOrFail()

        XCTAssert(aimybox.state == .standby)
    }

    func testStateAfterCustomSkillHandleThenCallDefaultHandler() {

        dapi.skill_1.canHandle = true

        let oldHandler = dapi.skill_1.onResponseHandler
        dapi.skill_1.onResponseHandler = { response, aimybox, defaultHandler in
            let response = oldHandler?(response, aimybox, defaultHandler) ?? response
            defaultHandler(response)
            return response
        }

        aimybox.startRecognition()

        skill_1_onRequestSemaphore?.waitOrFail()

        XCTAssert(aimybox.state == .processing)

        skill_1_onResponseSemaphore?.waitOrFail()

        speechSequenceCompletedSemaphore?.waitOrFail()

        XCTAssert(aimybox.state == .standby)
    }
}
