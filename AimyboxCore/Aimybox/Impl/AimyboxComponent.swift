//
//  AimyboxComponent.swift
//  Aimybox
//
//  Created by Vladyslav Popovych on 08.12.2019.
//

import AVFoundation

/**
Base class that provides async behavior.
*/
open
class AimyboxComponent {
    /**
    Background, serial queue for component operations.
    */
    public
    var operationQueue: OperationQueue
    /**
    Desigated initializer that creates op queue for component.
     
    - Note: If you ovveride `init()` in sub-class, you must call super.init().
    */
    public
    init() {
        let queue = DispatchQueue(label: "com.justai.aimybox-\("\(type(of: self))".lowercased())-thread")
        let opQueue = OperationQueue()
        opQueue.maxConcurrentOperationCount = 1
        opQueue.underlyingQueue = queue
        operationQueue = opQueue
    }

    var hasRunningOperations: Bool {
        operationQueue.operationCount != 0
    }

    public
    func cancelRunningOperation() {
        if hasRunningOperations {
            operationQueue.cancelAllOperations()
        }
    }

    func prepareAudioEngineForMultiRoute(_ completion: (Bool) -> Void) {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setMode(.default)

            try audioSession.setCategory(
                .playAndRecord,
                options: [.allowBluetoothA2DP, .defaultToSpeaker]
            )

            if audioSession.isOtherAudioPlaying {
                try audioSession.setActive(true, options: [.notifyOthersOnDeactivation])
            }

            completion(true)
        } catch {
            completion(false)
        }
    }

}

public
extension Array where Element == AimyboxSpeech {

    var unwrapSSML: [Element] {
        var unwrapped = [Element]()
        forEach { elem in
            if let textSpeech = elem as? TextSpeech {
                SSMLDecoder().decode(textSpeech.text).forEach {
                    unwrapped.append($0)
                }
            } else {
                unwrapped.append(elem)
            }
        }
        return unwrapped
    }

}
