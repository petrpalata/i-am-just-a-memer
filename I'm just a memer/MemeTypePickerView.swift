//
//  MemeTypePickerViewController.swift
//  I'm just a memer
//
//  Created by Petr Palata on 11.06.2021.
//

import Foundation
import SwiftUI

struct MemeTypePickerView: View {
    @State var loading: Bool = true
    var memes: [Meme] = []
    
    var body: some View {
        if loading {
            ProgressView()
        } else {
            List(memes) { meme in
                Text(meme.name)
            }
        }
    }
}

struct MemeTypePickerView_Previews: PreviewProvider {
    static var previews: some View {
        MemeTypePickerView(
            memes: [
                Meme(image: nil, name: "Test meme 1"),
                Meme(image: nil, name: "Test meme 2"),
                Meme(image: nil, name: "Test meme 3"),
                Meme(image: nil, name: "Test meme 4"),
                Meme(image: nil, name: "Test meme 5"),
                Meme(image: nil, name: "Test meme 6")
            ]
        )
    }
}
