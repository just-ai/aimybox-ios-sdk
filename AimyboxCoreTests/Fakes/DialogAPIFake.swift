//
//  DialogAPIFake.swift
//  AimyboxCoreTests
//
//  Created by Vladyslav Popovych on 15.12.2019.
//  Copyright © 2019 Just Ai. All rights reserved.
//

import AimyboxCore
import Foundation

class DialogAPIFake: AimyboxComponent, DialogAPI {

    var timeoutPollAttempts = 10

    public
    var sendTimeout: TimeInterval = 0.5

    public
    var errorState: Error?

    public
    var sentQuery: String = ""

    public
    var replyQuery: String = ""

    public
    var action: String = ""

    public
    var intent: String = ""

    public
    var isQuestion: Bool = false

    public
    lazy var reply1: Reply = FakeTextReply(text: replyQuery)

    public
    lazy var reply2: Reply = FakeTextReply(text: replyQuery)

    public
    lazy var response = DialogAPIResponseFake(
        query: replyQuery,
        action: action,
        intent: intent,
        question: isQuestion,
        replies: [reply_1, reply_2]
    )

    public
    var skill1 = DialogAPICustomSkillFake()

    public
    var skill2 = DialogAPICustomSkillFake()

    public
    lazy var customSkills: [DialogAPICustomSkillFake] = [skill_1, skill_2]

    public
    override
    init() {
        super.init()
    }

    func send(request: DialogAPIRequestFake) throws -> DialogAPIResponseFake {

        if let error = errorState {
            throw error
        }

        sentQuery = request.query

        notify?(.success(.requestSent(request)))

        Thread.sleep(forTimeInterval: sendTimeout)

        return response
    }

    func createRequest(query: String) -> DialogAPIRequestFake {
        DialogAPIRequestFake(query: query)
    }

    var notify: (DialogAPICallback)?

    typealias TRequest = DialogAPIRequestFake

    typealias TResponse = DialogAPIResponseFake

    typealias TCustomSkill = DialogAPICustomSkillFake
}
