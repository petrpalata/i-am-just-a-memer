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
    
    func loadAssetsFromPhotosLibrary(_ preferredWidth: CGFloat? = nil) async throws -> [UIImage] {
        let mediaType = PHAssetMediaType.image
        let fetchResult = PHAsset.fetchAssets(with: mediaType, options: nil)
        var assets: [PHAsset] = []
        fetchResult.enumerateObjects { asset, index, _ in
            assets.append(asset)
        }
        
        let images = try await assets.asyncSequence().map { asset in
            return await self.loadImageFromPHAsset(asset, preferredWidth: preferredWidth)
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

