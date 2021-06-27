//
//  SaveMemeButtonViewModel.swift
//  I'm just a memer
//
//  Created by Petr Palata on 27.06.2021.
//

import SwiftUI

class SaveMemeButtonViewModel: ObservableObject {
    private let storage = MemePhotoKitStorage()
    private let memeDetailViewModel: MemeDetailViewModel
    
    @Published var showConfirmation: Bool = false
    @Published var savingInProgress: Bool = false
    @Published var errorPresent: Bool = false
    @Published var errorMessage: String = "Unknown Error"
    @Published var confirmButtonLabel: String = "Confirm"
    
    init(_ memeDetailViewModel: MemeDetailViewModel) {
        self.memeDetailViewModel = memeDetailViewModel
    }
    
    func saveMemeToPhotos() async {
        if !showConfirmation {
            showConfirmation = true
        } else {
            await confirmSave()
        }
    }
    
    func resetState() {
        savingInProgress = false
        errorPresent = false
        errorMessage = "Unknown Error"
    }
    
    private func confirmSave() async {
        defer {
            if !errorPresent {
                showConfirmation = false
            }
        }
        
        if let memeToSave = memeDetailViewModel.generatedMeme {
            do {
                savingInProgress = true
                try await storage.addMeme(memeToSave)
            } catch {
                errorMessage = "\(error)"
                errorPresent = true
                confirmButtonLabel = "Try again"
            }
        }
    }
}

