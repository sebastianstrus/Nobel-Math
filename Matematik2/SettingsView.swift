//
//  SettingsView.swift
//  Matematik
//
//  Created by Sebastian Strus on 2025-04-27.
//

import SwiftUI
import MessageUI

struct SettingsView: View {
    
    @EnvironmentObject var settings: SettingsManager
    
    @State private var showProgressAlert = false
    @State private var showCacheAlert = false
    @State private var showMailComposer = false
    @State private var showingLanguageHelp = false
    
    
    var body: some View {
        
        
//        VStack {
            
            List {
                
                Section(header: Text("Learning Settings".localized)) {
                    Picker("Difficulty Level".localized, selection: $settings.difficultyLevel) {
                        ForEach(DifficultyLevel.allCases, id: \.self) { level in
                            Text(level.localizedName).tag(level.rawValue)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    HStack(alignment: .center) {
                        Text("Example Count".localized)
                            .padding(.trailing, 10)
                        GradientSlider(value: settings.$exampleCount, range: 15...90, step: 15)
                    }.padding(.leading, 8)
                    

                    Toggle("Addition".localized, isOn: settings.$isAdditionOn)
                        .tint(.purple)
                        .disabled(settings.tabsEnabledCount == 1 && settings.isAdditionOn)
                    
                    
                    Toggle("Subtraction".localized, isOn: settings.$isSubtractionOn)
                        .tint(.purple)
                        .disabled(settings.tabsEnabledCount == 1 && settings.isSubtractionOn)
                    
                    
                    Toggle("Multiplication".localized, isOn: settings.$isMultiplicationOn)
                        .tint(.purple)
                        .disabled(settings.tabsEnabledCount == 1 && settings.isMultiplicationOn)
                    
                    
                    Toggle("Division".localized, isOn: settings.$isDivisionOn)
                        .tint(.purple)
                        .disabled(settings.tabsEnabledCount == 1 && settings.isDivisionOn)
                    
                }
                
                Section(header: Text("Appearance".localized)) {
                    Picker("Theme".localized, selection: Binding(
                        get: { settings.isDarkMode ? 1 : 0 },
                        set: { settings.isDarkMode = $0 == 1 }
                    )) {
                        Text("Light".localized).tag(0)
                        Text("Dark".localized).tag(1)
                    }
                    .pickerStyle(.segmented)
                }
                
                Section(header: Text("Language".localized)) {
                    NavigationLink(destination: EmptyView()) {
                            HStack {
                                Text("App Language".localized)
                                Spacer()
                                Text(settings.primaryLanguage.rawValue)
                            }
                            .contentShape(Rectangle()) // makes entire row tappable
                            .onTapGesture {
                                settings.openAppLanguageSettings()
                            }
                        }
                    
                    
                }
                
                Section(header: Text("Let Us Know What You Think".localized)) {
                    Button("Share Feedback".localized) {
                        showMailComposer = true
                    }
                }
                
                Section(header: Text("Default Settings".localized)) {
                    Button("Reset Settings".localized) {
                        settings.resetSettings()
                    }
                }
                
//                Section(header: Text("Application Cache".localized)) {
//                    Button("Reset & Exit".localized) {
//                        showCacheAlert = true
//                    }
//                    .foregroundColor(.red)
//                }
            }
//        }
        .onChange(of: settings.isAdditionOn) {
            settings.updateEnabledTabsCount()
        }
        .onChange(of: settings.isSubtractionOn) {
            settings.updateEnabledTabsCount()
        }
        .onChange(of: settings.isMultiplicationOn) {
            settings.updateEnabledTabsCount()
        }
        .onChange(of: settings.isDivisionOn) {
            settings.updateEnabledTabsCount()
        }
        .alert("Are you sure you want to delete the application cache and close the app?".localized, isPresented: $showCacheAlert) {
            Button("Delete".localized, role: .destructive) {
                settings.clearUserDefaultsAndCloseApp()
            }
            Button("Cancel".localized, role: .cancel) { }
        } message: {
            Text("This action cannot be undone.".localized)
        }
        .sheet(isPresented: $showMailComposer) {
            if MFMailComposeViewController.canSendMail() {
                MailComposer(
                    isPresented: $showMailComposer,
                    screenshot: nil,
                    recipient: "noblamath@gmail.com",
                    subject: "Nobla Math Feedback"
                )
            } else {
                Text("Please configure Mail to send feedback.".localized)
            }
        }
        .background( GradientBackground().ignoresSafeArea().opacity(settings.isDarkMode ? 1.0 : 0.0))
        .scrollContentBackground(settings.isDarkMode ? .hidden : .visible)
//        .toolbar {
//            ToolbarItem(placement: .primaryAction) {
//                Button(action: shareApp) {
//                    Image(systemName: "square.and.arrow.up")
//                        .accessibilityLabel("Share".localized)
//                }
//                .tint(.purple)
//            }
//        }
    }
    
//    private func shareApp() {
//        let text = "Check out Polyglot Pro - a great language learning app!".localized
//        let url = URL(string: "TODO_Use_App_Store_link")!
//        
//        let activityViewController = UIActivityViewController(activityItems: [text, url], applicationActivities: nil)
//        
//        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//           let rootViewController = windowScene.windows.first?.rootViewController {
//            rootViewController.present(activityViewController, animated: true, completion: nil)
//        }
//    }
}
