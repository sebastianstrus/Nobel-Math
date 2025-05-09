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
    @Environment(\.colorScheme) var colorScheme
    
    @State private var showProgressAlert = false
    @State private var showCacheAlert = false
    @State private var showMailComposer = false
    @State private var showingLanguageHelp = false
    
    
    var body: some View {
        VStack {
            Text("").frame(height: 0)
            List {
                
                Section(header: Text("Statistics".localized)) {
                    NavigationLink(destination: StatisticsView()) {
                        Text("View Statistics".localized)
                    }
                }
                
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
                    }.padding(.trailing, 8)
                    
                    
                    Toggle("Display Timer".localized, isOn: settings.$isTimerOn)
                        .tint(.purple)
                }
                
                Section(header: Text("Learning Sections".localized)) {
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
                            Text(settings.primaryLanguage.displayName)
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
        }
        .navigationTitle("Settings".localized)
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
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: shareApp) {
                    Image(systemName: "square.and.arrow.up")
                        .accessibilityLabel("Share".localized)
                }
                .tint(.purple)
            }
        }
    }
    
    private func shareApp() {
        let text = "Check out Nobla Math - a great math learning app!".localized
        let url = URL(string: "https://apps.apple.com/app/6745169341")!
        
        let activityViewController = UIActivityViewController(activityItems: [text, url], applicationActivities: nil)
        
        // Safely get windowScene and rootViewController
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first,
              let rootViewController = window.rootViewController else {
            return
        }

        // Configure for iPad
        if UIDevice.current.userInterfaceIdiom == .pad {
            activityViewController.popoverPresentationController?.sourceView = rootViewController.view
            activityViewController.popoverPresentationController?.sourceRect = CGRect(x: window.bounds.width / 2, y: window.bounds.height / 2, width: 0, height: 0)
            activityViewController.popoverPresentationController?.permittedArrowDirections = []
        }
        
        rootViewController.present(activityViewController, animated: true, completion: nil)
    }

}




//
//  StatisticsView.swift
//  Matematik
//
//  Created by Sebastian Strus on 2025-04-27.
//

//
//  StatisticsView.swift
//  Matematik
//
//  Created by Sebastian Strus on 2025-04-27.
//

import SwiftUI

struct StatisticsView: View {
    @EnvironmentObject var settings: SettingsManager
    @State private var showingClearConfirmation = false
    
    var body: some View {
        VStack {
            Text("").frame(height: 0)
            List {
                Section(header: sectionHeader("Easy".localized)) {
                    columnHeaders()
                    resultsSection(for: .easy)
                }
                
                Section(header: sectionHeader("Medium".localized)) {
                    columnHeaders()
                    resultsSection(for: .medium)
                }
                
                Section(header: sectionHeader("Hard".localized)) {
                    columnHeaders()
                    resultsSection(for: .hard)
                }
                

            }
            .navigationTitle("Statistics".localized)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingClearConfirmation = true }) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                }
            }
            .alert("Clear All Statistics?".localized, isPresented: $showingClearConfirmation) {
                Button("Clear".localized, role: .destructive) {
                    settings.clearStatistics()
                }
                Button("Cancel".localized, role: .cancel) {}
            } message: {
                Text("This will permanently delete all saved results.".localized)
            }
        }
    }
    
    private func columnHeaders() -> some View {
        HStack(spacing: 8) {
            // Name header
            Text("Nickname".localized)
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                .font(Font.system(size: 13).bold())
                .foregroundColor(.primary)
            
            // Count header
            Text("Count".localized)
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                .font(Font.system(size: 13).bold())
                .foregroundColor(.primary)
            
            // Result header
            Text("Result".localized)
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                .font(Font.system(size: 13).bold())
                .foregroundColor(.primary)
            
            // Date header
            Text("Date".localized)
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                .font(Font.system(size: 13).bold())
                .foregroundColor(.primary)
        }
        .alignmentGuide(.listRowSeparatorLeading) { _ in 0 }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
    }
    
    private func sectionHeader(_ text: String) -> some View {
        Text(text)
            .font(.headline)
            .foregroundColor(.primary)
            .padding(.vertical, 8)
            .alignmentGuide(.listRowSeparatorLeading) { _ in 0 }
    }
    
    private func resultsSection(for difficulty: DifficultyLevel) -> some View {
        let results = settings.loadGameResults()
            .filter { $0.difficulty == difficulty }
            .sorted {
                // Primary sort by example count (descending)
                if $0.exampleCount != $1.exampleCount {
                    return $0.exampleCount > $1.exampleCount
                }
                // Secondary sort by time (ascending - fastest first)
                return $0.time < $1.time
            }
        
        return Group {
            if results.isEmpty {
                Text("No results yet".localized)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .alignmentGuide(.listRowSeparatorLeading) { _ in 0 }
                    .padding(.vertical, 8)
            } else {
                ForEach(results) { result in
                    HStack(spacing: 8) {
                        // Name column
                        Text(result.name)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .font(.subheadline)
                        
                        // Example count column
                        Text("\(result.exampleCount)")
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                            .font(.system(size: 13, design: .monospaced))
                        
                        // Time column
                        Text(formatTime(result.time))
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                            .font(.system(size: 15, design: .monospaced))
                        
                        // Date column
                        Text(formatDate(result.date))
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .alignmentGuide(.listRowSeparatorLeading) { _ in 0 }
                    .padding(.vertical, 4)
                }
            }
        }
    }
    
    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        let milliseconds = Int((time.truncatingRemainder(dividingBy: 1)) * 100)
        return String(format: "%02d:%02d.%02d", minutes, seconds, milliseconds)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}
