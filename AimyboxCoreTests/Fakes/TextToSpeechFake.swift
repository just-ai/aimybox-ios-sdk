//
//  TextToSpeechFake.swift
//  AimyboxCoreTests
//
//  Created by Vladyslav Popovych on 15.12.2019.
//  Copyright © 2019 Just Ai. All rights reserved.
//

import AimyboxCore
import Foundation

class TextToSpeechFake: AimyboxComponent, TextToSpeech {

    var currentSpeech: [AimyboxSpeech]?

    var errorState: TextToSpeechError?

    func synthesize(contentsOf speeches: [AimyboxSpeech]) {
        if let error = errorState {
            notify?(.failure(error))
            return
        }

        currentSpeech = speeches
        operationQueue.addOperation { [weak self] in

            self?.notify?(.success(.speechSequenceStarted(speeches)))

            speeches.forEach { speech in
                self?.notify?(.success(.speechStarted(speech)))
                guard speech.isValid() else {
                    self?.notify?(.success(.speechSkipped(speech)))
                    self?.notify?(.failure(.emptySpeech(speech)))
                    return
                }
                Thread.sleep(forTimeInterval: 2.5)
                self?.notify?(.success(.speechEnded(speech)))
            }

            self?.notify?(.success(.speechSequenceCompleted(speeches)))
        }
        operationQueue.waitUntilAllOperationsAreFinished()
        currentSpeech = nil
    }

    func stop() {
        cancelRunningOperation()
        operationQueue.addOperation { [weak self] in
            if let _currentSpeech = self?.currentSpeech {
                self?.currentSpeech = nil
                self?.notify?(.failure(.speechSequenceCancelled(_currentSpeech)))
            }
        }
    }

    var notify: (TextToSpeechCallback)?
}
