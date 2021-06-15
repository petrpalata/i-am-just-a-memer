//
//  MemeDetail.swift
//  I'm just a memer
//
//  Created by Petr Palata on 15.06.2021.
//

import SwiftUI

struct MemeDetail: View {
    @StateObject var viewModel: MemeDetailViewModel
    
    var body: some View {
        ScrollView {
            VStack {
                if let imageStub = viewModel.memeImageStub {
                    Image(uiImage: imageStub).resizable().aspectRatio(contentMode: .fit)
                } else {
                    ProgressView()
                }
                ForEach(0..<viewModel.meme.boxCount, id: \.self) { index in
                    TextField("Caption \(index + 1)", text: $viewModel.captionInputs[index])
                        .padding(8)
                        .textFieldStyle(.roundedBorder)
                }
                Button("Generate Meme") {
                    //                viewModel.generateMeme()
                }
            }
        }
        .padding(8)
        .navigationBarHidden(false)
        .navigationBarTitle(viewModel.meme.name)
        .onAppear {
            async {
                try? await viewModel.generateStubMeme()
            }
        }
    }
}
