//
//  MemePhotoKitSaver.swift
//  I'm just a memer
//
//  Created by Petr Palata on 25.06.2021.
//

import Foundation
import Photos
import UIKit

class MemePhotoKitSaver {
    let photoLibrary = PHPhotoLibrary.shared()
    
    public func addMeme(_ meme: UIImage, to memeCollection: PHAssetCollection) async throws {
        return try await withCheckedThrowingContinuation { c in
            photoLibrary.performChanges {
                let memeAssetCreateRequest = PHAssetChangeRequest.creationRequestForAsset(from: meme)
                guard let memeAssetPlaceholder = memeAssetCreateRequest.placeholderForCreatedAsset else {
                    c.resume(throwing: MemeStorageError.addMemeFailedToObtainPlaceholder)
                    return
                }
                
                
                guard let addMemeToCollectionRequest = PHAssetCollectionChangeRequest(for: memeCollection) else {
                    c.resume(throwing: MemeStorageError.addMemeFailedCollectionChangeFailed)
                    return
                }
                
                addMemeToCollectionRequest.addAssets([memeAssetPlaceholder] as NSFastEnumeration)
            } completionHandler: { success, error in
                c.resume(with: .success(()))
            }
        }
        
    }
}
