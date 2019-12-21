//
//  DialogAPIHandleOperation.swift
//  Aimybox
//
//  Created by Vladislav Popovich on 13.12.2019.
//

import Foundation

class DialogAPIHandleOperation<TDialogAPI: DialogAPI>: Operation {
    /**
     */
    private var response: TDialogAPI.TResponse
    /**
    */
    private var dialogAPI: TDialogAPI
    /**
    */
    private var aimybox: Aimybox
    /**
     */
    public private(set) var result: TDialogAPI.TResponse?
    
    public init(response: TDialogAPI.TResponse, dialogAPI: TDialogAPI, aimybox: Aimybox) {
        self.response = response
        self.dialogAPI = dialogAPI
        self.aimybox = aimybox
    }
    
    override public func main() {
        
        let skill = dialogAPI.customSkills.first { $0.canHandle(response: response) }
        
        if let _skill = skill {
            let _ = _skill.onResponse(response, aimybox) { [weak self] response in
                self?.defaultHandler(response: response, aimybox: aimybox)
            }
        } else {
            defaultHandler(response: response, aimybox: aimybox)
        }
    }
    
    private func defaultHandler(response: Response, aimybox: Aimybox) {
        
        let supportedReplies: (Reply) -> Bool = { $0 is TextReply || $0 is AudioReply }
        
        do {
            try throwIfCanceled()
            
            let lastReply = response.replies.last(where: supportedReplies)
            
            try response.replies.filter(supportedReplies).forEach { reply in
                
                try throwIfCanceled()
                
                let speech: AimyboxSpeech = try {
                    if let textReply = reply as? TextReply {
                        return textReply.textSpeech
                    } else if let audioReply = reply as? AudioReply {
                        return audioReply.audioSpeech
                    } else {
                        // Never ever this code could be executed, bcz array is filtered
                        throw DialogAPIError.Internal.processingInstanceInconsistency
                    }
                    }()
                
                let nextAction: AimyboxNextAction = {
                    if let _lastReply = lastReply, _lastReply === reply {
                        return /*.byQuestion(is: response.question)*/.standby
                    } else {
                        return .standby
                    }
                }()
                
                try throwIfCanceled()
                
                do {
                    try aimybox.speak(speech: speech, next: nextAction)
                } catch {
                    
                }
            }
        } catch DialogAPIError.Internal.processingCancellation {
            dialogAPI.notify?(.failure(.processingCancellation))
        } catch DialogAPIError.Internal.processingInstanceInconsistency {
            dialogAPI.notify?(.failure(.processingCancellation))
        } catch {
            
            return
        }
    }
    
    private func throwIfCanceled() throws {
        if isCancelled {
            throw DialogAPIError.Internal.processingCancellation
        }
    }
}

/**
 Domain of internal errors.
 */
fileprivate extension DialogAPIError {
    enum Internal: Error {
        
        case processingCancellation
        case processingInstanceInconsistency
    }
}

