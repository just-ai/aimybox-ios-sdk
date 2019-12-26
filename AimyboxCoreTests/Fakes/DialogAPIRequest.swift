//
//  DialogAPIRequest.swift
//  AimyboxCoreTests
//
//  Created by Vladyslav Popovych on 15.12.2019.
//  Copyright © 2019 Just Ai. All rights reserved.
//

import Foundation
import AimyboxCore

class DialogAPIRequestFake: Request {
    
    public init(query: String) {
        self.query = query
    }
    
    var query: String
}
