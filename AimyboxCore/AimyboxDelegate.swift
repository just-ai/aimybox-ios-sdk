//
//  Utils.swift
//  AimyboxCore
//
//  Created by Vladyslav Popovych on 30.11.2019.
//  Copyright © 2019 Just Ai. All rights reserved.
//

import Foundation

public protocol AimyboxDelegate: class {

    func aimybox(_ aimybox: Aimybox, willMoveFrom oldState: Aimybox.State, to newState: Aimybox.State)
    
    func aimybox(_ aimybox: Aimybox, recieve speechToTextResult: Aimybox.SpeechToTextResult)
}
