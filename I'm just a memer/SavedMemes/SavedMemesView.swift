//
//  SavedMemesView.swift
//  I'm just a memer
//
//  Created by Petr Palata on 22.06.2021.
//

import SwiftUI

struct SavedMemesView: View {
    @ObservedObject var viewModel: SavedMemesViewModel
    
    var body: some View {
        GeometryReader { proxy in
            VStack {
                if viewModel.loading {
                    Spacer()
                    ProgressView()
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack {
                            ForEach(viewModel.savedMemes, id: \.self) { memeImage in
                                Image(uiImage: memeImage)
                            }
                        }
                    }
                }
            }.task {
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
