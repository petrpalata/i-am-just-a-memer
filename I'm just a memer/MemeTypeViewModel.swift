//
//  MemeTypeViewModel.swift
//  I'm just a memer
//
//  Created by Petr Palata on 11.06.2021.
//

import Foundation
import Combine
import SwiftUI

protocol MemeTypeViewModelDelegate: AnyObject {
    func didSelectMeme(_ meme: Meme?)
}

@MainActor
class MemeTypeViewModel: ObservableObject {
    @Published private(set) var memes: [Meme] = []
    @Published var loading: Bool = false
    weak var delegate: MemeTypeViewModelDelegate?
    
    var selection: Meme? {
        didSet {
            self.delegate?.didSelectMeme(selection)
        }
    }
    
    let apiClient = MemeGeneratorApiClient()

    func fetchMemes() async {
        loading = true
        guard let response = try? await apiClient.generateMeme("", bottomText: "") else {
            loading = false
            return
        }
        
        memes = [
            Meme(image: nil,
                 imageUrl: URL(string: "https://apimeme.com/meme?meme=1990s-First-World-Problems"),
                 name: "1990 First World Problems"),
            Meme(image: nil,
                 imageUrl: URL(string: "https://apimeme.com/meme?meme=10-Guy"),
                 name: "10 Guy")
        ]
        loading = false
    }
}
