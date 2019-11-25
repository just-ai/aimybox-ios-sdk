//
//  AimyboxState.swift
//  AimyboxCore
//
//  Created by Vladyslav Popovych on 25.11.2019.
//  Copyright © 2019 Just Ai. All rights reserved.
//

import Foundation

public extension Aimybox {
    /**
     Lifecycle states, used by *Aimybox* state machine.
     */
    enum State {
        /**
         Voice assistant is ready to work.
         
         *SpeechToText* and *TextToSpeech* components are inactive.

         *DialogApi* component doesn't process any request.

         If *VoiceTrigger* component was configured, it's active and detects a hot word holding the microphone.
         */
        case standby
        /**
         Voice assistant listens for the user's speech.
         
         *SpeechToText* component is active and uses a microphone.
         
         *VoiceTrigger* and *TextToSpeech* are inactive.
         
         *DialogApi* component doesn't process any request.
         */
        case listening
        /**
         Voice assistant recognises the intent from user's speech.
         
         *DialogApi* makes request to the NLU engine sending the recognised user's query.
         Then looks for any *CustomSkill* that can handle this intent.
         
         *SpeechToText*, *TextToSpeech* and *VoiceTrigger* are inactive.
         */
        case processing
        /**
         Voice assistant synthesises the output speech to the user.
         
         All components excepting *TextToSpeech* are inactive.
         */
        case speaking
    }
}
