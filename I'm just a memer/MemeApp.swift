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
            TabView {
                NavigationView {
                    MemeGallery(viewModel: MemeTypeViewModel())
                }.tabItem {
                    Image(systemName: "wand.and.stars")
                    Text("Create")
                }
                
                NavigationView {
                    SavedMemesView(viewModel: SavedMemesViewModel())
                }.tabItem {
                    Image(systemName: "star")
                    Text("Saved")
                }
                
            }
        }
    }
}
