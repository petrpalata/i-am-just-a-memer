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
    case memeCollectionMissing
}

class MemePhotoKitStorage {
    private let photoLibrary = PHPhotoLibrary.shared()
    private let userDefaults = UserDefaults.standard
    
    private let memeCollectionLocalIdentifierKey = "memeCollectionIdentifier"
    
    private let memeLoader = MemePhotoKitLoader()
    private let memeSaver = MemePhotoKitSaver()
    
    func addMeme(_ meme: UIImage) async throws {
       guard let memeCollection = await memeCollection() else {
            throw MemeStorageError.memeCollectionMissing
        }
        
        return try await memeSaver.addMeme(meme, to: memeCollection)
    }
    
    func deleteMeme(_ asset: PHAsset) async throws -> Bool {
        return await withCheckedContinuation { c in
            photoLibrary.performChanges {
                PHAssetChangeRequest.deleteAssets([asset] as NSFastEnumeration)
            } completionHandler: { success, error in
                c.resume(with: .success(success))
            }
        }
    }
    
    func loadMemes(_ desiredWidth: CGFloat? = nil) async throws -> [(PHAsset, UIImage)] {
        guard let assetCollection = await existingMemeAssetCollection() else {
            return []
        }
        return try await memeLoader.loadAssetsFromPhotosLibrary(assetCollection, preferredWidth: desiredWidth)
    }
    
    
    private func memeCollection() async -> PHAssetCollection? {
        let existingCollection = await existingMemeAssetCollection()
        guard let existingCollection = existingCollection else {
            return await createMemeLibrary()
        }
        return existingCollection
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
            return await existingMemeAssetCollection()
        }
        return nil
    }
    
    private func existingMemeAssetCollection() async -> PHAssetCollection? {
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
