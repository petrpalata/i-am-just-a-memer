//
//  GenerateMemeRequest.swift
//  I'm just a memer
//
//  Created by Petr Palata on 14.06.2021.
//

import Foundation

struct GenerateMemeRequest {
    var templateId: String
    var username: String
    var password: String
    var font: String?
    var maxFontSize: Int?
    var boxes: [MemeCaptionBox]
    
    func toUrlQueryItems() -> [URLQueryItem] {
        return [
            URLQueryItem(name: "template_id", value: templateId),
            URLQueryItem(name: "username", value: username),
            URLQueryItem(name: "password", value: password),
            URLQueryItem(name: "font", value: font),
            URLQueryItem(name: "maxFontSize", value: String(maxFontSize ?? 100))
        ] + boxes.enumerated().flatMap({ $0.element.toQueryItems($0.offset) })
    }
}

struct MemeCaptionBox: Encodable {
    var text: String
    var x: Int?
    var y: Int?
    var width: Int?
    var height: Int?
    var color: String?
    var outline_color: String?
    
    func toQueryItems(_ index: Int) -> [URLQueryItem] {
        return [
            URLQueryItem(name: "boxes[\(index)][text]", value: text),
        ]
    }
}

