//
//  MemeGeneratorJsonApiClient.swift
//  I'm just a memer
//
//  Created by Petr Palata on 12.06.2021.
//

import Foundation

enum MemeGeneratorJsonApiClientError: Error {
    case invalidPayload
    case invalidBaseUrl
    case invalidResponseType
    case missingApiKey
}

class MemeGeneratorJsonApiClient {
    let baseUrl = URLComponents(string: "https://api.imgflip.com")
    
    func getMemes() async throws -> [ImgFlipMeme] {
        guard let loginData = getLoginDataFromInfoPlist() else {
            print("Failed to load the login data from Info.plist")
            throw MemeGeneratorJsonApiClientError.missingApiKey
        }
        
        let username = loginData.username
        let password = loginData.password

        let session = URLSession.shared
        var targetUrlComponents = baseUrl
        targetUrlComponents?.path = "/get_memes"
        
        guard let targetUrl = targetUrlComponents?.url else {
            print("Failed to create URL from components in getMeme() API call")
            throw MemeGeneratorJsonApiClientError.invalidBaseUrl
        }
        
        var memeListRequest = URLRequest(url: targetUrl)
        memeListRequest.httpMethod = "GET"
        
        let response = try await session.data(for: memeListRequest, delegate: nil)
        guard let httpResponse = response.1 as? HTTPURLResponse else {
            throw MemeGeneratorJsonApiClientError.invalidResponseType
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
    
    private func getLoginDataFromInfoPlist() -> (username: String, password: String)? {
        guard let infoPlistValues = Bundle.main.infoDictionary else {
            print("Cannot load Info.plist dictionary")
            return nil
        }
        guard let username = infoPlistValues["IMGFLIP_USERNAME"] as? String,
              let password = infoPlistValues["IMGFLIP_PASSWORD"] as? String else
              {
                  return nil
              }
        return (username, password)
    }
}
