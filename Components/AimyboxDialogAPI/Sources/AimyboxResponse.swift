//
//  AimyboxResponse.swift
//  Aimybox
//
//  Created by Vladislav Popovich on 13.12.2019.
//

#if canImport(Aimybox)
import Aimybox

fileprivate struct AimyboxReplyType: Decodable {
    var type: String
}

final public class AimyboxResponse: Response, Decodable {
    public var query: String = ""
    
    public var action: String = ""
    
    public var intent: String = ""
    
    public var question: Bool = false
    
    public var replies: [Reply] = []

    // MARK: Decodable
    enum CodingKeys: String, CodingKey {
        case query
        case action
        case intent
        case question
        case replies
    }
    
    public required init(from decoder: Decoder) throws {
        let map = try decoder.container(keyedBy: CodingKeys.self)
        
        query = try map.decodeIfPresent(.query).or("")
        action = try map.decodeIfPresent(.action).or("")
        intent = try map.decodeIfPresent(.intent).or("")
        question = try map.decodeIfPresent(.question).or(false)
        
        var repliesTypeMap = try map.nestedUnkeyedContainer(forKey: .replies)
        var repliesMap = try map.nestedUnkeyedContainer(forKey: .replies)
        
        while !repliesTypeMap.isAtEnd {
            let type = try repliesTypeMap.decode(AimyboxReplyType.self).type
            
            switch type {
                
            case AimyboxTextReply.jsonKey:
                replies.append(
                    try repliesMap.decode(AimyboxTextReply.self)
                )
            case AimyboxAudioReply.jsonKey:
                replies.append(
                    try repliesMap.decode(AimyboxAudioReply.self)
                )
                
            case AimyboxImageReply.jsonKey:
                replies.append(
                    try repliesMap.decode(AimyboxImageReply.self)
                )
                
            case AimyboxButtonsReply.jsonKey:
                replies.append(
                    try repliesMap.decode(AimyboxButtonsReply.self)
                )

            default:
                break
            }
        }
    }
}

#endif
