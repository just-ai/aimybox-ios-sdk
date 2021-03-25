//
//  TextReply.swift
//  Aimybox
//
//  Created by Vladyslav Popovych on 07.12.2019.
//

import Foundation

/**
Represents a reply with text content, which should be synthesized and/or displayed in the UI.
*/
public
protocol TextReply: Reply {
    /**
    Text to show in the UI. Also, this text should be synthesized, if `tts` text is null.
    */
    var text: String { get }
    /**
    Text to be synthesized. Can include SSML and other markup, and therefore it should not be displayed in UI.
    */
    var tts: String? { get }
    /**
    The language code of the reply.
    */
    var language: String? { get }

}

public
extension TextReply {

    var textSpeech: TextSpeech {
        TextSpeech(text: tts ?? text)
    }

}
