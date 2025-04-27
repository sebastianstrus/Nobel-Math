//
//  GradientBackground.swift
//  Matematik
//
//  Created by Sebastian Strus on 2025-04-27.
//

import SwiftUI

struct GradientBackground: View {
    
    @EnvironmentObject var settings: SettingsManager
    
    var body: some View {
        
        let lightColors: [Color] = [Color.cyan.opacity(0.05), Color.blue.opacity(0.1)]
        let darkColors: [Color] = [Color(red: 5/255, green: 10/255, blue: 13/255), Color(red: 15/255, green: 6/255, blue: 20/255)]
        
        LinearGradient(
            gradient: Gradient(colors: settings.isDarkMode ? darkColors : lightColors),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}
