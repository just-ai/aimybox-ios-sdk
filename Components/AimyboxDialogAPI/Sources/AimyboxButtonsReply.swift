//
//  AimyboxButtonsReply.swift
//  AimyboxDialogAPI
//
//  Created by Vladislav Popovich on 20.12.2019.
//  Copyright © 2019 Just Ai. All rights reserved.
//

#if canImport(Aimybox)
import Aimybox

final public class AimyboxButton: Button, Decodable {
    
    public var text: String
    
    public var url: URL?
    
    public init(text: String, url: URL?) {
        self.text = text
        self.url = url
    }
}

final public class AimyboxButtonsReply: ButtonsReply, Decodable {

    public var buttons: [Button] {
        get { typedButtons.compactMap { $0 as Button } }
        set { typedButtons = newValue.compactMap { $0 as? AimyboxButton } }
    }
    
    public var typedButtons: [AimyboxButton]
    
    public init(buttons: [AimyboxButton]) {
        self.typedButtons = buttons
    }
    
    public enum CodingKeys: String, CodingKey {
        case typedButtons = "buttons"
    }
    
    static let jsonKey: String = "buttons"
}

#endif
