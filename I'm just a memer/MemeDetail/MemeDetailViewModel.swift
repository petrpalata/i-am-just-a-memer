//
//  MemeDetailViewModel.swift
//  I'm just a memer
//
//  Created by Petr Palata on 15.06.2021.
//

import SwiftUI

class MemeDetailViewModel: ObservableObject {
    let meme: Meme
    
    @Published var captionInputs: [String]
    
    init(_ meme: Meme) {
        self.meme = meme
        self.captionInputs = Array(repeating: "", count: meme.boxCount)
    }
}
