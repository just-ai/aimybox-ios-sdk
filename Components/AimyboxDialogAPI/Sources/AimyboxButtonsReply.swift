//
//  AimyboxButtonsReply.swift
//  AimyboxDialogAPI
//
//  Created by Vladislav Popovich on 20.12.2019.
//  Copyright © 2019 Just Ai. All rights reserved.
//

#if canImport(Aimybox)
import Aimybox

final public class AimyboxButtonReply: ButtonReply, Decodable {
    
    public var text: String
    
    public var url: URL?
    
    public init(text: String, url: URL?) {
        self.text = text
        self.url = url
    }
}

final public class AimyboxButtonsReply: ButtonsReply, Decodable {

    public var buttons: [ButtonReply] {
        get { typedButtons.compactMap { $0 as ButtonReply } }
        set { typedButtons = newValue.compactMap { $0 as? AimyboxButtonReply } }
    }
    
    public var typedButtons: [AimyboxButtonReply]
    
    public init(buttons: [AimyboxButtonReply]) {
        self.typedButtons = buttons
    }
    
    public enum CodingKeys: String, CodingKey {
        case typedButtons = "buttons"
    }
    
    static let jsonKey: String = "buttons"
}

#endif
