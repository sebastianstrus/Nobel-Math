//
//  WelcomeView.swift
//  Matematik
//
//  Created by Sebastian Strus on 2025-04-27.
//

import SwiftUI

struct WelcomeView: View {
    
    @EnvironmentObject var settings: SettingsManager
    @EnvironmentObject var videoViewModel: VideoPlayerViewModel
    
    @State private var showSettings = false
    
    
    let titleSize: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 60 : 40
    let subtitleSize: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 35 : 20
    let buttonWidth: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 150 : 120
    let buttonHeight: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 60 : 40
    let buttonSize: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 60 : 46
    let cornerRadius: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 12 : 8
    
    var body: some View {
        ZStack {
            LoopingVideoPlayer(viewModel: videoViewModel)
                .ignoresSafeArea()
                .overlay(Color.black.opacity(0.6))
            
            TransparentNavigationView {
                VStack(spacing: 20) {
                    Spacer()
                    
                    // Title
                    Text("Nobel Math")
                        .font(.system(size: titleSize, weight: .bold, design: .rounded))
                        .foregroundStyle(.white.opacity(0.9))
                        .shadow(color: .black.opacity(0.8), radius: 3, x: 3, y: 3)
                    
                    // Subtitle
                    Text("Discover the Joy of Numbers.")
                        .font(.system(size: subtitleSize, weight: .regular, design: .rounded))
                        .foregroundStyle(.white.opacity(0.9))
                        .shadow(color: .black.opacity(0.8), radius: 2, x: 2, y: 2)
                        .padding(.top, 0)
                    
                    Spacer()
                    
                    if UIDevice.current.userInterfaceIdiom == .phone {
                        Spacer()
                    }
                    
                    NavigationLink(destination: LearnView().environmentObject(settings)) {
                        PulsingButton(
                            title: "Start".localized,
                            width: buttonWidth,
                            height: buttonHeight,
                            cornerRadius: cornerRadius
                        )
                        .padding()
                    }
                    

                    
                   
                    
                    Spacer()
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: SettingsView()) {
                            Image(systemName: "gear")
                                .font(.title2)
                                .foregroundColor(.white)
                                .padding()
                                
                        }
                    }
                }
   
            }.ignoresSafeArea()
        }
    }
}



class TransparentHostingController<Content: View>: UIHostingController<Content> {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        navigationItem.hidesBackButton = true
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
            super.traitCollectionDidChange(previousTraitCollection)
            view.backgroundColor = .clear
        }
}
struct TransparentNavigationView<Content: View>: UIViewControllerRepresentable {
    @Environment(\.colorScheme) var colorScheme
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    func makeUIViewController(context: Context) -> UINavigationController {
        let rootVC = TransparentHostingController(rootView: content)
        let navController = UINavigationController(rootViewController: rootVC)
        
        updateAppearance(navController: navController)
        return navController
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        updateAppearance(navController: uiViewController)
    }
    
    private func updateAppearance(navController: UINavigationController) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear
        appearance.shadowColor = .clear
        
        // Update title color based on color scheme
        let titleColor: UIColor = colorScheme == .dark ? .white.withAlphaComponent(0.9) : .black.withAlphaComponent(0.8) // You can adjust this
        appearance.titleTextAttributes = [.foregroundColor: titleColor]
        
        navController.navigationBar.standardAppearance = appearance
        navController.navigationBar.scrollEdgeAppearance = appearance
        navController.navigationBar.compactAppearance = appearance
        navController.view.backgroundColor = .clear
        
        // Force update the navigation bar
        navController.navigationBar.setNeedsLayout()
        navController.navigationBar.layoutIfNeeded()
    }
}
