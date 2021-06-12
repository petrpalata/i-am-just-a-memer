//
//  MemePickerRow.swift
//  I'm just a memer
//
//  Created by Petr Palata on 12.06.2021.
//

import Foundation
import SwiftUI

struct MemePickerRow: View {
    var viewModel: MemeTypeViewModel
    var meme: Meme
    
    var body: some View {
        Button(action: {
            viewModel.selection = meme
        }) {
            HStack {
                if let image = meme.image {
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: 32, height: 32)
                } else {
                    AsyncImage(url: meme.imageUrl) { image in
                        image.resizable()
                    } placeholder: {
                        ProgressView()
                    }.frame(width: 32, height: 32)
                }
                Text(meme.name)
            }
        }
    }
    
}
