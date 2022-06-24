//
//  Request.swift
//  Aimybox
//
//  Created by Vladyslav Popovych on 07.12.2019.
//

import Foundation

/**
Request model, which is used across the library.
You can extend it by adding some fields to `data` JSON in `CustomSkill` or custom `DialogApi`.
*/
public
protocol Request {
    /**
    User input, recognized by STT or manually entered.
    */
    var query: String { get }

}
