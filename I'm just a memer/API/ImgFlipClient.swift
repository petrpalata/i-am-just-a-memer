//
//  MemeGeneratorJsonApiClient.swift
//  I'm just a memer
//
//  Created by Petr Palata on 12.06.2021.
//

import Foundation
import UIKit

enum ImgFlipClientError: Error, CustomStringConvertible  {
    case invalidPayload
    case invalidBaseUrl
    case invalidResponseType
    case missingLoginData
    case invalidImageUrl
    case invalidQueryData
    case imgFlipError(String)
    
    var description: String {
        switch self {
        case .invalidPayload:
            return "Invalid input payload provided"
        case .invalidBaseUrl:
            return "Invalid base URL"
        case .invalidResponseType:
            return "Failed to parse response data"
        case .missingLoginData:
            return "Failed to retrieve login data from storage"
        case .invalidImageUrl:
            return "Invalid image URL returned from the API"
        case .invalidQueryData:
            return "Invalid query parameters provided"
        case .imgFlipError(let backendError):
            return "The API returned the following error: \(backendError)"
        }
    }
}

class ImgFlipClient {
    let baseUrl = URLComponents(string: "https://api.imgflip.com")
    
    func getMemes() async throws -> [ImgFlipMeme] {
        let session = URLSession.shared
        var targetUrlComponents = baseUrl
        targetUrlComponents?.path = "/get_memes"
        
        guard let targetUrl = targetUrlComponents?.url else {
            print("Failed to create URL from components in getMeme() API call")
            throw ImgFlipClientError.invalidBaseUrl
        }
        
        var memeListRequest = URLRequest(url: targetUrl)
        memeListRequest.httpMethod = "GET"
        
        let response = try await session.data(for: memeListRequest, delegate: nil)
        guard let httpResponse = response.1 as? HTTPURLResponse else {
            throw ImgFlipClientError.invalidResponseType
        }
        
        print("Got response from getMeme API call: \(httpResponse), with code: \(httpResponse.statusCode), body: \(response.0)")
        do {
            let decoder = JSONDecoder()
            let memes = try decoder.decode(MemeResponse.self, from: response.0)
            print(memes)
            return memes.data?["memes"] ?? []
        } catch {
            print(error)
            return []
        }
    }
    
    func generateMeme(_ meme: Meme, captions: [String]) async throws -> UIImage {
        let session = URLSession.shared
        var targetUrlComponents = baseUrl
        targetUrlComponents?.path = "/caption_image"
        guard let targetUrl = targetUrlComponents?.url else {
            print("Failed to create URL from components in generateMeme() API call")
            throw ImgFlipClientError.invalidBaseUrl
        }
        
        var memeListRequest = URLRequest(url: targetUrl)
        memeListRequest.httpMethod = "POST"
        memeListRequest.httpBody = try generateMemeRequestData(meme, captions: captions)
        
        print("Request: \(memeListRequest)")

        let response = try await session.data(for: memeListRequest, delegate: nil)
        guard let httpResponse = response.1 as? HTTPURLResponse else {
            throw ImgFlipClientError.invalidResponseType
        }
        
        print("Got response from getMeme API call: \(httpResponse), with code: \(httpResponse.statusCode), body: \(response.0)")
        let decoder = JSONDecoder()
        let generateMemeResponse = try decoder.decode(GenerateMemeResponse.self, from: response.0)
        
        if let backendError = generateMemeResponse.error_message {
            throw ImgFlipClientError.imgFlipError(backendError)
        }
        
        guard let imgUrlString = generateMemeResponse.data?.url,
              let imgUrl = URL(string: imgUrlString) else {
            throw ImgFlipClientError.invalidImageUrl
        }
        
        let data = try Data(contentsOf: imgUrl)
        return UIImage(data: data)!
    }
    
    private func getLoginDataFromEnvironment() -> (username: String, password: String)? {
        let environment = ProcessInfo.processInfo.environment
        guard let username = environment["ENV_IMGFLIP_USERNAME"],
              let password = environment["ENV_IMGFLIP_PASSWORD"] else {
                  print("Cannot load username/password from environment")
                  return nil
              }
        
        return (username, password)
    }
        
    private func generateMemeRequestData(_ meme: Meme, captions: [String]) throws -> Data {
        guard let loginData = getLoginDataFromEnvironment() else {
            print("Failed to load the login data from Info.plist")
            throw ImgFlipClientError.missingLoginData
        }
                       
        let username = loginData.username
        let password = loginData.password
        
        let generateMemeRequest = GenerateMemeRequest(templateId: meme.backendId, username: username, password: password, boxes: captions.map({ caption in
            return MemeCaptionBox(text: caption)
        })
        )

        var requestBodyComponents = URLComponents()
        requestBodyComponents.queryItems = generateMemeRequest.toUrlQueryItems()
        
       guard let query = requestBodyComponents.query,
              let data = query.data(using: .utf8) else {
            throw ImgFlipClientError.invalidQueryData
        }
        return data
    }
}
