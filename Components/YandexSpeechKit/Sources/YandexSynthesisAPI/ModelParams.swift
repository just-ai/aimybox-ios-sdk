//
//  Emotion.swift
//  Aimybox
//
//  Created by Alexey Sakovykh on 25.05.2022.
//

import Foundation

enum VoiceModel : String {
    
    case general = "general"
    
}

enum Voice : String {
    
    case kuznetsov = "kuznetsov_male"
}

enum Speed : Double {
    
    case min = 0.1
    case max = 3.0
    case defaultVal = 1.0
    
}

enum Volume : Double {
    
    case min = -145.0
    case max = 0.0
    case defaultVal = -19.0
    
}
