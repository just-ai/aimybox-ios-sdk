//
//  ViewController.swift
//  sdk-sample-app
//
//  Created by Vladyslav Popovych on 21.12.2019.
//  Copyright © 2019 Just Ai. All rights reserved.
//

import UIKit
import AimyboxCore
import AimyboxDialogAPI
import AVTextToSpeech
import SFSpeechToText

class ViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    internal var recognizedText: String = "" {
        didSet {
            DispatchQueue.main.async { [weak self] in
                if self?.isViewLoaded == .some(true) {
                    self?.textView.text = self?.recognizedText
                }
            }
        }
    }
    @IBAction func startRecognition(_ sender: UIButton) {
        aimybox.startRecognition()
    }
    
    let aimybox: Aimybox = {
        let locale = Locale(identifier: "ru")
        
        guard let speechToText = SFSpeechToText(locale: locale) else {
            fatalError("Locale is not supported.")
        }
        guard let textToSpeech = AVTextToSpeech(locale: locale) else {
            fatalError("Locale is not supported.")
        }
        
        let dialogAPI = AimyboxDialogAPI(api_key: "sgEfvEonbLOTw6wTEaINZb6zehab8RQF",
                                         unit_key: UIDevice.current.identifierForVendor!.uuidString)
        
        let config = AimyboxBuilder.config(speechToText, textToSpeech, dialogAPI)
        
        return AimyboxBuilder.aimybox(with: config)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        aimybox.delegate = self
    }
}

extension ViewController: AimyboxDelegate {
    func aimybox(_ aimybox: Aimybox, willMoveFrom oldState: AimyboxState, to newState: AimyboxState) {
        print(#function, oldState, newState)
    }
    func stt(_ stt: SpeechToText, recognitionPartial result: String) {
        recognizedText = result
    }
    func stt(_ stt: SpeechToText, recognitionFinal result: String) {
        recognizedText = result
    }
    func dialogAPI(response received: Response) {
        print(received.query)
    }
}
