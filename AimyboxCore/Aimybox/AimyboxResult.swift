//
//  AimyboxResult.swift
//  AimyboxCore
//
//  Created by Vladyslav Popovych on 30.11.2019.
//  Copyright © 2019 Just Ai. All rights reserved.
//

import Foundation

/**
 Used to support versions of swift < 5.0.
 */
public enum AimyboxResult<T, E> where E: Error {
    case success(T)
    case failure(E)
}

public typealias SpeechToTextResult = AimyboxResult<SpeechToTextEvent, SpeechToTextError>

public typealias TextToSpeechResult = AimyboxResult<TextToSpeechEvent, TextToSpeechError>

public typealias DialogAPIResult = AimyboxResult<DialogAPIEvent, DialogAPIError>
