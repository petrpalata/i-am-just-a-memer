//
//  CachedAsyncImage.swift
//  I'm just a memer
//
//  Created by Petr Palata on 18.06.2021.
//

import SwiftUI

struct CachedAsyncImage<I: View, P: View>: View {
    @State var image: UIImage?
    
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
        async {
            guard let url = self.url else {
                return
            }
            
            do {
                let session = URLSession.shared
                let (imageData, _) = try await session.data(from: url, delegate: nil)
                
                guard let uiImage = UIImage(data: imageData) else {
                    print("Failed to construct UIImage from image data")
                    return
                }
                
                image = uiImage
            } catch {
                print("Error \(error) happened when fetching url: \(url).")
            }
        }
        
        guard let image = self.image else {
            return AnyView(placeholder())
        }
        
        return AnyView(content(Image(uiImage: image)))
    }
}
