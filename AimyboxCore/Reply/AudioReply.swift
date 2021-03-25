//
//  AudioReply.swift
//  Aimybox
//
//  Created by Vladyslav Popovych on 07.12.2019.
//

import Foundation

/**
Represents a reply with audio content, which should be played.
*/
public
protocol AudioReply: Reply {
    /**
    URL to the audio source.
    */
    var url: URL { get }

}

public
extension AudioReply {

    var audioSpeech: AudioSpeech {
        AudioSpeech(audioURL: url)
    }

}
