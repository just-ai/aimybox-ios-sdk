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
        recordButton.isHidden = true
        aimybox.startRecognition()
    }
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recognizedTextView: UITextView!
    internal var recognizedText: String = "" {
        didSet {
            if isViewLoaded {
                DispatchQueue.main.async { [weak self] in
                    self?.recognizedTextView.text = self?.recognizedText
                }
            }
        }
    }
    
    let aimybox: Aimybox = {
        let locale = Locale(identifier: "ru")
        
        guard let speechToText = SFSpeechToText(locale: locale) else {
            fatalError("Locale is not supported.")
        }
        guard let textToSpeech = AVTextToSpeech(locale: locale) else {
            fatalError("Locale is not supported.")
        }
        
        let config = Aimybox.Config(speechToText: speechToText,
                                    textToSpeech: textToSpeech)
        let aimybox = Aimybox(with: config)
        return aimybox
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        aimybox.delegate = self
        recognizedTextView.text = "Нажми кнопку 'RECORD' и говори."
    }
}

extension ViewController: AimyboxDelegate {
    
    func stt(_ stt: SpeechToText, recognitionPartial result: String) {
        recognizedText = result
    }
    
    func stt(_ stt: SpeechToText, recognitionFinal result: String) {
        recognizedText = result
        aimybox.synthesize([
            TextSpeech(text: "Я повторю то что ты сказал"),
            TextSpeech(text: result)
        ])
    }
    
    func tts(_ tts: TextToSpeech, speechEnded speech: AimyboxSpeech) {
        DispatchQueue.main.async { [weak self] in
            self?.recordButton.isHidden = false
        }
    }
}
