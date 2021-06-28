//
//  MemePhotoKitLoader.swift
//  I'm just a memer
//
//  Created by Petr Palata on 24.06.2021.
//

import Foundation
import Photos
import UIKit

enum MemeLoaderError: Error {
    case fetchRequestConstructionFailed
}

class MemePhotoKitLoader {
    let imageManager = PHImageManager.default()
    
    func loadAssetsFromPhotosLibrary(_ memeAssetCollection: PHAssetCollection, preferredWidth: CGFloat? = nil) async throws -> [(PHAsset, UIImage)] {
        
        let fetchResult = PHAsset.fetchAssets(in: memeAssetCollection, options: nil)
        
        var assets: [PHAsset] = []
        fetchResult.enumerateObjects { asset, index, _ in
            assets.append(asset)
        }
        
        let images = try await assets.asyncSequence().map { asset -> (PHAsset, UIImage?) in
            let image = await self.loadImageFromPHAsset(asset, preferredWidth: preferredWidth)
            return (asset, image)
        }.compactArray()
        
        return images
    }
    
    private func loadImageFromPHAsset(_ phAsset: PHAsset, preferredWidth: CGFloat?) async -> UIImage? {
        return await withCheckedContinuation { c in
            let targetSize = targetSizeFromPreferredWidth(preferredWidth, for: phAsset)
            let options = PHImageRequestOptions()
            options.isSynchronous = true
            options.deliveryMode = .highQualityFormat
            imageManager.requestImage(
                for: phAsset,
                   targetSize: targetSize,
                   contentMode: .aspectFit,
                   options: options) { image, _ in
                c.resume(with: .success(image))
            }
        }
    }
    
    private func targetSizeFromPreferredWidth(_ preferredWidth: CGFloat?, for phAsset: PHAsset) -> CGSize {
        var targetSize = PHImageManagerMaximumSize
        if let preferredWidth = preferredWidth {
            let aspectRatio = CGFloat(phAsset.pixelHeight) / CGFloat(phAsset.pixelWidth)
            targetSize = CGSize(
                width: preferredWidth,
                height: preferredWidth * aspectRatio
            )
        }
        return targetSize
    }
}

