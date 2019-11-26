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
        let speechToText = SFSpeechToText()
        let config = Aimybox.Config(speechToText: speechToText)
        aimybox = Aimybox(with: config)
    }

    override func tearDown() {
        aimybox = nil
    }

    func testInitialState() {
        
        let isValid = aimybox.state == .standby
        XCTAssert(isValid, "Initial state should be standby.")
    }
    
    func testStateAfterStartSpeechRecognizing() {
        
        aimybox.startRecognition()
        
        let isValid = aimybox.state == .listening
        XCTAssert(isValid, "State after start of speech recognizing should be listening.")
    }
    
}
