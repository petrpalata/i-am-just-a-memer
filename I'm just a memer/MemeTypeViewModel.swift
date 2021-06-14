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
    
    let apiClient = ImgFlipClient()

    func fetchMemes() async {
        loading = true
        guard let memes = try? await apiClient.getMemes() else {
            loading = false
            return
        }
        
        self.memes = memes.map { imgFlip in
            return Meme(backendId: imgFlip.id,
                        image: nil,
                        imageUrl: URL(string: imgFlip.url),
                        name: imgFlip.name)
        }
    
       loading = false
    }
}
