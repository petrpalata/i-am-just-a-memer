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
    
    let imageManager = PHImageManager.default()
    
    func loadMemesFromStorage() throws {
        loading = true
        async {
            let images = try await loadAssetsFromPhotosLibrary()
            await updateSavedImages(images)
        }
    }
    
    private func loadAssetsFromPhotosLibrary() async throws -> [UIImage] {
        let mediaType = PHAssetMediaType.image
        let fetchResult = PHAsset.fetchAssets(with: mediaType, options: nil)
        var assets: [PHAsset] = []
        fetchResult.enumerateObjects { asset, index, _ in
            assets.append(asset)
        }
        
        let images = try await assets.asyncSequence().map { asset in
            return await self.loadImageFromPHAsset(asset)
        }.compactArray()
        
        return images
    }
    
    private func loadImageFromPHAsset(_ phAsset: PHAsset) async -> UIImage? {
        return await withCheckedContinuation { c in
            let options = PHImageRequestOptions()
            options.isSynchronous = true
            options.deliveryMode = .highQualityFormat
            imageManager.requestImageDataAndOrientation(
                for: phAsset,
                   options: options) { data, _, _, _ in
                guard let data = data else {
                    c.resume(with: .success(nil))
                    return
                }
                
                let fetchedImage = UIImage(data: data)
                c.resume(with: .success(fetchedImage))
            }
        }
    }
    
    @MainActor private func updateSavedImages(_ images: [UIImage]) {
        savedMemes = images
        loading = false
    }
}



extension Array where Element == PHAsset {
    struct PHAssetsAsyncSequence: AsyncSequence {
        typealias Element = PHAsset
        
        let assets: [PHAsset]
        
        struct AsyncIterator: AsyncIteratorProtocol {
            var currentIndex = 0
            let assets: [PHAsset]
            
            mutating func next() async throws -> PHAsset? {
                guard currentIndex < assets.count else {
                    return nil
                }
                
                let asset = assets[currentIndex]
                currentIndex += 1
                return asset
            }
        }
        
        func makeAsyncIterator() -> AsyncIterator {
            return AsyncIterator(assets: assets)
        }
    }
    
    func asyncSequence() -> PHAssetsAsyncSequence {
        return PHAssetsAsyncSequence(assets: self)
    }
}

extension AsyncMapSequence where Element == UIImage? {
    func compactArray() async throws -> [UIImage] {
        return try await reduce(into: [], { acc, elem in
            if let elem = elem {
                acc.append(elem)
            }
        })
    }
}
