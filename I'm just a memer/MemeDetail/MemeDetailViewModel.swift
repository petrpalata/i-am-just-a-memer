//
//  MemeDetailViewModel.swift
//  I'm just a memer
//
//  Created by Petr Palata on 15.06.2021.
//

import SwiftUI

class MemeDetailViewModel: ObservableObject {
    let meme: Meme
    
    let imgFlipApiClient = ImgFlipClient()
    
    @Published var captionInputs: [String]
    @Published var memeImageStub: UIImage?
    @Published var generatedMeme: UIImage?
    
    init(_ meme: Meme) {
        self.meme = meme
        self.captionInputs = Array(repeating: "", count: meme.boxCount)
    }
    
    func generateStubMeme() async throws -> UIImage {
        let stubCaptions = (1...meme.boxCount).map { captionIndex in
            return "Caption \(captionIndex)"
        }
        let image = try await imgFlipApiClient.generateMeme(meme, captions: stubCaptions)
        memeImageStub = image
        return image
    }
    
    func generateMeme() async throws {
        memeImageStub = nil
        generatedMeme = nil
        let image = try await imgFlipApiClient.generateMeme(meme, captions: captionInputs)
        generatedMeme = image
    }
}
