//
//  SettingsManager.swift
//  Matematik
//
//  Created by Sebastian Strus on 2025-04-27.
//

import SwiftUI

enum UserDefaultsKeys: String {
    case isDarkMode
    case difficultyLevel
    case exampleCount
    case isAdditionOn
    case isSubtractionOn
    case isMultiplicationOn
    case isDivisionOn

}

enum DifficultyLevel: Int, CaseIterable {
    case easy = 0
    case medium = 1
    case hard = 2
    
    var localizedName: String {
        switch self {
        case .easy: return "Easy".localized
        case .medium: return "Medium".localized
        case .hard: return "Hard".localized
        }
    }
}

class SettingsManager: ObservableObject {
    static let shared = SettingsManager()
    
    @AppStorage(UserDefaultsKeys.isDarkMode.rawValue) var isDarkMode: Bool = false
    
    @AppStorage(UserDefaultsKeys.isAdditionOn.rawValue) var isAdditionOn: Bool = true
    @AppStorage(UserDefaultsKeys.isSubtractionOn.rawValue) var isSubtractionOn: Bool = true
    @AppStorage(UserDefaultsKeys.isMultiplicationOn.rawValue) var isMultiplicationOn: Bool = true
    @AppStorage(UserDefaultsKeys.isDivisionOn.rawValue) var isDivisionOn: Bool = true
    
    @AppStorage(UserDefaultsKeys.exampleCount.rawValue) var exampleCount: Int = 45
    @AppStorage(UserDefaultsKeys.difficultyLevel.rawValue) var difficultyLevel: Int = DifficultyLevel.medium.rawValue
    
    @Published var tabsEnabledCount: Int = 0
    

    
    
    private let userDefaults = UserDefaults.standard
    
    private init() {
        updateEnabledTabsCount()
    }
    
    func updateEnabledTabsCount() {
        tabsEnabledCount = [isAdditionOn, isSubtractionOn, isMultiplicationOn, isDivisionOn].filter { $0 }.count
    }
    
    func resetSettings() {
        exampleCount = 30
        isDarkMode = false
        isAdditionOn = true
        isSubtractionOn = true
        isMultiplicationOn = true
        isDivisionOn = true
        difficultyLevel = DifficultyLevel.medium.rawValue
    }
    
    func resetCompletedCategories() {
        userDefaults.removeObject(forKey: completedCategoriesKey())
        objectWillChange.send()
    }
    
    func completedCategoriesKey() -> String {
        return ""
    }
    
    func clearUserDefaultsAndCloseApp() {
        let defaults = UserDefaults.standard
        if let bundleID = Bundle.main.bundleIdentifier {
            defaults.removePersistentDomain(forName: bundleID)
            defaults.synchronize()
        }
        exit(0)
    }
}
