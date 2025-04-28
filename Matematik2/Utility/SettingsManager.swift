//
//  SettingsManager.swift
//  Matematik
//
//  Created by Sebastian Strus on 2025-04-27.
//

enum Language: String {
    case english
    case swedish
    case ukrainian
    case polish
    
    init?(localeIdentifier: String) {
        switch String(localeIdentifier.lowercased().prefix(2)) {
        case "sv": self = .swedish
        case "uk": self = .ukrainian
        case "en": self = .english
        case "pl": self = .polish
        default:
            return nil
        }
    }
    
    var displayName: String {
        switch self {
        case .swedish: return "Swedish".localized
        case .ukrainian: return "Ukrainian".localized
        case .english: return "English".localized
        case .polish: return "Polish".localized
        }
    }
}

import SwiftUI

enum UserDefaultsKeys: String {
    case isDarkMode
    case difficultyLevel
    case exampleCount
    case isAdditionOn
    case isSubtractionOn
    case isMultiplicationOn
    case isDivisionOn
    case primaryLanguage = "AppleLanguages"

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
    
    @Published var primaryLanguage: Language
    
    
    private let userDefaults = UserDefaults.standard
    
    private init() {
        if let appleLanguages = userDefaults.array(forKey: UserDefaultsKeys.primaryLanguage.rawValue),
           let code = appleLanguages.first as? String,
           let appLanguage = Language(localeIdentifier: appleLanguages.first! as! String) {
            primaryLanguage = appLanguage
        } else {
            primaryLanguage = .english
        }
        
        updateEnabledTabsCount()
        
    }
    
    func updateEnabledTabsCount() {
        tabsEnabledCount = [isAdditionOn, isSubtractionOn, isMultiplicationOn, isDivisionOn].filter { $0 }.count
    }
    
    func resetSettings() {
        exampleCount = 45
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
    
    func openAppLanguageSettings() {
        guard let bundleId = Bundle.main.bundleIdentifier,
              let settingsUrl = URL(string: UIApplication.openSettingsURLString + "&path=\(bundleId)/LANGUAGE") else {
            return
        }
        
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl)
        }

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
