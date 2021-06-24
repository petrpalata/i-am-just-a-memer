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
    @Published var savedMemes: [UIImage] = []
    @Published var loading: Bool = true
    
    let imageLoader = MemePhotoKitLoader()
    
    func loadMemesFromStorage() throws {
        loading = true
        async {
            let images = try await imageLoader.loadAssetsFromPhotosLibrary()
            await updateSavedImages(images)
        }
    }
    
    @MainActor private func updateSavedImages(_ images: [UIImage]) {
        savedMemes = images
        loading = false
    }
}
