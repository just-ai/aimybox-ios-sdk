//
//  Response.swift
//  Aimybox
//
//  Created by Vladyslav Popovych on 07.12.2019.
//

import Foundation

/**
Response model, which is used across the library.
You can parse additional data from `json` in your `CustomSkill`.
*/
public
protocol Response: AnyObject {
    /**
    User's original query to your agent.
    */
    var query: String { get }
    /**
    The action name from the matched intent.
    */
    var action: String { get }
    /**
    The intent that matched the conversational query.
    */
    var intent: String { get }
    /**
    If true `Aimybox` will listen to user after handling response.
    */
    var question: Bool { get }
    /**
    Array of replies that will be displayed to user.
    */
    var replies: [Reply] { get }

}
