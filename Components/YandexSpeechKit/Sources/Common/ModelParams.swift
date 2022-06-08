//
//  Emotion.swift
//  Aimybox
//
//  Created by Alexey Sakovykh on 25.05.2022.
//

import Foundation

public
enum VoiceModel: String {
    case general
}

public
enum Voice: String {

    case kuznetsov = "kuznetsov_male"
}

public
enum Speed {

    case min, max, defaultValue
    case currentValue(Double)

    var value: Double {
        switch self {
        case .min:
            return 0.1
        case .max:
            return 3.0
        case .defaultValue:
            return 1.0
        case .currentValue(let speed):
            if speed < 0.1 {
                return 0.1
            } else if speed > 3.0 {
                return 3.0
            } else {
                return speed
            }
        }
    }

}

public
enum Volume {

    case min, max, defaultValue
    case currentValue(Double)

    var value: Double {
        switch self {
        case .min:
            return -145.1
        case .max:
            return 0.0
        case .defaultValue:
            return -19.0
        case .currentValue(let volume):
            if volume < -145.0 {
                return -145.0
            } else if volume > 0.0 {
                return 0.0
            } else {
                return volume
            }
        }
    }

}
