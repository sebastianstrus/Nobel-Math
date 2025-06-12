//
//  WelcomeView.swift
//  Matematik
//
//  Created by Sebastian Strus on 2025-04-27.
//

import SwiftUI
import StoreKit

struct WelcomeContentView: View {
    @EnvironmentObject private var purchaseManager: PurchaseManager
    
    var body: some View {
        TransparentNavigationView {
            WelcomeView()
        }
        .ignoresSafeArea()
        .task {
            do {
                try await purchaseManager.loadProducts()
            } catch {
                print("Error loading products: \(error)")
            }
        }
    }
}



struct WelcomeView: View {
    
    @EnvironmentObject private var purchaseManager: PurchaseManager
    @EnvironmentObject private var settings: SettingsManager
    @EnvironmentObject private var videoViewModel: VideoPlayerViewModel
    
    @State private var showSettings = false
    
    @State private var selectedProductId = "com.sebastianstrus.noblamathapp.premium.monthly"
    
    let titleSize: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 60 : 40
    let subtitleSize: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 35 : 20
    
    let startButtonWidth: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 150 : 120
    let startButtonHeight: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 48 : 40
    
    
    let buttonWidth: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 320 : 280
    let buttonHeight: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 80 : 70
    let cornerRadius: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 16 : 12
    
    var body: some View {
        ZStack {
            LoopingVideoPlayer(viewModel: videoViewModel)
                .ignoresSafeArea()
                .overlay(Color.black.opacity(0.6))
            
            VStack {
                
                Spacer()
                Spacer()
                
                Group {
                    Text("Nobel Math")
                        .font(.system(size: titleSize, weight: .bold, design: .rounded))
                        .foregroundStyle(.white.opacity(0.9))
                        .shadow(color: .black.opacity(0.8), radius: 3, x: 3, y: 3)
                    
                    Text("Discover the Joy of Numbers.")
                        .font(.system(size: subtitleSize, weight: .regular, design: .rounded))
                        .foregroundStyle(.white.opacity(0.9))
                        .shadow(color: .black.opacity(0.8), radius: 2, x: 2, y: 2)
                }
                
                Spacer()
                Spacer()
                
                Group {
                    if purchaseManager.hasUnlockedPro {
                        NavigationLink(destination: LearnView().environmentObject(settings)) {
                            Text("Start")
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                                .padding(.horizontal, 40)
                                .padding(.vertical, 16)
                                .background(
                                    Capsule()
                                        .fill(LinearGradient(gradient: Gradient(colors: [.blue, .purple]),
                                                             startPoint: .leading,
                                                             endPoint: .trailing))
                                )
                                .shadow(color: .purple.opacity(0.4), radius: 10, x: 0, y: 4)
                            
                            
                            
                        }
                    } else {
                        
                        if let product = purchaseManager.products.first {
                            Button {
                                selectedProductId = product.id
                            } label: {
                                SubscriptionButton(
                                    id: product.id,
                                    price: product.displayPrice,
                                    title: "Nobel Math Premium Monthly".localized,
                                    subtitle: "Math magic delivered each month!".localized,
                                    highlight: product.id == selectedProductId,
                                    period:  "/month".localized,
                                    features: ["Full Access".localized, "No Ads".localized, "Cancel Anytime".localized]
                                ).frame(maxWidth: 440)
                                
                            }.padding(.horizontal)
                                .padding(.bottom, 8)
                        }
                        
                        
                        
                        if let product = purchaseManager.products.last {
                            Button {
                                selectedProductId = product.id
                            } label: {
                                SubscriptionButton(
                                    id: product.id,
                                    price: product.displayPrice,
                                    title: "Nobel Math Premium Yearly".localized,
                                    subtitle: "Save more and learn all year long!".localized,
                                    highlight: product.id == selectedProductId,
                                    period:  "/year".localized,
                                    features: ["Full Access".localized, "No Ads".localized, "Best Value".localized]
                                ).frame(maxWidth: 440)
                                
                            }.padding(.horizontal)
                        }
                        
                        
                        
//                        ForEach(purchaseManager.products) { product in
//                            Button {
//                                selectedProductId = product.id
//                            } label: {
//                                SubscriptionButton(
//                                    id: product.id,
//                                    price: product.displayPrice,
//                                    title: product.displayName,
//                                    subtitle: product.description,
//                                    highlight: product.id == selectedProductId,
//                                    period:  product.id == ProductIDs.monthly ?
//                                    "/month".localized : "/year".localized,
//                                    features: product.id == ProductIDs.monthly ?
//                                    ["Full Access".localized, "No Ads".localized, "Cancel Anytime".localized] :
//                                        ["Full Access".localized, "No Ads".localized, "Best Value".localized]
//                                ).frame(maxWidth: 440)
//                                
//                            }.padding(.horizontal)
//                        }
                        
                        
                        Spacer()
                        
                        Button {
                            if let product = purchaseManager.products.first(where: { $0.id == selectedProductId }) {
                                Task {
                                    do {
                                        try await purchaseManager.purchase(product)
                                    } catch {
                                        print(error)
                                    }
                                }
                            }
                        } label: {
                            Text("Subscribe")
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                                .padding(.horizontal, 40)
                                .padding(.vertical, 16)
                                .background(
                                    Capsule()
                                        .fill(LinearGradient(gradient: Gradient(colors: [.blue, .purple]),
                                                             startPoint: .leading,
                                                             endPoint: .trailing))
                                )
                                .shadow(color: .purple.opacity(0.4), radius: 10, x: 0, y: 4)
                        }.padding(.horizontal)
                        
                        
                        
                        //                        Button {
                        //                            _ = Task {
                        //                                do {
                        //                                    try await AppStore.sync()
                        //                                } catch {
                        //                                    print(error)
                        //                                }
                        //                            }
                        //                        } label: {
                        //                            Text("Restore Purchases")
                        //                                .font(.subheadline)
                        //                                .foregroundColor(.cyan)
                        //                                .padding(.vertical, 10)
                        //                                .padding(.horizontal, 24)
                        //                                .background(Color.black.opacity(0.3))
                        //                                .clipShape(Capsule())
                        //                                .shadow(color: .cyan, radius: 8)
                        //                        }
                    }
                    Spacer()
                }
                
            }
            .frame(maxHeight: .infinity)

            .toolbar {
                if purchaseManager.hasUnlockedPro {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: SettingsView()) {
                            Image(systemName: "gear")
                                .font(.title2)
                                .foregroundColor(.white)
                                .padding()
                        }
                    }
                }
            }
        }
        .ignoresSafeArea()
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



