//
//  AimyboxImageReply.swift
//  AimyboxDialogAPI
//
//  Created by Vladislav Popovich on 20.12.2019.
//  Copyright © 2019 Just Ai. All rights reserved.
//

#if COCOAPODS
#else
import AimyboxCore
#endif

final public class AimyboxImageReply: ImageReply, Decodable {
    
    public var url: URL
    
    public init(url: URL) {
        self.url = url
    }
    
    public enum CodingKeys: String, CodingKey {
        case url = "imageUrl"
    }
    
    static let jsonKey: String = "image"
}
