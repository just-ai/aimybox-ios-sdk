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
    
    typealias TRequest = DialogAPIRequestFake
    typealias TResponse = DialogAPIResponseFake
    
    func onRequest(_ request: DialogAPIRequestFake) -> DialogAPIRequestFake {
        return request
    }
    
    func canHandle(response: DialogAPIResponseFake) -> Bool {
        return false
    }
    
    func onResponse(_ response: DialogAPIResponseFake, _ aimybox: Aimybox, default handler: (Response) -> ()) -> DialogAPIResponseFake {
        return response
    }
}
