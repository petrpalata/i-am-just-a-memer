//
//  Array+PHAsset.swift
//  I'm just a memer
//
//  Created by Petr Palata on 24.06.2021.
//

import Foundation
import Photos
import UIKit

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
