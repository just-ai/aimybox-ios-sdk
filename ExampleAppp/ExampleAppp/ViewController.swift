//
//  ViewController.swift
//  ExampleAppp
//
//  Created by Vladyslav Popovych on 23.11.2019.
//  Copyright © 2019 Just Ai. All rights reserved.
//

import UIKit
import Aimybox

class ViewController: UIViewController, UITableViewDelegate {
    
    @IBAction func onRecordTap(_ sender: UIButton) {
        aimybox.startRecognition()
    }
    
    let aimybox: Aimybox = {
        let speechToText = SFSpeechToText()
        let config = Aimybox.Config(speechToText: speechToText)
        let aimybox = Aimybox(with: config)
        return aimybox
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        aimybox.delegate = self
    }
}

extension ViewController: AimyboxDelegate {
    func aimybox(_ aimybox: Aimybox, willMoveFrom oldState: Aimybox.State, to newState: Aimybox.State) {
        debugPrint("old State: \(oldState), new State: \(newState)")
    }
    
    func aimybox(_ aimybox: Aimybox, didStartRecognition result: Aimybox.SpeechToTextResult) {
        debugPrint(result)
    }
}
