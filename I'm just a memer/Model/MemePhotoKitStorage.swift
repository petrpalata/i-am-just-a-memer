//
//  MemePhotoKitStorage.swift
//  I'm just a memer
//
//  Created by Petr Palata on 24.06.2021.
//

import Foundation
import Photos
import UIKit

enum MemeStorageError: Error {
    case addMemeFailedToObtainPlaceholder
    case addMemeFailedCollectionChangeFailed
}

class MemePhotoKitStorage {
    private let photoLibrary = PHPhotoLibrary.shared()
    private let userDefaults = UserDefaults.standard
    private let memeCollectionLocalIdentifierKey = "memeCollectionIdentifier"
    private let memeLoader = MemePhotoKitLoader()
    
    func addMeme(_ meme: UIImage) async throws -> Bool {
        var memeCollection: PHAssetCollection?
        memeCollection = await memeAssetCollection()
        if memeCollection == nil {
           memeCollection = await createMemeLibrary()
        }
        
        guard let memeCollection = memeCollection else {
            return false
        }
        
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
                c.resume(with: .success(success))
            }
        }
    }
    
    func loadMemes(_ desiredWidth: CGFloat? = nil) async throws -> [UIImage] {
        guard let assetCollection = await memeAssetCollection() else {
            return []
        }
        return try await memeLoader.loadAssetsFromPhotosLibrary(assetCollection, preferredWidth: desiredWidth)
    }
    
    private func createMemeLibrary() async -> PHAssetCollection? {
        let success = await withCheckedContinuation { c in
            photoLibrary.performChanges {
                let createCollectionRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: "Memes")
                let placeholder = createCollectionRequest.placeholderForCreatedAssetCollection
                self.userDefaults.set(placeholder.localIdentifier, forKey: self.memeCollectionLocalIdentifierKey)
            } completionHandler: { success, error in
                c.resume(with: .success(success))
            }
        }
        if success {
            return await memeAssetCollection()
        }
        return nil
    }
    
    private func memeAssetCollection() async -> PHAssetCollection? {
        return await withCheckedContinuation { c in
            guard let identifier = userDefaults.string(forKey: memeCollectionLocalIdentifierKey) else {
                c.resume(returning: nil)
                return
            }
            
            let fetchResult = PHAssetCollection.fetchAssetCollections(
                withLocalIdentifiers: [identifier],
                options: nil
            )
            
            c.resume(with: .success(fetchResult.firstObject))
        }
    }
}
