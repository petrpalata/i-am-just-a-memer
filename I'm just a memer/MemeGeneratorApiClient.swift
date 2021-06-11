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
    case invalidParameters
}

class MemeGeneratorApiClient {
    let baseUrl = URLComponents(string: "https://apimeme.com/meme")
    
    func generateMeme(_ topText: String, bottomText: String) async throws -> (data: UIImage, response: HTTPURLResponse) {
        let session = URLSession.shared
        let memeRequest = try requestFromParams("", topText: topText, bottomText: bottomText)
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
    
    private func requestFromParams(_ memeName: String,
                                   topText: String,
                                   bottomText: String) throws -> URLRequest {
        guard var baseUrl = self.baseUrl else {
            throw MemeGeneratorError.invalidUrl
        }
        
        let queryParameters = [
            URLQueryItem(name: "meme", value: "1990s-First-World-Problems"),
            URLQueryItem(name: "top", value: topText),
            URLQueryItem(name: "bottom", value: bottomText)
        ]
        baseUrl.queryItems = queryParameters
        guard let urlFromComponents = baseUrl.url else {
            throw MemeGeneratorError.invalidParameters
        }
        
        return URLRequest(url: urlFromComponents)
    }
}
