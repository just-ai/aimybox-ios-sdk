//
//  AimyboxDialogAPITests.swift
//  AimyboxDialogAPITests
//
//  Created by Vladyslav Popovych on 19.12.2019.
//

import XCTest
@testable import AimyboxDialogAPI

class AimyboxDialogAPITests: XCTestCase {

    var dapi: AimyboxDialogAPI!
    
    override func setUp() {
        super.setUp()
        
        dapi = AimyboxDialogAPI(api_key: "sgEfvEonbLOTw6wTEaINZb6zehab8RQF",
                                unit_key: UUID().uuidString)
    }
    
    override func tearDown() {
        super.tearDown()
        
        dapi = nil
    }

    func testCreateRequest() {
        let query = "2+2"
        
        let request = dapi.createRequest(query: query)
        
        XCTAssert(request.query == query)
        XCTAssert(request.apiKey == dapi.api_key)
        XCTAssert(request.unitKey == dapi.unit_key)
        XCTAssert(request.data == [:])
    }
    
    func testSendRequest() {
        let query = "2+2"
        
        let request = dapi.createRequest(query: query)
        
        XCTAssertNoThrow(try dapi.send(request: request))
    }
}
