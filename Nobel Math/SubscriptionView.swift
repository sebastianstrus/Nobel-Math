//
//  SubscribtionView.swift
//  Nobel Math
//
//  Created by Sebastian Strus on 6/14/25.
//

import SwiftUI
import StoreKit

struct SubscriptionView: View {
    
    @EnvironmentObject private var purchaseManager: PurchaseManager
    @EnvironmentObject private var settings: SettingsManager
    @EnvironmentObject private var videoViewModel: VideoPlayerViewModel
    
    @State private var showSettings = false
    
    @State private var selectedProductId = "com.sebastianstrus.noblamathapp.premium.monthly"
    
    let titleSize: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 60 : 30
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
                    Text("Try Premium".localized)
                        .font(.system(size: titleSize, weight: .bold, design: .rounded))
                        .foregroundStyle(.white.opacity(0.9))
                        .shadow(color: .black.opacity(0.8), radius: 3, x: 3, y: 3)
                        .padding(.top, UIDevice.current.userInterfaceIdiom == .pad ? 50 : 20)
                    
//                    Text("Discover the Joy of Numbers.")
//                        .font(.system(size: subtitleSize, weight: .regular, design: .rounded))
//                        .foregroundStyle(.white.opacity(0.9))
//                        .shadow(color: .black.opacity(0.8), radius: 2, x: 2, y: 2)
                }
                
                Spacer()
                Spacer()
                
                Group {

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
                        
                        
                        
                    Button {
                        _ = Task {
                            do {
                                try await AppStore.sync()
                            } catch {
                                print(error)
                            }
                        }
                    } label: {
                        Text("Restore Purchases".localized)
                            .font(.subheadline)
                            .foregroundColor(.cyan)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 24)
                        //                                .background(Color.black.opacity(0.3))
                        //                                .clipShape(Capsule())
                        //                                .shadow(color: .cyan, radius: 8)
                    }
                    
                    LegalLinksView()
                    
                    Spacer()
                }
                
            }
            .frame(maxHeight: .infinity)

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
        }
        .ignoresSafeArea()
    }
}
