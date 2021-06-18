//
//  CachedAsyncImageViewModel.swift
//  I'm just a memer
//
//  Created by Petr Palata on 18.06.2021.
//

import SwiftUI
import UIKit

class CachedAsyncImageViewModel: ObservableObject {
    let session = URLSession.shared
    let memeCache = MemeCache.shared
    
    @Published var image: UIImage?

    func fetchImage(_ url: URL?, desiredSize: CGSize) async {
        guard let url = url else {
            return
        }
        
        do {
            if let cachedImage = memeCache.fetchThumbnail(url, size: desiredSize) {
                print("Cache hit")
                image = cachedImage
                return
            }
                
            let (imageData, _) = try await session.data(from: url, delegate: nil)
            
            guard let uiImage = UIImage(data: imageData) else {
                print("Failed to construct UIImage from image data")
                return
            }
            
            let thumbnail = try memeCache.cacheThumnail(uiImage, url: url, size: desiredSize)
            
            image = thumbnail
        } catch {
            print("Error \(error) happened when fetching url: \(url).")
        }
    }
}
