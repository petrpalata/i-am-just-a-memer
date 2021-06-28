//
//  LoadedMemeView.swift
//  I'm just a memer
//
//  Created by Petr Palata on 28.06.2021.
//

import SwiftUI

struct LoadedMemeView: View {
    let meme: LoadedMeme
    @StateObject var savedMemesViewModel: SavedMemesViewModel
    
    var body: some View {
        GeometryReader { proxy in
            Image(uiImage: meme.image)
                .resizable()
                .scaledToFill()
                .frame(height: proxy.size.width, alignment: .center)
                .position(x: proxy.frame(in: .local).midX, y: proxy.frame(in: .local).midY)
                .overlay(
                    Button(action: {
                    savedMemesViewModel.deleteMeme(meme)
                }) {
                    VStack {
                        Image(systemName: "trash")
                            .resizable()
                            .frame(width: 20, height: 20, alignment: .center)
                            .padding(10)
                    }
                    .background(Color.white)
                    .clipShape(Circle())
                    .shadow(radius: 5)
                }.opacity(savedMemesViewModel.editing ? 1 : 0)
                )
            
        }
        .clipped()
        .aspectRatio(1, contentMode: .fit)
    }
}
