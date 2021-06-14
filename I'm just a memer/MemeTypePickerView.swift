//
//  MemeTypePickerViewController.swift
//  I'm just a memer
//
//  Created by Petr Palata on 11.06.2021.
//

import Foundation
import SwiftUI

struct MemeTypePickerView: View {
    @ObservedObject var viewModel: MemeTypeViewModel
    var memes: [Meme] = []
    
    var body: some View {
        NavigationView {
            if viewModel.loading {
                ProgressView()
            } else {
                List(viewModel.memes) { meme in
                    MemePickerRow(viewModel: viewModel, meme: meme)
                }
            }
        }.task {
            await viewModel.fetchMemes()
        }
    }
}

//struct MemeTypePickerView_Previews: PreviewProvider {
//    static var previews: some View {
//        MemeTypePickerView(
//            viewModel: MemeTypeViewModel(),
//            memes: [
//                Meme(image: nil, name: "Test meme 1"),
//                Meme(image: nil, name: "Test meme 2"),
//                Meme(image: nil, name: "Test meme 3"),
//                Meme(image: nil, name: "Test meme 4"),
//                Meme(image: nil, name: "Test meme 5"),
//                Meme(image: nil, name: "Test meme 6")
//            ]
//        )
//    }
//}
