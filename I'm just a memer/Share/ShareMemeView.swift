//
//  ShareMemeView.swift
//  I'm just a memer
//
//  Created by Petr Palata on 15.06.2021.
//

import SwiftUI

struct ShareMemeView: View {
    let memeImage: UIImage
    
    var body: some View {
        VStack {
            Image(uiImage: memeImage).resizable().aspectRatio(contentMode: .fit)
            
            Button("Share on Instagram", action: {
                print("Shared on Instagram")
            }).buttonStyle(SocialMediaButton())
            Button(action: {
                print("Shared on Facebook")
            }) {
                Label("Share on Facebook", systemImage: "pencil")
            }.buttonStyle(SocialMediaButton())
            Spacer()
        }.navigationTitle("Share")
    }
}


struct SocialMediaButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color(red: 0, green: 0, blue: 0.5))
            .foregroundColor(.white)
            .clipShape(Capsule())
        
    }
}
