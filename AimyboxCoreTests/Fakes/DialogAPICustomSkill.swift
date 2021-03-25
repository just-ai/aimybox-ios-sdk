//
//  DialogAPICustomSkill.swift
//  AimyboxCoreTests
//
//  Created by Vladyslav Popovych on 15.12.2019.
//  Copyright © 2019 Just Ai. All rights reserved.
//

import AimyboxCore
import Foundation

class DialogAPICustomSkillFake: CustomSkill {

    public var onResponseHandler: ((DialogAPIResponseFake, Aimybox, (Response) -> Void) -> DialogAPIResponseFake)?

    public var onRequestHandler: ((DialogAPIRequestFake) -> DialogAPIRequestFake)?

    public var canHandle: Bool = false

    func onRequest(_ request: DialogAPIRequestFake) -> DialogAPIRequestFake {
        onRequestHandler?(request) ?? request
    }

    func canHandle(response: DialogAPIResponseFake) -> Bool {
        canHandle
    }

    func onResponse(
        _ response: DialogAPIResponseFake,
        _ aimybox: Aimybox,
        default handler: (Response) -> Void
    ) -> DialogAPIResponseFake {
        onResponseHandler?(response, aimybox, handler) ?? response
    }
}
