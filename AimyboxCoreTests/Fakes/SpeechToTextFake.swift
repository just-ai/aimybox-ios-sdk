//
//  SpeechToTextFake.swift
//  AimyboxCoreTests
//
//  Created by Vladyslav Popovych on 15.12.2019.
//  Copyright © 2019 Just Ai. All rights reserved.
//

import Foundation
import AimyboxCore

class SpeechToTextFake: AimyboxComponent, SpeechToText {
    
    public var partialResult: String = "Ping"
    
    public var partialResultCount: Int = 3
    
    public var finalResult: String = "Ping-Pong"
    
    public var errorState: SpeechToTextError?
    
    func startRecognition() {
        guard errorState == nil else {
            if let error = self.errorState {
                operationQueue.addOperation { [weak self] in
                    self?.notify?(.failure(error))
                }
            }
            return
        }
        
        let partialResult = self.partialResult
        let finalResult = self.finalResult
        let partialResultCount = self.partialResultCount
        
        operationQueue.addOperation { [weak self] in
            self?.notify?(.success(.recognitionStarted))
            
            (1...partialResultCount).forEach { index in
                self?.operationQueue.underlyingQueue?.asyncAfter(deadline: .now() + 0.25*Double(index)) { [weak self] in
                    self?.operationQueue.addOperation {
                        self?.notify?(.success(.recognitionPartialResult("\(partialResult): \(index)")))
                    }
                }
            }

            self?.operationQueue.underlyingQueue?.asyncAfter(
                deadline: .now() + 0.25*Double(partialResultCount+1))
            { [weak self] in
                self?.operationQueue.addOperation {
                    self?.notify?(
                        .success(
                            finalResult.isEmpty ? .emptyRecognitionResult : .recognitionResult(finalResult)
                        )
                    )
                }
            }
        }
    }
    
    func stopRecognition() {
        let finalResult = self.finalResult
        operationQueue.addOperation { [weak self] in
            self?.notify?(.success(.recognitionResult(finalResult)))
        }
    }
    
    func cancelRecognition() {
        operationQueue.addOperation { [weak self] in
            self?.notify?(.success(.recognitionCancelled))
        }
    }
    
    var notify: (SpeechToTextCallback)?
}
