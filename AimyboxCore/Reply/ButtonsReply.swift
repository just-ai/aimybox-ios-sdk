//
//  ButtonsReply.swift
//  Aimybox
//
//  Created by Vladyslav Popovych on 07.12.2019.
//

import Foundation

/**
Represents a reply with which needs user interaction.
*/
public
protocol ButtonsReply: Reply {
    /**
    */
    var buttons: [ButtonReply] { get }

}

/**
Clickable button with which the user can quickly respond without using STT.
*/
public
protocol ButtonReply: Reply {
    /**
    Text to be displayed in buttons interface.
    */
    var text: String { get }
    /**
    Link that could be opened on devices browser.
    */
    var url: URL? { get }

}
