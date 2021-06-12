//
//  MemeGeneratorApiClient.swift
//  I'm just a memer
//
//  Created by Petr Palata on 11.06.2021.
//

import Foundation
import UIKit

protocol MemeGeneratorApiClientProtocol {
   func generateMeme(_ imageUrl: URL,
                      topText: String,
                      bottomText: String) async throws -> (data: UIImage, response: HTTPURLResponse)
    
    func generateMeme(_ topText: String,
                      bottomText: String) async throws -> (data: UIImage, response: HTTPURLResponse)
}


enum MemeGeneratorError: Error {
    case invalidUrl
    case invalidImage
    case invalidResponseType
    case invalidParameters
}

class MemeGeneratorApiClient {
    let baseUrl = URLComponents(string: "https://apimeme.com/meme")
    
    private func generateMeme(_ memeName: String, topText: String, bottomText: String) async throws -> (data: UIImage, response: HTTPURLResponse) {
        let session = URLSession.shared
        let memeRequest = try requestFromParams(memeName, topText: topText, bottomText: bottomText)
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
            URLQueryItem(name: "meme", value: memeName),
            URLQueryItem(name: "top", value: topText),
            URLQueryItem(name: "bottom", value: bottomText)
        ]
        baseUrl.queryItems = queryParameters
        guard let urlFromComponents = baseUrl.url else {
            throw MemeGeneratorError.invalidParameters
        }
        
        return URLRequest(url: urlFromComponents)
    }

    private func getMemeNameFromImageUrl(_ imageUrl: URL) -> String? {
        if let components = URLComponents(url: imageUrl, resolvingAgainstBaseURL: true),
           let memeQueryParam = components.queryItems?.first(where: { $0.name == "meme" }),
           let memeName = memeQueryParam.value {
            return memeName
        }
        return nil
    }
}


extension MemeGeneratorApiClient: MemeGeneratorApiClientProtocol {
    func generateMeme(_ topText: String, bottomText: String) async throws -> (data: UIImage, response: HTTPURLResponse) {
        return try await generateMeme("1990s-First-World-Problems", topText: topText, bottomText: bottomText)
    }
    
    func generateMeme(_ imageUrl: URL, topText: String, bottomText: String) async throws -> (data: UIImage, response: HTTPURLResponse) {
        if let memeName = getMemeNameFromImageUrl(imageUrl) {
            return try await generateMeme(memeName, topText: topText, bottomText: bottomText)
        } else {
            return try await generateMeme(topText, bottomText: bottomText)
        }
    }
}
