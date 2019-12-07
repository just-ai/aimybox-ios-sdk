//
//  ImageReply.swift
//  Aimybox
//
//  Created by Vladyslav Popovych on 07.12.2019.
//

import Foundation

/**
 Represents a reply with image content, which should be displayed in the UI.
 */
public protocol ImageReply: Reply {
    /**
     URL to the image or GIF.
     */
    var url: URL { get }
}
