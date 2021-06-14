//
//  MemeResponse.swift
//  I'm just a memer
//
//  Created by Petr Palata on 13.06.2021.
//

import Foundation

struct MemeResponse: Decodable {
    let data: Dictionary<String, [ImgFlipMeme]>?
    let success: Bool
}

struct ImgFlipMeme: Decodable {
    let id: String
    
    let box_count: Int
    
    let height: Int
    let width: Int
    
    let name: String
    let url: String
}
