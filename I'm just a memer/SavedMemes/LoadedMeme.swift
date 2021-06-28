//
//  LoadedMeme.swift
//  I'm just a memer
//
//  Created by Petr Palata on 28.06.2021.
//

import Foundation
import UIKit
import Photos

struct LoadedMeme: Hashable {
    let asset: PHAsset
    let image: UIImage

    func hash(into hasher: inout Hasher) {
        hasher.combine(asset.localIdentifier)
    }
    
    static func ==(lhs: LoadedMeme, rhs: LoadedMeme) -> Bool {
        lhs.asset.localIdentifier == rhs.asset.localIdentifier
    }
}
