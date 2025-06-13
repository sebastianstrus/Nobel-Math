//
//  Matematik2App.swift
//  Matematik2
//
//  Created by Sebastian Strus on 2025-02-04.
//

import SwiftUI
import StoreKit

@main
struct Nobel_MathApp: App {
    
    @State private var showSplash = true
    
    @StateObject private var purchaseManager = PurchaseManager()
    
    @StateObject private var settings = SettingsManager.shared
    @StateObject private var videoViewModel = VideoPlayerViewModel.shared
    
    
    var body: some Scene {
        WindowGroup {
            
            ZStack {
                WelcomeContentView()
                    .environmentObject(settings)
                    .environmentObject(videoViewModel)
                    .preferredColorScheme(settings.isDarkMode ? .dark : .light)
                    .environmentObject(purchaseManager)
                    
                
                if showSplash {
                    SplashView()
                        .transition(.opacity)
                        .zIndex(1)
                }
            }
            .animation(.easeInOut(duration: 1.0), value: showSplash)
            .task {
                await purchaseManager.updatePurchasedProducts()
                try? await Task.sleep(nanoseconds: 500_000_000)
                showSplash = false
            }

        }
    }
}

struct SplashView: View {
    
    let titleSize: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 60 : 40
    
    var body: some View {
        ZStack {
            // Gradient background
            LinearGradient(gradient: Gradient(colors: [.purple, .blue]),
                                 startPoint: .top,
                                 endPoint: .bottom)
            .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Image("SplashIcon")
                    .resizable()
                    .frame(width: 150, height: 150)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(color: .black.opacity(0.3), radius: 10, x: 5, y: 5)
                
                Text("Nobel Math")
                    .font(.system(size: titleSize, weight: .bold, design: .rounded))
                    .foregroundStyle(.white.opacity(0.9))
                    .shadow(color: .black.opacity(0.8), radius: 3, x: 3, y: 3)
                
                Spacer()
                Spacer()
            }
        }
    }
}

//    .overlay(
//        Rectangle()
//            .stroke(
//                Color.red,
//                lineWidth: 2
//            )
//    )
