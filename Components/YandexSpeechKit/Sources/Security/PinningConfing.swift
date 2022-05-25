//
//  File.swift
//  YandexSpeechKit
//
//  Created by Alexey Sakovykh on 11.05.2022.
//  Copyright © 2022 Just Ai. All rights reserved.
//

import Foundation

public struct PinningConfig {
    
    var host: String
    var port: Int = 443
    var pin: String
    
    public
    init(host: String, port: Int, pin: String) {
        self.host = host
        self.port = port
        self.pin = pin
    }
     
}
