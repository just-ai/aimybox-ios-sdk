    //
//  YandexSpeechKitTests.swift
//  YandexSpeechKitTests
//
//  Created by Vladislav Popovich on 23.01.2020.
//  Copyright © 2020 Just Ai. All rights reserved.
//

import XCTest
@testable import YandexSpeechKit

class YandexSpeechKitTests: XCTestCase {

    var token: IAMToken!
    
    override func setUp() {
    }

    override func tearDown() {
    }

    var stream: Any?
    var api: Any?
    
    func testGetTokenSuccess() {
        
        let token = IAMTokenGenerator.token(api: URL(string: "https://iam.api.cloud.yandex.net/iam/v1/tokens")!,
                                            passport: "AgAEA7qh4Sk-AATuweUovqabw0TWu2zVVuIS3hU")
        
        XCTAssertNotNil(token)
        
        let api = YandexRecognitionAPI(iAM: token!.iamToken, folderID: "b1gh6rgpahg9909290r8")
        
        self.api = api
        
        api.openStream(on: { response in
            print(response)
        }, error: { error in
            print(error)
        }, completion: { stream in
            self.stream = stream
            
            print(stream)
        })
        
        
        
        
        let exp = XCTestExpectation()
        
        exp.expectedFulfillmentCount = 1
        
        wait(for: [exp], timeout: 5.0)
    }
    
    func testPerformanceExample() {
    }

}
