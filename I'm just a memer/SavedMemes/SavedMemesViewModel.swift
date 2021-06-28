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
    @Published var savedMemes: [(PHAsset, UIImage)] = []
    @Published var loading: Bool = true
    @Published var editing: Bool = false
    
    let memeStorage = MemePhotoKitStorage()
    
    func loadMemesFromStorage(_ preferedWidth: CGFloat?) throws {
        loading = true
        async {
            let images = try await memeStorage.loadMemes(preferedWidth)
            await updateSavedImages(images)
        }
    }
    
    func deleteMeme(_ asset: PHAsset) {
        async {
            do {
                if try await memeStorage.deleteMeme(asset) {
                    let filteredMemes = savedMemes.filter({ memeTuple in
                        return memeTuple.0.localIdentifier != asset.localIdentifier
                    })
                    await updateSavedImages(filteredMemes)
                }
            } catch {
                print(error)
            }
        }
    }
    
    @MainActor private func updateSavedImages(_ images: [(PHAsset, UIImage)]) {
        savedMemes = images
        loading = false
    }
}
