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
                Button("Generate Meme", role: nil, action: {
                    await viewModel.generateMeme()
                })
            }
        }
        .padding(.horizontal, 20)
        .navigationBarHidden(false)
        .navigationBarTitle(viewModel.meme.name)
        .navigationBarItems(trailing:
            HStack {
                shareButton
            }
        )
        .alert(isPresented: $viewModel.errorPresent) {
            Alert(title: Text("API Error"), message: Text(viewModel.errorMessage!), dismissButton: .cancel())
        }.sheet(isPresented: $showShareView, content: {
            ActivityViewController(activityItems: [viewModel.generatedMeme as Any])
        })
        .onAppear {
            async {
                await viewModel.generateStubMeme()
            }
        }
    }
                            
    
    var shareButton: some View {
        Button(action: {
            showShareView = true
        }) {
            Label("", systemImage: "square.and.arrow.up")
        }.disabled(viewModel.generatedMeme == nil)
    }
}
