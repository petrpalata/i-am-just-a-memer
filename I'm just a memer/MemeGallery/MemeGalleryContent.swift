//
//  MemeGalleryContent.swift
//  I'm just a memer
//
//  Created by Petr Palata on 20.06.2021.
//

import SwiftUI

struct MemeGalleryContent: View {
    let memes: [Meme]
    let searchText: String
    let memeSplitter = MemeSplitter()
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView(.vertical) {
                HStack(alignment: .top) {
                    let searchMemes = searchedMemes()
                    let splitMemes = memeSplitter.splitMemesBasedOnHeight(
                        searchMemes,
                        columnWidth: proxy.size.width/2
                    )
                    let memeColumns = [splitMemes.0, splitMemes.1]
                    
                    ForEach(memeColumns, id: \.self) { memeColumn in
                        LazyVStack {
                            searchableMemesList(memeColumn)
                        }
                    }
                }
            }
        }
    }
    
    func searchableMemesList(_ memes: [Meme]) -> some View {
        return ForEach(memes, id: \.self) { meme in
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
    
    func searchedMemes() -> [Meme] {
        return memes.filter {
            if searchText.count == 0 {
                return true
            }
            return $0.name.contains(searchText)
        }
    }
}
