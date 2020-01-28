//
//  YandexSpeechToText.swift
//  YandexSpeechKit
//
//  Created by Vladislav Popovich on 28.01.2020.
//  Copyright © 2020 Just Ai. All rights reserved.
//

import AVFoundation
import Foundation
#if canImport(Aimybox)
import Aimybox

public class YandexSpeechToText: AimyboxComponent, SpeechToText {
    /**
     Customize `config` parameter if you change recognition audioFormat.
     */
    public var audioFormat: AVAudioFormat = .defaultFormat
    
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
     */
    private var recognitionAPI: YandexRecognitionAPI!
    /**
     Init that uses provided params.
     */
    public init?(
        passport oAuhtToken: String,
        folderID: String,
        language code: String = "ru-RU",
        iAmTokenAPIURL: URL = URL(string: "https://iam.api.cloud.yandex.net/iam/v1/tokens")!,
        sttAPIAdress: String = "stt.api.cloud.yandex.net:443",
        config: Yandex_Cloud_Ai_Stt_V2_RecognitionConfig? = nil
    ) {
        let token = IAMTokenGenerator.token(api: iAmTokenAPIURL,
                                            passport: oAuhtToken)
        
        guard let iamToken = token?.iamToken else {
            return nil
        }
        
        audioEngine = AVAudioEngine()
        
        super.init()
        
        recognitionAPI = YandexRecognitionAPI(iAM: iamToken,
                                              folderID: folderID,
                                              language: code,
                                              api: sttAPIAdress,
                                              config: config,
                                              operation: operationQueue)
    }
    
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
        audioEngine.stop()
        audioInputNode?.removeTap(onBus: 0)
        audioInputNode = nil
        stream?.cancel()
        try? stream?.closeSend { }
    }
    
    public func cancelRecognition() {
        audioEngine.stop()
        audioInputNode?.removeTap(onBus: 0)
        audioInputNode = nil
        operationQueue.addOperation { [weak self] in
            try? self?.stream?.closeSend { }
            if self?.stream != nil {
                self?.notify?(.success(.recognitionCancelled))
            }
            self?.stream = nil
        }
    }
     
    // MARK: - Internals
    
    private weak var stream: Yandex_Cloud_Ai_Stt_V2_SttServiceStreamingRecognizeCall?
    
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
        
        recognitionAPI.openStream(onOpen: { [audioEngine, weak self, audioFormat] (stream) in
            
            let inputNode = audioEngine.inputNode
            let recordingFormat = audioFormat
            inputNode.removeTap(onBus: 0)
            inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { [stream] buffer, time in
                try? stream.send(
                    Yandex_Cloud_Ai_Stt_V2_StreamingRecognitionRequest.with({ request in
                        guard let _bytes = buffer.int16ChannelData else { return }
                        
                        let channels = UnsafeBufferPointer(start: _bytes, count: Int(audioFormat.channelCount))
                        
                        request.audioContent = Data(bytesNoCopy: channels[0],
                                               count: Int(buffer.frameCapacity*audioFormat.streamDescription.pointee.mBytesPerFrame),
                                               deallocator: .none)
                    })
                )
                self?.stream = stream
            }
            
            self?.audioInputNode = inputNode
            audioEngine.prepare()
            
        }, onResponse: { [weak self] response in
            
            self?.proccessResults(response)
            
        }, error: { (error) in
            
            _notify(.failure(.speechRecognitionUnavailable))
            
        }, completion: { [weak self] in
            
            self?.stopRecognition()
        })
    }
    
    private func proccessResults(_ response: Yandex_Cloud_Ai_Stt_V2_StreamingRecognitionResponse) {
        
        guard let phrase = response.chunks.first, let bestAlternative = phrase.alternatives.first else {
            return
        }

        guard phrase.final == true else {
            notify?(.success(.recognitionPartialResult(bestAlternative.text)))
            return
        }
        
        let finalResult = bestAlternative.text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard finalResult.isEmpty == false else {
            notify?(.success(.emptyRecognitionResult))
            return
        }
        
        notify?(.success(.recognitionResult(finalResult)))
    }

    // MARK: - User Permissions
    private func checkPermissions(_ completion: @escaping (SpeechToTextResult) -> Void ) {
        
        var recordAllowed: Bool = false
        let permissionsDispatchGroup = DispatchGroup()
        
        permissionsDispatchGroup.enter()
        DispatchQueue.main.async {
            // Microphone recording permission
            AVAudioSession.sharedInstance().requestRecordPermission { isAllowed in
                recordAllowed = isAllowed
                permissionsDispatchGroup.leave()
            }
        }
        
        permissionsDispatchGroup.notify(queue: .main) {
            if recordAllowed {
                completion(.success(.recognitionPermissionsGranted))
            } else {
                completion(.failure(.microphonePermissionReject))
            }
        }
    }
}

extension AVAudioFormat {
    static var defaultFormat: AVAudioFormat {
        AVAudioFormat(commonFormat: .pcmFormatInt16,
                      sampleRate: 44100,
                      channels: 1,
                      interleaved: false)!
    }
}

#endif
