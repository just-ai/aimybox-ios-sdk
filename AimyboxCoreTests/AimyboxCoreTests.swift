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

    override func setUp() {
    }

    override func tearDown() {
    }

    func testInit() {
        let aimbox = Aimybox.shared

        XCTAssert(true, "\(aimbox)")
    }
}
