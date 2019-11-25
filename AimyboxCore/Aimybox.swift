//
//  Aimybox.swift
//  AimyboxCore
//
//  Created by Vladyslav Popovych on 23.11.2019.
//  Copyright © 2019 Just Ai. All rights reserved.
//

import Foundation

public class Aimybox {
    
    public private(set) var state: Aimybox.State {
        willSet {
            debugPrint("Transition from \(state) to \(newValue)")
        }
    }

    private init() {
        state = .standby
    }
    
    public convenience init(foo bar: String/*WIP*/) {
        self.init()
    }
    
    public func standby() {
        state = .standby
    }
    
    public func cancelRecognition() {
        guard case .listening = state else {
            return
        }
        
        standby()
    }
    
    public func startRecognition() {
        state = .listening
    }
}
