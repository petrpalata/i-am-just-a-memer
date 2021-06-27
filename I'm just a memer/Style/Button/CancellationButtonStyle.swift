//
//  CancellationButtonStyle.swift
//  I'm just a memer
//
//  Created by Petr Palata on 27.06.2021.
//

import SwiftUI

struct CancellationButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(configuration.isPressed ? Color.memerCancelButtonPressed : Color.memerCancel)
            .foregroundColor(.white)
            .cornerRadius(10.0)
            .font(Font.title3.bold())
    }
}
