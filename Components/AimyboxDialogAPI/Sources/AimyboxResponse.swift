//
//  AimyboxResponse.swift
//  Aimybox
//
//  Created by Vladislav Popovich on 13.12.2019.
//

#if canImport(Aimybox)
import Aimybox

final public class AimyboxResponse: Response, Decodable {

    static var tableOfRepleis: [String: ReplayFactory] = [:]

    public static func registerReplyType<T: Reply>(of type: T.Type, key: String) where T: Decodable {
        Self.tableOfRepleis[key] = ReplayFactory { try $0.decode(type.self) }
    }

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
            if let container = Self.tableOfRepleis[type], let factory = container.factory {
                replies.append(try factory(&repliesMap))
            }
        }
    }

}

private struct AimyboxReplyType: Decodable {
    var type: String
}

struct ReplayFactory {

    var factory: ((inout UnkeyedDecodingContainer) throws -> Reply)?

}

#endif
