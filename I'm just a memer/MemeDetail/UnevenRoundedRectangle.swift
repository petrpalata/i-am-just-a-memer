//
//  UnevenRoundedRectangle.swift
//  I'm just a memer
//
//  Created by Petr Palata on 26.06.2021.
//

import SwiftUI

struct UnevenRoundedRectangle: Shape {
    var corners: UIRectCorner
    var size: CGFloat
    
    func path(in rect: CGRect) -> Path {
        let bezierPath = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: size, height: size)
        )
        return Path(bezierPath.cgPath)
    }
}

