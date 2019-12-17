//
//  DialogAPICoreTests.swift
//  AimyboxCoreTests
//
//  Created by Vladislav Popovich on 16.12.2019.
//  Copyright © 2019 Just Ai. All rights reserved.
//

import XCTest
@testable import AimyboxCore

class DialogAPICoreTests: AimyboxBaseTestCase {

    override func invokeTest() {
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
}
