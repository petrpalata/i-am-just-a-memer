//
//  SaveMemeButton.swift
//  I'm just a memer
//
//  Created by Petr Palata on 27.06.2021.
//

import SwiftUI

struct SaveMemeButton: View {
    @StateObject var viewModel: SaveMemeButtonViewModel
    
    var body: some View {
        Button(action: {
            async {
                await viewModel.saveMemeToPhotos()
            }
        }) {
            Label("", systemImage: "tray.and.arrow.down")
        }
        .sheet(isPresented: $viewModel.showConfirmation, onDismiss: {
            viewModel.resetState()
        }, content: {
            SaveMemeConfirmationSheet(saveViewModel: viewModel)
        })
    }
}


