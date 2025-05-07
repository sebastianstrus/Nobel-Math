//
//  Matematik2App.swift
//  Matematik2
//
//  Created by Sebastian Strus on 2025-02-04.
//

import SwiftUI

@main
struct Matematik2App: App {
    
    @StateObject private var settings = SettingsManager.shared
    @StateObject private var videoViewModel = VideoPlayerViewModel.shared
    
    var body: some Scene {
        WindowGroup {
            WelcomeView()
                .environmentObject(settings)
                .environmentObject(videoViewModel)
                .preferredColorScheme(settings.isDarkMode ? .dark : .light)
        }
    }
}
