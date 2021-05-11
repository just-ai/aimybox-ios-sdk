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

    func createWAVFile(using rawData: Data) -> Data {
        rawData
    }

    /** http://soundfile.sapp.org/doc/WaveFormat/
    */
    private
    func createWaveHeader(data: Data) -> Data {

        let sampleRate: Int32 = 48_000
        let dataSize = Int32(data.count)
        let chunkSize: Int32 = 36 + dataSize
        let subChunkSize: Int32 = 16
        let format: Int16 = 1
        let channels: Int16 = 1
        let bitsPerSample: Int16 = 16
        let byteRate: Int32 = sampleRate * Int32(channels * bitsPerSample / 8)
        let blockAlign: Int16 = channels * bitsPerSample / 8

        var header = Data()

        header.append([UInt8]("RIFF".utf8), count: 4)
        header.append(byteArray(chunkSize), count: 4)
        header.append([UInt8]("WAVE".utf8), count: 4)
        header.append([UInt8]("fmt ".utf8), count: 4)
        header.append(byteArray(subChunkSize), count: 4)
        header.append(byteArray(format), count: 2)
        header.append(byteArray(channels), count: 2)
        header.append(byteArray(sampleRate), count: 4)
        header.append(byteArray(byteRate), count: 4)
        header.append(byteArray(blockAlign), count: 2)
        header.append(byteArray(bitsPerSample), count: 2)
        header.append([UInt8]("data".utf8), count: 4)
        header.append(byteArray(dataSize), count: 4)

        return header
    }

    private
    func byteArray<T>(_ value: T) -> [UInt8] where T: FixedWidthInteger {
        withUnsafeBytes(of: value.littleEndian) { Array($0) }
    }

}
