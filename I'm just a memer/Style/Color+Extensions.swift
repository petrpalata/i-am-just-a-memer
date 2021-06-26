//
//  Color+Extensions.swift
//  I'm just a memer
//
//  Created by Petr Palata on 26.06.2021.
//

import SwiftUI
import UIKit

public extension Color {
    init?(named: String) {
        guard let uiColor = UIColor(named: named) else {
            return nil
        }
        
        self.init(uiColor: uiColor)
    }
}

