//
//  WelcomeView.swift
//  Matematik
//
//  Created by Sebastian Strus on 2025-04-27.
//

import SwiftUI

struct WelcomeView: View {
    
    @EnvironmentObject var settings: SettingsManager
    
    @State private var isStartButtonAnimating = false
    @State private var showSettings = false
    @State private var showLearn = false
    

    let titleSize: CGFloat = {
        UIDevice.current.userInterfaceIdiom == .pad ? 60 : 40
    }()
    
    let subtitleSize: CGFloat = {
        UIDevice.current.userInterfaceIdiom == .pad ? 35 : 20
    }()
    
    let buttonWidth: CGFloat = {
        UIDevice.current.userInterfaceIdiom == .pad ? 150 : 120
    }()
    
    let buttonHeight: CGFloat = {
        UIDevice.current.userInterfaceIdiom == .pad ? 60 : 40
    }()
    
    let buttonSize: CGFloat = {
        UIDevice.current.userInterfaceIdiom == .pad ? 60 : 46
    }()
    
    let cornerRadius: CGFloat = {
        UIDevice.current.userInterfaceIdiom == .pad ? 12 : 8
    }()

    var body: some View {
        NavigationStack {
            ZStack {
                // Background Image
                LoopingVideoPlayer(videoName: "background_video", videoType: "mov")
                    .ignoresSafeArea()
                    .overlay(Color.black.opacity(0.6))
                
//                if UIDevice.current.userInterfaceIdiom == .pad {
//                    Image("roblox")
//                        .resizable()
//                        .scaledToFill()
//                        .overlay(Color.black.opacity(0.4))
//                        .ignoresSafeArea()
//                } else {
//                    Image("roblox2")
//                        .resizable()
//                        .scaledToFill()
//                        .overlay(Color.black.opacity(0.4))
//                        .ignoresSafeArea()
//                }
                

                VStack(spacing: 20) {
                    Spacer()

                    // Title
                    Text("Nobla Math")
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


                    // Start Button
                    Button(action: {
                        showLearn = true
                    }) {
                        Text("Start")
                            .font(Font.system(size: 20))
                            .fontWeight(.bold)
                            .frame(width: buttonWidth, height: buttonHeight, alignment: .center)
                            .background(Color.blue.opacity(0.93))
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                            .overlay(
                                RoundedRectangle(cornerRadius: cornerRadius)
                                    .stroke(Color.white, lineWidth: 1)
                            )
                            .scaleEffect(isStartButtonAnimating ? 1.1 : 1.0)
                            .padding()
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.bottom, 40)
                    .onAppear {
                        withAnimation(Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                            isStartButtonAnimating = true
                        }
                    }
                    
                    Spacer()
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            showSettings = true
                        }) {
                            Image(systemName: "gear")
                                .font(.title2)
                                .foregroundColor(.white)
                                .padding()
                        }
                    }
                }
                .navigationDestination(isPresented: $showSettings) {
                    SettingsView()
                }
                .navigationDestination(isPresented: $showLearn) {
                    LearnView().environmentObject(settings)
                }
            }
        }
    }
}


struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
