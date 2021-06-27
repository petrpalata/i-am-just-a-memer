//
//  SaveMemeConfirmationSheet.swift
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
            Text(
                saveViewModel.errorPresent ?
                "An error occured when saving the meme image: \(saveViewModel.errorMessage)." :
                    "Tapping Confirm saves the generated meme into Photos.\nProceed?"
            )
                .padding(50)
                .foregroundColor(saveViewModel.errorPresent ? Color.memerCancel : Color.accentColor)
                .font(Font.title3.bold())
                .multilineTextAlignment(.center)
            
            HStack {
                if !saveViewModel.savingInProgress {
                    Button("Cancel") {
                        dismiss()
                    }
                    .buttonStyle(CancellationButtonStyle())
                    
                    Button(saveViewModel.confirmButtonLabel) {
                        async {
                            await saveViewModel.saveMemeToPhotos()
                        }
                    }.buttonStyle(MemerButtonStyle())
                } else {
                    Text("Saving to Photos...").padding(.trailing, 20)
                    ProgressView()
                }
            }
        }
    }
}
