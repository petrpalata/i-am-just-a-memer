//
//  CachedAsyncImage.swift
//  I'm just a memer
//
//  Created by Petr Palata on 18.06.2021.
//

import SwiftUI

struct CachedAsyncImage<I: View, P: View>: View {
    @ObservedObject var viewModel = CachedAsyncImageViewModel()
    
    let content: (Image) -> I
    let placeholder: () -> P
    let url: URL?
    
    public init(
        url: URL?,
        @ViewBuilder content: @escaping (Image) -> I,
        @ViewBuilder placeholder: @escaping () -> P
    ) {
        self.url = url
        self.content = content
        self.placeholder = placeholder
    }
    
    var body: some View {
        makeView()
    }
    
    private func makeView() -> some View {
        guard let image = viewModel.image else {
            return AnyView(placeholder().background {
                GeometryReader { proxy in
                    Color.clear.onAppear {
                        async {
                            await viewModel.fetchImage(url, desiredSize: proxy.size)
                        }
                    }
                }
            })
        }
        
        return AnyView(content(Image(uiImage: image)))
    }
}
