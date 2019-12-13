//
//  AimyboxResponse.swift
//  Aimybox
//
//  Created by Vladislav Popovich on 13.12.2019.
//

import Foundation

public class AimyboxResponse: Response {
    public var query: String = ""
    
    public var action: String = ""
    
    public var intent: String = ""
    
    public var question: Bool = false
    
    public var replies: [Reply] = []
}
