//
//  MemeApp.swift
//  I'm just a memer
//
//  Created by Petr Palata on 15.06.2021.
//

import SwiftUI

@main
struct MemeApp: App {
    var body: some Scene {
        WindowGroup {
            MemeGallery(viewModel: MemeTypeViewModel())
        }
    }
}
