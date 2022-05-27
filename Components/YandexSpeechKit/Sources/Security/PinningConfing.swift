//
//  File.swift
//  YandexSpeechKit
//
//  Created by Alexey Sakovykh on 11.05.2022.
//  Copyright © 2022 Just Ai. All rights reserved.
//

import Foundation

public
struct PinningConfig {

    public
    var host: String

    public
    var port: Int = 443
    
    public
    var pin: String
    
    public
    var useTLSifPinBroken = true

    public
    init(host: String, port: Int, pin: String) {
        self.host = host
        self.port = port
        self.pin = pin
    }
}
