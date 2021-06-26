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
    
    var body: some View {
        VStack {
            TextField("Search ...", text: $searchText)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal, 10)

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
        .navigationBarTitle("")
        .navigationBarHidden(true)
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
