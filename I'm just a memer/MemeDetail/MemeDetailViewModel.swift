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
    @Published var hasGeneratedMeme: Bool = false
    @Published var errorMessage: String?
    @Published var errorPresent: Bool = false
    
    init(_ meme: Meme) {
        self.meme = meme
        self.captionInputs = Array(repeating: "", count: meme.boxCount)
    }
    
    func generateStubMeme() async {
        let stubCaptions = (1...meme.boxCount).map { captionIndex in
            return "Caption \(captionIndex)"
        }
        
        memeImageStub = await generateMeme(stubCaptions)
    }
    
    func generateMeme() async {
        generatedMeme = await generateMeme(captionInputs)
        hasGeneratedMeme = true
    }
    
    private func generateMeme(_ captions: [String]) async -> UIImage? {
        cleanState()
        
        do {
            let image = try await imgFlipApiClient.generateMeme(meme, captions: captions)
            return image
        } catch {
            errorMessage = "\(error)"
            errorPresent = true
            print(error)
        }
        return nil
    }
    
    private func cleanState() {
        memeImageStub = nil
        generatedMeme = nil
        errorMessage = nil
        errorPresent = false
        hasGeneratedMeme = false
    }
}
