//
//  AimyboxTextReply.swift
//  AimyboxDialogAPI
//
//  Created by Vladislav Popovich on 20.12.2019.
//  Copyright © 2019 Just Ai. All rights reserved.
//

#if COCOAPODS
#else
import AimyboxCore
#endif

final public class AimyboxTextReply: TextReply, Decodable {
    
    public var text: String
    
    public var tts: String?
    
    public var language: String?
    
    public init(text: String, tts: String?, language: String?) {
        self.text = text
        self.tts = tts
        self.language = language
    }
    
    public enum CodingKeys: String, CodingKey {
        case text
        case tts
        case language = "lang"
    }
    
    static let jsonKey: String = "text"
}
