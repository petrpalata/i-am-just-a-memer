//
//  SaveMemeSheetView.swift
//  I'm just a memer
//
//  Created by Petr Palata on 27.06.2021.
//

import SwiftUI

struct SaveMemeConfirmationSheet: View {
    @Environment(\.dismiss) var dismiss
    
    @StateObject var saveViewModel: SaveMemeButtonViewModel
    
    var body: some View {
        VStack {
            if saveViewModel.errorPresent {
                Text("An error occured when saving the meme image: \(saveViewModel.errorMessage).")
                    .padding(50)
                    .foregroundColor(Color.red)
            } else {
                Text("Tapping Confirm saves the generated meme into Photos. Proceed?")
                    .padding(50)
                    .foregroundColor(Color.accentColor)
            }
            
            HStack {
                if !saveViewModel.savingInProgress {
                    Button("Cancel") {
                        dismiss()
                    }
                    .background(Color.red)
                    
                    Button(saveViewModel.confirmButtonLabel) {
                        async {
                            await saveViewModel.saveMemeToPhotos()
                        }
                    }.buttonStyle(GenerateMemeButtonStyle())
                } else {
                    Text("Saving to Photos...").padding(.trailing, 20)
                    ProgressView()
                }
            }
        }
    }
}