struct SubscriptionButton: View {
    let id: String
    let price: String
    let title: String
    let subtitle: String
    let highlight: Bool
    let period: String
    let features: [String]
    
    var body: some View {
        ZStack {
            // Main container with border
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    highlight ?
                    LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.2), Color.purple.opacity(0.2)]),
                                   startPoint: .topLeading,
                                   endPoint: .bottomTrailing) :
                        LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0.3), Color.black.opacity(0.5)]),
                                       startPoint: .topLeading,
                                       endPoint: .bottomTrailing)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            highlight ?
                            LinearGradient(gradient: Gradient(colors: [.blue, .purple]),
                                           startPoint: .topLeading,
                                           endPoint: .bottomTrailing) :
                                LinearGradient(gradient: Gradient(colors: [.white.opacity(0.5), .white.opacity(0.5)]),
                                               startPoint: .topLeading,
                                               endPoint: .bottomTrailing),
                            lineWidth: highlight ? 3 : 1.5
                        )
                )
                .shadow(color: highlight ? .blue.opacity(0.5) : .clear, radius: 10, x: 0, y: 4)
            
            VStack(alignment: .leading, spacing: 8) {
                // Price and period
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text(price)
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                    Text(period)
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .opacity(0.8)
                    
                    Spacer()
                    
                    if highlight {
                        PremiumBadge(badgeText: id == ProductIDs.monthly ? "Popular".localized.uppercased() : "Best Value".localized.uppercased())
                    }
                }
                
                Text(title)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .padding(.bottom, 2)
                
                Text(subtitle)
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .opacity(0.9)
                
                VStack(alignment: .leading, spacing: 8) {
                    
                    if features.count == 3 {
                        FeatureRow(icon: "checkmark.circle.fill", text: features[0])
                        //                        Spacer(minLength: 0)
                        FeatureRow(icon: "checkmark.circle.fill", text: features[1])
                        //                        Spacer(minLength: 0)
                        FeatureRow(icon: "checkmark.circle.fill", text: features[2])
                        
                    }
                    
                }
                .padding(.top, 8)
            }
            .padding(.horizontal, 16)
            .foregroundColor(.white)
        }
        .frame(height: highlight ? 210 : 190)
    }
}

struct PremiumBadge: View {
    
    let badgeText: String
    
    var body: some View {
        Text(badgeText)
            .font(.system(size: 12, weight: .black, design: .rounded))
            .foregroundColor(.white)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(
                Capsule()
                    .fill(LinearGradient(gradient: Gradient(colors: [.yellow, .orange]),
                                         startPoint: .leading,
                                         endPoint: .trailing))
                    .shadow(color: .orange.opacity(0.5), radius: 3, x: 0, y: 2)
            )
    }
}

struct FeatureRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundColor(.green)
                .font(.system(size: 14))
            Text(text)
                .font(.system(size: 12, weight: .medium, design: .rounded))
        }
    }
}
