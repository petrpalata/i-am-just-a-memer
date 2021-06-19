//
//  GenerateMemeButtonStyle.swift
//  I'm just a memer
//
//  Created by Petr Palata on 18.06.2021.
//

import SwiftUI

struct GenerateMemeButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10.0)
            .font(Font.title3.bold())
    }
}


struct GenerateMemeButton: View {
    let action: () async -> Void
    
    var body: some View {
        Button(role: nil, action: action) {
            Label("Generate Meme", systemImage: "wand.and.stars")
        }.buttonStyle(GenerateMemeButtonStyle())
    }
}
