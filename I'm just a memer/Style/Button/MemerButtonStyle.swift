//
//  MemerButtonStyle.swift
//  I'm just a memer
//
//  Created by Petr Palata on 18.06.2021.
//

import SwiftUI

struct MemerButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(configuration.isPressed ? Color.memerButtonPressed : Color.memerButtonDefault)
            .foregroundColor(.white)
            .cornerRadius(10.0)
            .font(Font.title3.bold())
    }
}

