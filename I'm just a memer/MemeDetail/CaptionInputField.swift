//
//  CaptionInputField.swift
//  I'm just a memer
//
//  Created by Petr Palata on 18.06.2021.
//

import SwiftUI


struct CaptionInputField: View {
    let captionIndex: Int
    @Binding var captionInput: String
    
    var body: some View {
        TextField("Caption \(captionIndex + 1)", text: $captionInput)
            .textFieldStyle(CaptionInputFieldStyle())
            .padding(.bottom, 10)
    }
}
