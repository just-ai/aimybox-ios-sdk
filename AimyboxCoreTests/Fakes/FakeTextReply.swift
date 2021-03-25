//
//  FakeTextReply.swift
//  AimyboxCoreTests
//
//  Created by Vladyslav Popovych on 19.12.2019.
//  Copyright © 2019 Just Ai. All rights reserved.
//

import AimyboxCore

class FakeTextReply: TextReply {

    internal init(text: String, tts: String? = nil, language: String? = nil) {
        self.text = text
        self.tts = tts
        self.language = language
    }

    var text: String

    var tts: String?

    var language: String?
}
