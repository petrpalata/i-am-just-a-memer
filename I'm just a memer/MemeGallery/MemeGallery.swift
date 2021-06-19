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
        NavigationView {
            VStack {
                TextField("Search ...", text: $searchText)
                    .padding(7)
                    .padding(.horizontal, 25)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                
                if viewModel.loading {
                    Spacer()
                    ProgressView()
                    Spacer()
                } else {
                    MemeGalleryContent(
                        memes: viewModel.memes,
                        searchText: searchText
                    )
                }
                Spacer()
            }
            .padding(.horizontal, 10)
            .navigationBarTitle("")
            .navigationBarHidden(true)
        }
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

struct MemeGalleryContent: View {
    let memes: [Meme]
    let searchText: String
    
    var body: some View {
        ScrollView(.vertical) {
            HStack(alignment: .top) {
                LazyVStack {
                    searchableMemesList(evenMemes)
                }
                LazyVStack {
                    searchableMemesList(oddMemes)
                }
            }
        }
    }
    
    func searchableMemesList(_ memes: [Meme]) -> some View {
        return ForEach(memes.filter {
            if searchText.count == 0 {
                return true
            }
            return $0.name.contains(searchText)
        },  id: \.self) { meme in
            NavigationLink(
                destination: MemeDetail(viewModel: MemeDetailViewModel(meme))
            ) {
                MemeGalleryCell(
                    imageUrl: meme.imageUrl,
                    width: meme.width,
                    height: meme.height
                )
            }
        }
    }
    
    var evenMemes: [Meme] {
        return memes
            .enumerated()
            .filter { $0.offset % 2 == 0 }
            .map { $0.element }
    }
    
    var oddMemes: [Meme] {
        return memes
            .enumerated()
            .filter { $0.offset % 2 != 0 }
            .map { $0.element }
    }
}
