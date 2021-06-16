//
//  MemeDetail.swift
//  I'm just a memer
//
//  Created by Petr Palata on 15.06.2021.
//

import SwiftUI

struct MemeDetail: View {
    @StateObject var viewModel: MemeDetailViewModel
    @State var showShareView: Bool = false
    
    var body: some View {
        ScrollView {
            VStack {
                if let memeImage = viewModel.generatedMeme ?? viewModel.memeImageStub {
                    Image(uiImage: memeImage).resizable().aspectRatio(contentMode: .fit)
                } else {
                    ProgressView()
                }
                ForEach(0..<viewModel.meme.boxCount, id: \.self) { index in
                    TextField("Caption \(index + 1)", text: $viewModel.captionInputs[index])
                        .padding(8)
                        .textFieldStyle(.roundedBorder)
                }
                Button("Generate Meme") {
                    async {
                        await viewModel.generateMeme()
                        showShareView = true
                    }
                }
            }
            
            if let generatedMeme = viewModel.generatedMeme {
                NavigationLink(destination: ShareMemeView(memeImage: generatedMeme), isActive: $showShareView) {}
            }
        }
        .padding(8)
        .navigationBarHidden(false)
        .navigationBarTitle(viewModel.meme.name)
        .alert(isPresented: $viewModel.errorPresent) {
            Alert(title: Text("API Error"), message: Text(viewModel.errorMessage!), dismissButton: .cancel())
        }
        .onAppear {
            async {
                await viewModel.generateStubMeme()
            }
        }
    }
}
