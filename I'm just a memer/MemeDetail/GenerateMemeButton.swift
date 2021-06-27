//
//  GenerateMemeButton.swift
//  I'm just a memer
//
//  Created by Petr Palata on 27.06.2021.
//

import SwiftUI

struct GenerateMemeButton: View {
    let action: () async -> Void
    
    var body: some View {
        Button(role: nil, action: action) {
            Label("Generate Meme", systemImage: "wand.and.stars")
        }.buttonStyle(MemerButtonStyle())
    }
}
