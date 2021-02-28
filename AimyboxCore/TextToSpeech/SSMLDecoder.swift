//
//  SSMLDecoder.swift
//  AimyboxCore
//
//  Created by Vladyslav Popovych on 21.12.2019.
//  Copyright © 2019 Just Ai. All rights reserved.
//

import Foundation

public extension Array where Element == AimyboxSpeech {
    
    var unwrapSSML: [Element] {
        
        var unwrapped = [Element]()

        forEach { elem in
            if let textSpeech = elem as? TextSpeech {
                SSMLDecoder().decode(textSpeech.text).forEach { decodedSpeech in
                    unwrapped.append(decodedSpeech)
                }
            } else {
                unwrapped.append(elem)
            }
        }
        
        return unwrapped
    }
}


public final class SSMLDecoder: NSObject, XMLParserDelegate {

    public override init() {
        speeches = []
        parserGroup = DispatchGroup()
        p_tag_text = ""
        super.init()
    }
    
    public func decode(_ string: String) -> [AimyboxSpeech] {
        let wrapped = "<p>\(string)</p>"
        
        if let data = wrapped.data(using: .utf8) {
            return decode(data)
        } else {
            return []
        }
    }
    
    private let parserGroup: DispatchGroup
    
    private let p_tag: String = "p"
    
    private var p_tag_text: String?
    
    private let audio_tag: String = "audio"
    
    private var audio_tag_url: URL?
    
    private var speeches: [AimyboxSpeech]
    
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
    
    public func parserDidEndDocument(_ parser: XMLParser) {
        parserGroup.leave()
    }
    
    public func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == p_tag {
            p_tag_text = nil
        } else if elementName == audio_tag {
            if let src = attributeDict["src"], let url = URL(string: src) {
                audio_tag_url = url
            } else {
                audio_tag_url = nil
            }
        }
    }
    
    public func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == p_tag {
            guard let _p_tag_text = p_tag_text else { return }

            speeches.append(
                TextSpeech(text: _p_tag_text.trimmingCharacters(in: .whitespaces))
            )
            p_tag_text = nil
        } else if elementName == audio_tag {
            guard let _audio_tag_url = audio_tag_url else { return }
            
            speeches.append(
                AudioSpeech(audioURL: _audio_tag_url)
            )
            audio_tag_url = nil
        }
    }
    
    public func parser(_ parser: XMLParser, foundCharacters string: String) {
        if p_tag_text == nil {
            p_tag_text = string
        } else {
            p_tag_text?.append(string)
        }

    }
}
