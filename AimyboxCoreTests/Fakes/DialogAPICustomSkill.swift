//
//  DialogAPICustomSkill.swift
//  AimyboxCoreTests
//
//  Created by Vladyslav Popovych on 15.12.2019.
//  Copyright © 2019 Just Ai. All rights reserved.
//

import Foundation
import AimyboxCore

class DialogAPICustomSkillFake: CustomSkill {

    public var onResponseHandler: ((DialogAPIResponseFake, Aimybox, (Response) -> ()) -> DialogAPIResponseFake)?

    public var onRequestHandler: ((DialogAPIRequestFake) -> DialogAPIRequestFake)?

    public var canHandle: Bool = false

    func onRequest(_ request: DialogAPIRequestFake) -> DialogAPIRequestFake {
        return onRequestHandler?(request) ?? request
    }

    func canHandle(response: DialogAPIResponseFake) -> Bool {
        return canHandle
    }

    func onResponse(_ response: DialogAPIResponseFake, _ aimybox: Aimybox, default handler: (Response) -> ()) -> DialogAPIResponseFake {
        return onResponseHandler?(response, aimybox, handler) ?? response
    }
}
