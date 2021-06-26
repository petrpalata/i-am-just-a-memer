//
//  MemerStyle.swift
//  I'm just a memer
//
//  Created by Petr Palata on 26.06.2021.
//

import SwiftUI
import UIKit

private enum MemerColors: String {
    case lightCyan = "MemerLightCyan"
    case cyan = "MemerCyan"
    case darkCyan = "MemerDarkCyan"
    case buttonPressed = "MemerButtonPressed"
    
    var color: Color? {
        Color(named: rawValue)
    }
}

extension Color {
    static var memerLightCyan: Color? { MemerColors.lightCyan.color }
    static var memerCyan: Color? { MemerColors.cyan.color }
    static var memerDarkCyan: Color? { MemerColors.darkCyan.color }
    static var memerButtonDefault: Color? { memerDarkCyan }
    static var memerButtonPressed: Color? { MemerColors.buttonPressed.color }
}
