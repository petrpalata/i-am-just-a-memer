//
//  SavedMemesViewModel.swift
//  I'm just a memer
//
//  Created by Petr Palata on 22.06.2021.
//

import SwiftUI
import UIKit
import Photos


class SavedMemesViewModel: ObservableObject {
    @Published var loadedMemes: [LoadedMeme] = []
    @Published var loading: Bool = true
    @Published var editing: Bool = false
    
    let memeStorage = MemePhotoKitStorage()
    
    func loadMemesFromStorage(_ preferedWidth: CGFloat?) throws {
        loading = true
        async {
            let memeTuples = try await memeStorage.loadMemes(preferedWidth)
            let loadedMemes = memeTuples.map { LoadedMeme(asset: $0.0, image: $0.1) }
            await updateLoadedMemes(loadedMemes)
        }
    }
    
    func deleteMeme(_ memeToDelete: LoadedMeme) {
        async {
            do {
                if try await memeStorage.deleteMeme(memeToDelete.asset) {
                    let filteredMemes = loadedMemes.filter { $0 != memeToDelete }
                    await updateLoadedMemes(filteredMemes)
                }
            } catch {
                print(error)
            }
        }
    }
    
    @MainActor private func updateLoadedMemes(_ memes: [LoadedMeme]) {
        loadedMemes = memes
        loading = false
    }
}
