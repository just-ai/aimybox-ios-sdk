//
//  DialogAPIResponseFake.swift
//  AimyboxCoreTests
//
//  Created by Vladyslav Popovych on 15.12.2019.
//  Copyright © 2019 Just Ai. All rights reserved.
//

import Foundation
import AimyboxCore

class DialogAPIResponseFake: Response {
    public init(query: String, action: String, intent: String, question: Bool, replies: [Reply]) {
        self.query = query
        self.action = action
        self.intent = intent
        self.question = question
        self.replies = replies
    }

    var query: String

    var action: String

    var intent: String

    var question: Bool

    var replies: [Reply]
}
