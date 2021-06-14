//
//  GenerateMemeResponse.swift
//  I'm just a memer
//
//  Created by Petr Palata on 14.06.2021.
//

import Foundation

struct GenerateMemeResponse: Decodable {
    let success: Bool
    let data: GenerateMemeResponseUrls?
    let error_message: String?
}

struct GenerateMemeResponseUrls: Decodable {
    let url: String
    let page_url: String
}
