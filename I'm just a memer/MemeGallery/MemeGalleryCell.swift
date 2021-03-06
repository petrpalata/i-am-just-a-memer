//
//  MemeGalleryCell.swift
//  I'm just a memer
//
//  Created by Petr Palata on 14.06.2021.
//

import SwiftUI

struct MemeGalleryCell: View {
    let imageUrl: URL?
    let width: CGFloat
    let height: CGFloat
    
    var body: some View {
        VStack {
            CachedAsyncImage(url: imageUrl) { image in
                image.cornerRadius(10.0).shadow(radius: 2.0)
            } placeholder: {
                MemePlaceholder(
                    memeImageWidth: width,
                    memeImageHeight: height
                )
            }
        }
    }
}

