//
//  TextToSpeechFake.swift
//  AimyboxCoreTests
//
//  Created by Vladyslav Popovych on 15.12.2019.
//  Copyright © 2019 Just Ai. All rights reserved.
//

import Foundation
import AimyboxCore

class TextToSpeechFake: TextToSpeech {
    func synthesize(contentsOf speeches: [AimyboxSpeech], completion: (TextToSpeechResult) -> ()) {
        return
    }
    
    func synthesize(contentsOf speeches: [AimyboxSpeech]) {
    }
    
    func stop() {
    }
    
    var notify: (TextToSpeechCallback)?
}
