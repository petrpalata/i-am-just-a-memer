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
            AsyncImage(url: imageUrl) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                ProgressView().frame(width: 120, height: 120)
//                    .frame(idealWidth: width, idealHeight: height)
            }
        }
    }
}
