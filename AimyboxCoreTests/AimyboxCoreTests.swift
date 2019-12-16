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
