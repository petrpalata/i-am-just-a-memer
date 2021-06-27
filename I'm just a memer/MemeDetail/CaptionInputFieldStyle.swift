//
//  CaptionInputFieldStyle.swift
//  I'm just a memer
//
//  Created by Petr Palata on 26.06.2021.
//

import SwiftUI

struct CaptionInputFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<_Label>) -> some View {
        configuration
            .padding(EdgeInsets(top: 10, leading: 50, bottom: 10, trailing: 20))
            .overlay(borderWithIconOverlay)
    }
    
    private var borderWithIconOverlay: some View {
        GeometryReader {
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.accentColor, lineWidth: 1)
                .overlay(captionIcon($0.size.height), alignment: .leading)
                .frame(minWidth: $0.size.width)
        }
    }
    
    private func captionIcon(_ height: CGFloat) -> some View {
        Image(systemName: "captions.bubble")
            .foregroundColor(Color.white)
            .frame(width: 40, height: height, alignment: .center)
            .background(Color.accentColor)
            .clipShape(
                UnevenRoundedRectangle(
                    corners: [.topLeft, .bottomLeft],
                    size: 10
                )
            )
    }
}
