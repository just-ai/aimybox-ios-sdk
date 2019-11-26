//
//  SFSpeechToText.swift
//  AimyboxCore
//
//  Created by Vladyslav Popovych on 30.11.2019.
//  Copyright © 2019 Just Ai. All rights reserved.
//

import AVFoundation
import Speech

public class SFSpeechToText: SpeechToTextProtocol {
    
    public let locale: Locale
    
    private let audioEngine: AVAudioEngine
    
    private var audioInputNode: AVAudioNode?
    
    private let speechRecognizer: SFSpeechRecognizer
    
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    
    private var recognitionTask: SFSpeechRecognitionTask?
    /**
     Default init that uses system locale.
    
     If locale is not supported, that init will fail.
     */
    public init?() {
        locale = Locale.current
        audioEngine = AVAudioEngine()
        guard let recognizer = SFSpeechRecognizer(locale: locale) else { return nil }
        speechRecognizer = recognizer
    }
    /**
     Init that uses provided locale.
    
     If locale is not supported, that init will fail.
     */
    public init?(locale: Locale) {
        self.locale = locale
        audioEngine = AVAudioEngine()
        guard let recognizer = SFSpeechRecognizer(locale: locale) else { return nil }
        speechRecognizer = recognizer
    }
    
    // MARK: - Locale management
    public class func supports(locale: Locale) -> Bool {
        return SFSpeechRecognizer.supportedLocales().contains(locale)
    }
    
    // MARK: - SpechToTextProtocol conformance

    public func startRecognition(_ completion: @escaping (Aimybox.SpeechToTextResult) -> ()) {

        checkPermissions { [weak self] result in
            switch result {
            case .complete:
                self?.prepareRecognition(completion)
                do {
                    try self?.audioEngine.start()
                } catch {
                    completion(.faillure(.microphoneUnreachable))
                }
                
            default:
                completion(result)
            }
        }
    }
    
    public func stopRecognition() {
        recognitionRequest?.endAudio()
        recognitionTask?.finish()
        audioEngine.stop()
        audioInputNode?.removeTap(onBus: 0)
        audioInputNode = nil
    }
    
    public func cancelRecognition() {
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
        recognitionTask = nil
        recognitionRequest = nil
        audioEngine.stop()
        audioInputNode?.removeTap(onBus: 0)
        audioInputNode = nil
    }
    // MARK: - Internals
    
    private func prepareRecognition(_ completion: @escaping (Aimybox.SpeechToTextResult) -> ()) {
        // Setup AudioSession for recording
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.record)
            try audioSession.setMode(.measurement)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            return completion(.faillure(.microphoneUnreachable))
        }
        // Setup Speech Recognition request
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest, speechRecognizer.isAvailable else {
            return completion(.faillure(.speechRecognitionUnavailable))
        }
        recognitionRequest.shouldReportPartialResults = true
        // Get the a task, so we can cancel it
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
            var isFinal = false
            
            if let result = result {
                isFinal = result.isFinal
            }
            
            if error != nil || isFinal {
            }
        }
        // Link recognition request with audio stream
        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { [weak self] buffer, _ in
            self?.recognitionRequest?.append(buffer)
        }
        audioInputNode = inputNode
        audioEngine.prepare()
    }
    
    // MARK: - User Permissions
    private func checkPermissions(_ completion: @escaping (Aimybox.SpeechToTextResult) -> Void ) {
        
        var recordAllowed: Bool = false
        var recognitionAllowed: Bool = false
        let permissionsDispatchGroup = DispatchGroup()
    
        permissionsDispatchGroup.enter()
        DispatchQueue.main.async {
            // Microphone recording permission
            AVAudioSession.sharedInstance().requestRecordPermission { isAllowed in
                recordAllowed = isAllowed
                permissionsDispatchGroup.leave()
            }
        }
        
        permissionsDispatchGroup.enter()
        DispatchQueue.main.async {
            // Speech recognizer permission
            SFSpeechRecognizer.requestAuthorization { status in
                recognitionAllowed = status == .authorized
                permissionsDispatchGroup.leave()
            }
        }
        
        permissionsDispatchGroup.notify(queue: .main) {
            switch (recordAllowed, recognitionAllowed) {
            case (true, true):
                completion(.complete)
            case (false, true):
                completion(.faillure(.microphonePermissionReject))
            case (_, false):
                completion(.faillure(.speechRecognitionPermissionReject))
            }
        }
    }
}
