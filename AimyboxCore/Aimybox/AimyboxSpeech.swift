//
//  AimyboxSpeech.swift
//  Aimybox
//
//  Created by Vladyslav Popovych on 01.12.2019.
//

import Foundation

/**
Base protocol for any speeches.
*/
public
protocol AimyboxSpeech {

    func isValid() -> Bool

}

/**
Text to be spoken.
*/
public
class TextSpeech: AimyboxSpeech {

    public
    let text: String

    public
    init(text: String) {
        self.text = text
    }

    public
    func isValid() -> Bool {
        !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

public
class AudioSpeech: AimyboxSpeech {
    /**
    URL to the audio source.
    */
    public
    let audioURL: URL

    public
    init(audioURL: URL) {
        self.audioURL = audioURL
    }
    /**
    If url is valid, it's synthesizers task to check if it could play it.
    */
    public
    func isValid() -> Bool {
        true
    }

}
