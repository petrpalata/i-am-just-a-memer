//
//  MemePlaceholder.swift
//  I'm just a memer
//
//  Created by Petr Palata on 16.06.2021.
//

import SwiftUI

struct MemePlaceholder: View {
    @State var animationRunning: Bool = false
    
    let memeImageWidth: CGFloat
    let memeImageHeight: CGFloat
    
    var body: some View {
        ZStack {
            Color(uiColor: animationRunning ? .systemGray4 : .systemGray5)
                .animation(pulseAnimation)
            
            ZStack {
                Image(systemName: "photo")
                    .font(.system(size: 100.0))
                    .foregroundColor(.gray)
                    .opacity(animationRunning ? 0 : 1)
                    .animation(pulseAnimation)
                Image(systemName: "photo")
                    .font(.system(size: 100.0))
                    .foregroundColor(Color(uiColor: .darkGray))
                    .opacity(animationRunning ? 1 : 0)
                    .animation(pulseAnimation)
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .aspectRatio(
                CGSize(width: memeImageWidth, height: memeImageHeight),
                contentMode: .fit
            )
        }
        .cornerRadius(5.0)
        .onAppear(perform: {
            animationRunning = true
        })
    }
        
    private var pulseAnimation: Animation {
        return .linear(duration: 0.5).repeatForever()
    }
}
