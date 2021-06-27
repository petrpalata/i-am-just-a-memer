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
                StaticImageWithAnimatedPlaceholder(image: viewModel.displayableMeme,
                                                   placeholderWidth: viewModel.meme.width,
                                                   placeholderHeight: viewModel.meme.height)
                    .padding(.bottom, 10)
                    .frame(maxHeight: 300)
                
                ForEach(0..<viewModel.meme.boxCount, id: \.self) { index in
                    CaptionInputField(
                        captionIndex: index,
                        captionInput: $viewModel.captionInputs[index]
                    )
                }
                
                GenerateMemeButton { await viewModel.generateMeme() }
                
                .padding(.bottom, 40)
            }.padding(.horizontal, 20)
        }
        .navigationBarHidden(false)
        .navigationBarTitle(viewModel.meme.name)
        .navigationBarItems(trailing:
                                HStack {
            saveMemeButton
            shareButton
        }
        )
        .alert(isPresented: $viewModel.errorPresent) {
            Alert(title: Text("Error"), message: Text(viewModel.errorMessage!), dismissButton: .cancel())
        }
        .sheet(isPresented: $showShareView, content: {
            ActivityViewController(activityItems: [viewModel.generatedMeme as Any])
        })
        .task {
            await viewModel.generateStubMeme()
        }
        
    }
    
    
    var shareButton: some View {
        Button(action: {
            showShareView = true
        }) {
            Label("", systemImage: "square.and.arrow.up")
        }.disabled(viewModel.generatedMeme == nil)
    }
    
    var saveMemeButton: some View {
        SaveMemeButton(viewModel: SaveMemeButtonViewModel(viewModel))
            .disabled(viewModel.generatedMeme == nil)
    }
}

