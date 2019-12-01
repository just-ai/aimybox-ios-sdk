//
//  SFSpeechToText.swift
//  AimyboxCore
//
//  Created by Vladyslav Popovych on 30.11.2019.
//  Copyright © 2019 Just Ai. All rights reserved.
//

import AVFoundation
import Speech

public class SFSpeechToText: SpeechToText {
    /**
     Locale of recognizer.
     */
    public let locale: Locale
    /**
     Used to notify *Aimybox* state machine about events.
     */
    public var notify: (SpeechToTextCallback)?
    /**
     Used for audio signal processing.
     */
    private let audioEngine: AVAudioEngine
    /**
     Node on which audio stream is routed.
     */
    private var audioInputNode: AVAudioNode?
    /**
     Actual iOS speech recognizer.
     */
    private let speechRecognizer: SFSpeechRecognizer
    /**
     Retained for a purpose of controling audio stream routed to recognizer.
     */
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    /**
     Speech recognition task itself.
     */
    private var recognitionTask: SFSpeechRecognitionTask?
    /**
     Debouncer used to controll delay time of aquiring final results of speech recognizing process.
     */
    private var recognitionDebouncer: DispatchDebouncer
    /**
     Debounce delay in seconds. HIgher values results in higher lag between partial and final results.
     */
    private let recognitionDebounceDelay: TimeInterval = 3.0
    /**
     Default init that uses system locale.
     
     If locale is not supported, that init will fail.
     */
    public init?() {
        locale = Locale.current
        audioEngine = AVAudioEngine()
        guard let recognizer = SFSpeechRecognizer(locale: locale) else { return nil }
        recognizer.defaultTaskHint = .search
        speechRecognizer = recognizer
        recognitionDebouncer = DispatchDebouncer()
    }
    /**
     Init that uses provided locale.
     
     If locale is not supported, that init will fail.
     */
    public init?(locale: Locale) {
        self.locale = locale
        audioEngine = AVAudioEngine()
        guard let recognizer = SFSpeechRecognizer(locale: locale) else { return nil }
        recognizer.defaultTaskHint = .search
        speechRecognizer = recognizer
        recognitionDebouncer = DispatchDebouncer()
    }
    
    // MARK: - Locale management
    
    public class func supports(locale: Locale) -> Bool {
        return SFSpeechRecognizer.supportedLocales().contains(locale)
    }
    
    // MARK: - SpechToTextProtocol conformance
    
    public func startRecognition() {
        
        checkPermissions { [weak self] result in
            switch result {
            case .success:
                self?.onPermissionGranted()
            default:
                self?.notify?(result)
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
        if recognitionTask?.state != .some(.completed) {
            notify?(.success(.recognitionCancelled))
        }
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
        recognitionTask = nil
        recognitionRequest = nil
        audioEngine.stop()
        audioInputNode?.removeTap(onBus: 0)
        audioInputNode = nil
    }
    
    // MARK: - Internals
    
    private func onPermissionGranted() {
        prepareRecognition()
        do {
            try audioEngine.start()
            notify?(.success(.recognitionStarted))
        } catch {
            notify?(.failure(.microphoneUnreachable))
        }
    }
    
    private func prepareRecognition() {
        guard let _notify = notify else { return }
        
        // Setup AudioSession for recording
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.record)
            try audioSession.setMode(.measurement)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            return _notify(.failure(.microphoneUnreachable))
        }
        // Setup Speech Recognition request
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest, speechRecognizer.isAvailable else {
            return _notify(.failure(.speechRecognitionUnavailable))
        }
        recognitionRequest.shouldReportPartialResults = true
        // Get the a task, so we can cancel it
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { [weak self] result, error in
            guard error == nil else {
                return _notify(.failure(.speechRecognitionUnavailable))
            }
            
            if let _result = result {
                self?.proccessResults(result: _result)
            } else {
                _notify(.success(.emptyRecognitionResult))
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
    
    private func proccessResults(result: SFSpeechRecognitionResult) {
        
        guard result.isFinal == true else {
            let partialResult = result.bestTranscription.formattedString
            notify?(.success(.recognitionPartialResult(partialResult)))
            
            recognitionDebouncer.debounce(delay: recognitionDebounceDelay) { [weak self] in
                self?.recognitionTask?.finish()
            }
            return
        }
        
        let finalResult = result.bestTranscription.formattedString.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard finalResult.isEmpty == false else {
            notify?(.success(.emptyRecognitionResult))
            return
        }
        
        notify?(.success(.recognitionResult(finalResult)))
    }
    
    // MARK: - User Permissions
    private func checkPermissions(_ completion: @escaping (SpeechToTextResult) -> Void ) {
        
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
                completion(.success(.recognitionPermissionsGranted))
            case (false, true):
                completion(.failure(.microphonePermissionReject))
            case (_, false):
                completion(.failure(.speechRecognitionPermissionReject))
            }
        }
    }
}
