//
//  MemeGeneratorApiClient.swift
//  I'm just a memer
//
//  Created by Petr Palata on 11.06.2021.
//

import Foundation
import UIKit

enum MemeGeneratorError: Error {
    case invalidUrl
    case invalidImage
    case invalidResponseType
}

class MemeGeneratorApiClient {
    let memeUrl = URL(string: "https://apimeme.com/meme?meme=10-Guy")
    
    func generateMeme(_ topText: String, bottomText: String) async throws -> (data: UIImage, response: HTTPURLResponse) {
        guard let memeUrl = self.memeUrl else {
            throw MemeGeneratorError.invalidUrl
        }
        
        let session = URLSession.shared
        let memeRequest = URLRequest(url: memeUrl)
        let response = try await session.data(for: memeRequest, delegate: nil)
        let meme = UIImage(data: response.0)
        guard let meme = meme else {
            throw MemeGeneratorError.invalidImage
        }
        
        guard let httpResponse = response.1 as? HTTPURLResponse else {
            throw MemeGeneratorError.invalidResponseType
        }
        
        return (meme, httpResponse)
    }
}
