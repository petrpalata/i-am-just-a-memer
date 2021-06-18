//
//  MemeCache.swift
//  I'm just a memer
//
//  Created by Petr Palata on 18.06.2021.
//

import Foundation
import UIKit

enum MemeCacheError: Error {
    case imageScalingFailed
}

class MemeCache {
    static var shared = MemeCache()
    
    private var cache: [String : UIImage] = [:]
    
    func fetchThumbnail(_ url: URL, size: CGSize) -> UIImage? {
        let hash = computeHash(url, size: size)
        return cache[hash]
    }
    
    func cacheThumnail(_ originalImage: UIImage, url: URL, size: CGSize) throws -> UIImage {
        let hash = computeHash(url, size: size)
        let thumbnail = imageWithImage(originalImage, scaledToSize: size)
        guard let thumbnail = thumbnail else {
            throw MemeCacheError.imageScalingFailed
        }

        cache[hash] = thumbnail
        return thumbnail
    }
    
    private func computeHash(_ url: URL, size: CGSize) -> String {
        return "\(url.path):\(size.width):\(size.height)"
    }
    
    private func imageWithImage(_ image: UIImage, scaledToSize newSize: CGSize) -> UIImage? {
        defer {
            UIGraphicsEndImageContext()
        }
        
        let thumbnailSize = thumbnailSize(originalSize: image.size, desiredSize: newSize)
        UIGraphicsBeginImageContextWithOptions(thumbnailSize, false, 0.0);
        let thumbnailRect = CGRect(
            x: 0.0,
            y: 0.0,
            width: thumbnailSize.width,
            height: thumbnailSize.height
        )
        
        image.draw(in: thumbnailRect)
        let scaledImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        return scaledImage
    }
    
    private func thumbnailSize(originalSize: CGSize, desiredSize: CGSize) -> CGSize {
        let aspectWidth = desiredSize.width / originalSize.width
        let aspectHeight = desiredSize.height / originalSize.height
        let aspectRatio = min(aspectWidth, aspectHeight)
              
        return CGSize(width: originalSize.width * aspectRatio, height: originalSize.height * aspectRatio)
    }
}
