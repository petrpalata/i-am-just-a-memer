//
//  CachedAsyncImageViewModel.swift
//  I'm just a memer
//
//  Created by Petr Palata on 18.06.2021.
//

import SwiftUI
import UIKit

class CachedAsyncImageViewModel: ObservableObject {
    let session = URLSession.shared
    
    @Published var image: UIImage?

    func fetchImage(_ url: URL?) async {
        guard let url = url else {
            return
        }
        
        do {
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
}
