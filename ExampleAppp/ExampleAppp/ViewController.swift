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
        guard let speechToText = SFSpeechToText() else { fatalError("Locale not supported.") }
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
    func aimybox(_ aimybox: Aimybox, recognitionPartialResult: Aimybox.SpeechToTextEvent) {
        switch recognitionPartialResult {
        case .recognitionPartialResult(let string):
            print(string)
        default:
            break
        }
    }
}
