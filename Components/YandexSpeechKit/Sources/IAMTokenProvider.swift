//
//  IAMTokenProvider.swift
//  YandexSpeechKit
//
//  Created by Vladislav Popovich on 30.01.2020.
//  Copyright © 2020 Just Ai. All rights reserved.
//

import Foundation

public protocol IAMTokenProvider {

    func token() -> IAMToken?
}
