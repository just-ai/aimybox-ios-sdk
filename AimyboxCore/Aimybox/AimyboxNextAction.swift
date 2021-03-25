//
//  AimyboxNextAction.swift
//  AimyboxCore
//
//  Created by Vladyslav Popovych on 15.12.2019.
//  Copyright © 2019 Just Ai. All rights reserved.
//

import Foundation

/**
Defines what will happens once speech synthesis is completed.
*/
public enum AimyboxNextAction {
    /**
    Go to standby state.
    */
    case standby
    /**
    Start speech recognition.
    */
    case recognition
    /**
    Do nothing after synthesis.
    - Important: This constant is intended primarily for usage in a `CustomSkill`.
    It will not start the voice trigger after the synthesis, so your app may enter to a non-interactive state.
    */
    case nothing
    /**
    If the speech is a question, it is obviously to start speech recognition after synthesis.
    On the other hand, if the speech does not imply an answer, it is logical to go to `standby` state.
    */
    static func byQuestion(is question: Bool) -> AimyboxNextAction {
        question ? .recognition : .standby
    }
}
