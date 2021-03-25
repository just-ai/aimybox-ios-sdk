//
//  AimyboxAudioReply.swift
//  AimyboxDialogAPI
//
//  Created by Vladislav Popovich on 20.12.2019.
//  Copyright © 2019 Just Ai. All rights reserved.
//

#if canImport(Aimybox)
import Aimybox

final
class AimyboxAudioReply: AudioReply, Decodable {

    var url: URL

    init(url: URL) {
        self.url = url
    }

    static let jsonKey: String = "audio"
}

#endif
