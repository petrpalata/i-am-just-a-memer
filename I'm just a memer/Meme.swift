//
//  Meme.swift
//  I'm just a memer
//
//  Created by Petr Palata on 11.06.2021.
//

import Foundation
import UIKit

struct Meme: Identifiable, Hashable {
    var id = UUID()
    var backendId: String
    
    var image: UIImage?
    var imageUrl: URL?
    var name: String
    
    var width: CGFloat
    var height: CGFloat
    var boxCount: Int
}
