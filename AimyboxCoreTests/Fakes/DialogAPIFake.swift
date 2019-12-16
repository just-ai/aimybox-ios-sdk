//
//  DialogAPIFake.swift
//  AimyboxCoreTests
//
//  Created by Vladyslav Popovych on 15.12.2019.
//  Copyright © 2019 Just Ai. All rights reserved.
//

import Foundation
import AimyboxCore

class DialogAPIFake: AimyboxComponent, DialogAPI {
    
    public override init() {
        super.init()
    }
    
    func send(request: DialogAPIRequestFake) throws -> DialogAPIResponseFake {
        return DialogAPIResponseFake(query: "", action: "", intent: "", question: false, replies: [])
    }
    
    var customSkills: [DialogAPICustomSkillFake] = []
    
    func createRequest(query: String) -> DialogAPIRequestFake {
        return DialogAPIRequestFake(query: query)
    }
    
    var notify: (DialogAPICallback)?
    
    typealias TRequest = DialogAPIRequestFake
    
    typealias TResponse = DialogAPIResponseFake
    
    typealias TCustomSkill = DialogAPICustomSkillFake
}
