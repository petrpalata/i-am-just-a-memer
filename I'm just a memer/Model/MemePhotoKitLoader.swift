//
//  MemePhotoKitLoader.swift
//  I'm just a memer
//
//  Created by Petr Palata on 24.06.2021.
//

import Foundation
import Photos
import UIKit

class MemePhotoKitLoader {
    let imageManager = PHImageManager.default()
    
    func loadAssetsFromPhotosLibrary() async throws -> [UIImage] {
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
}

