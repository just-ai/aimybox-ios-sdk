//
//  AimyboxButtonsReply.swift
//  AimyboxDialogAPI
//
//  Created by Vladislav Popovich on 20.12.2019.
//  Copyright © 2019 Just Ai. All rights reserved.
//

#if canImport(Aimybox)
import Aimybox

final class AimyboxButtonReply: ButtonReply, Decodable {

    var text: String

    var url: URL?

    init(text: String, url: URL?) {
        self.text = text
        self.url = url
    }
}

final class AimyboxButtonsReply: ButtonsReply, Decodable {

    var buttons: [ButtonReply] {
        get { typedButtons.compactMap { $0 as ButtonReply } }
        set { typedButtons = newValue.compactMap { $0 as? AimyboxButtonReply } }
    }

    var typedButtons: [AimyboxButtonReply]

    init(buttons: [AimyboxButtonReply]) {
        self.typedButtons = buttons
    }

    enum CodingKeys: String, CodingKey {
        case typedButtons = "buttons"
    }

    static let jsonKey: String = "buttons"
}

#endif
