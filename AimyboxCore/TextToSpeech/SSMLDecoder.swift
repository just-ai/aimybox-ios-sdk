//
//  SSMLDecoder.swift
//  AimyboxCore
//
//  Created by Vladyslav Popovych on 21.12.2019.
//  Copyright © 2019 Just Ai. All rights reserved.
//

import Foundation

final class SSMLDecoder: NSObject, XMLParserDelegate {

    private let parserGroup = DispatchGroup()

    private var audioTagUrl: URL?

    private var pTagText: String?

    private var speeches: [AimyboxSpeech] = []

    func decode(_ string: String) -> [AimyboxSpeech] {
        let wrapped = "<p>\(string)</p>"

        if let data = wrapped.data(using: .utf8) {
            return decode(data)
        } else {
            return []
        }
    }

    func parser(
        _ parser: XMLParser,
        didStartElement elementName: String,
        namespaceURI: String?,
        qualifiedName qName: String?,
        attributes attributeDict: [String : String] = [:]
    ) {
        if elementName == pTag {
            pTagText = nil
        } else if elementName == audioTag {
            if let src = attributeDict["src"], let url = URL(string: src) {
                audioTagUrl = url
            } else {
                audioTagUrl = nil
            }
        }
    }

    func parser(
        _ parser: XMLParser,
        didEndElement elementName: String,
        namespaceURI: String?,
        qualifiedName qName: String?
    ) {
        if elementName == pTag {
            guard let pTagText = pTagText else {
                return
            }
            speeches.append(TextSpeech(text: pTagText.trimmingCharacters(in: .whitespaces)))
            self.pTagText = nil
        } else if elementName == audioTag {
            guard let audioTagUrl = audioTagUrl else {
                return
            }
            speeches.append(AudioSpeech(audioURL: audioTagUrl))
            self.audioTagUrl = nil
        }
    }

    func parserDidEndDocument(_ parser: XMLParser) {
        parserGroup.leave()
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if pTagText == nil {
            pTagText = string
        } else {
            pTagText?.append(string)
        }
    }

    private func decode(_ data: Data) -> [AimyboxSpeech] {
        let parser = XMLParser(data: data)
        parser.delegate = self
        parser.shouldProcessNamespaces = false
        parser.shouldReportNamespacePrefixes = false
        parser.shouldResolveExternalEntities = false

        parserGroup.enter()
        parser.parse()
        parserGroup.wait()

        return speeches
    }

}

private let audioTag: String = "audio"

private let pTag: String = "p"
