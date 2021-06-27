//
//  ImageWithAnimatedPlaceholder.swift
//  I'm just a memer
//
//  Created by Petr Palata on 27.06.2021.
//

import SwiftUI

struct StaticImageWithAnimatedPlaceholder: View {
    var image: UIImage?
    var placeholderWidth: CGFloat
    var placeholderHeight: CGFloat

    var body: some View {
        if let image = image {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .cornerRadius(5.0)
                .shadow(radius: 2.0)
        } else {
            MemePlaceholder(
                memeImageWidth: placeholderWidth,
                memeImageHeight: placeholderHeight
            )
        }
    }
}
