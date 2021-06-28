//
//  SavedMemesView.swift
//  I'm just a memer
//
//  Created by Petr Palata on 22.06.2021.
//

import SwiftUI

struct SavedMemesView: View {
    @ObservedObject var viewModel: SavedMemesViewModel
    var items: [GridItem] = Array(repeating: .init(.adaptive(minimum: 120), spacing: 2), count: 3)
    
    var body: some View {
        GeometryReader { proxy in
            VStack {
                if viewModel.loading {
                    ProgressView()
                        .position(
                            x: proxy.frame(in: .local).midX,
                            y: proxy.frame(in: .local).midY
                        )
                } else {
                    ScrollView {
                        LazyVGrid(columns: items, spacing: 2) {
                            ForEach(viewModel.savedMemes, id: \.self.0.localIdentifier) { memeTuple in
                                GeometryReader { proxy in
                                    Image(uiImage: memeTuple.1)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(height: proxy.size.width, alignment: .center)
                                        .position(x: proxy.frame(in: .local).midX, y: proxy.frame(in: .local).midY)
                                        .overlay(
                                            Button(action: {
                                            viewModel.deleteMeme(memeTuple.0)
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
                                            }.opacity(viewModel.editing ? 1 : 0)
                                        )

                                }
                                .clipped()
                                .aspectRatio(1, contentMode: .fit)
                            }
                            .clipped()
                            .aspectRatio(1, contentMode: .fit)
                        }
                    }
                }
            }
            .navigationBarTitle("Saved Memes")
            .navigationBarItems(trailing: Button(viewModel.editing ? "Done" : "Edit", action: { viewModel.editing.toggle() }))
            .task {
                try? viewModel.loadMemesFromStorage(proxy.size.width)
            }
        }
    }
}

struct SavedMemesView_Previews: PreviewProvider {
    static var previews: some View {
        SavedMemesView(viewModel: SavedMemesViewModel())
    }
}
