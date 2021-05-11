//
//  WAVFileGenerator.swift
//  YandexSpeechKit
//
//  Created by Vladislav Popovich on 31.01.2020.
//  Copyright © 2020 Just Ai. All rights reserved.
//

import Foundation

final
class WAVFileGenerator {

    private
    func byteArray<T>(_ value: T) -> [UInt8] where T: FixedWidthInteger {
        withUnsafeBytes(of: value.littleEndian) { Array($0) }
    }

}
