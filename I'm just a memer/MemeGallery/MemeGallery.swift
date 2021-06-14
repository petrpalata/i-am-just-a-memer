//
//  MemeGallery.swift
//  I'm just a memer
//
//  Created by Petr Palata on 14.06.2021.
//

import SwiftUI

struct MemeGallery: View {
    @State var searchText: String = ""
    @ObservedObject var viewModel: MemeTypeViewModel
    
    var items: [GridItem] {
        return Array(repeating: .init(.adaptive(minimum: 120)), count: 2)
    }
   
    var body: some View {
        VStack {
            TextField("Search ...", text: $searchText)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal, 10)
            
            if viewModel.loading {
                ProgressView()
            } else {
                ScrollView(.vertical) {
                    LazyVGrid(columns: items) {
                        ForEach(viewModel.memes, id: \.self) { meme in
                            MemeGalleryCell(imageUrl: meme.imageUrl, width: meme.width, height: meme.height)
                        }
                    }
                }
            }
        }
        .padding()
        .onAppear {
            async {
                await viewModel.fetchMemes()
            }
        }
    }
}

struct MemeGallery_Previews: PreviewProvider {
    static var previews: some View {
        MemeGallery(viewModel: MemeTypeViewModel())
.previewInterfaceOrientation(.landscapeLeft)
    }
}
