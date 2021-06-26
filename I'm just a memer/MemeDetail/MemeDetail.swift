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
                    Image(uiImage: memeImage).resizable().aspectRatio(contentMode: .fit).cornerRadius(5.0).shadow(radius: 2.0)
                } else {
                    MemePlaceholder(memeImageWidth: Int(viewModel.meme.width), memeImageHeight: Int(viewModel.meme.height))
                }
                ForEach(0..<viewModel.meme.boxCount, id: \.self) { index in
                    CaptionInputField(
                        captionIndex: index,
                        captionInput: $viewModel.captionInputs[index]
                    )
                }
                
                GenerateMemeButton { await viewModel.generateMeme() }
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 40, trailing: 0))
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
            Alert(title: Text("API Error"), message: Text(viewModel.errorMessage!), dismissButton: .cancel())
        }.sheet(isPresented: $showShareView, content: {
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
        Button(action: {
            async {
                await viewModel.saveMemeToPhotos()
            }
        }) {
            Label("", systemImage: "tray.and.arrow.down")
        }
        .disabled(viewModel.generatedMeme == nil)
    }
}
