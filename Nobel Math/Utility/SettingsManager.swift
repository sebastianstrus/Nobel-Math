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
    case spanish
    case german
    case polish
    case french
    case portuguese
    case italian
    case japanese
    case simplifiedChinese
    case indonesian
    case danish
    case norwegian
    case arabic
    case hindi
    case punjabi
    case bengali
    case finnish
    case korean
    case urdu
    case icelandic

    
    init?(localeIdentifier: String) {
        switch String(localeIdentifier.lowercased().prefix(2)) {
        case "sv": self = .swedish
        case "uk": self = .ukrainian
        case "es": self = .spanish
        case "de": self = .german
        case "en": self = .english
        case "pl": self = .polish
        case "fr": self = .french
        case "pt": self = .portuguese
        case "it": self = .italian
        case "ja": self = .japanese
        case "zh": self = .simplifiedChinese
        case "id": self = .indonesian
        case "da": self = .danish
        case "no": self = .norwegian
        case "ar": self = .arabic
        case "hi": self = .hindi
        case "pa": self = .punjabi
        case "bn": self = .bengali
        case "fi": self = .finnish
        case "ko": self = .korean
        case "ur": self = .urdu
        case "is": self = .icelandic
        default:
            return nil
        }
    }
    
    var displayName: String {
        switch self {
        case .swedish: return "Swedish".localized
        case .ukrainian: return "Ukrainian".localized
        case .spanish: return "Spanish".localized
        case .german: return "German".localized
        case .english: return "English".localized
        case .polish: return "Polish".localized
        case .french: return "French".localized
        case .portuguese: return "Portuguese".localized
        case .italian: return "Italian".localized
        case .japanese: return "Japanese".localized
        case .simplifiedChinese: return "Simplified Chinese".localized
        case .indonesian: return "Indonesian".localized
        case .danish: return "Danish".localized
        case .norwegian: return "Norwegian".localized
        case .arabic: return "Arabic".localized
        case .hindi: return "Hindi".localized
        case .punjabi: return "Punjabi".localized
        case .bengali: return "Bengali".localized
        case .finnish: return "Finnish".localized
        case .korean: return "Korean".localized
        case .urdu: return "Urdu".localized
        case .icelandic: return "Icelandic".localized
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
    case isTimerOn
    case isSparkleStarsOn

}

struct GameResult: Codable, Identifiable {
    var id: UUID = UUID()  // Add this for Identifiable conformance
    let name: String
    let difficulty: DifficultyLevel
    let exampleCount: Int
    let time: TimeInterval
    let date: Date
    
    // Add CodingKeys if you want to customize the JSON keys
    enum CodingKeys: String, CodingKey {
        case id, name, difficulty, exampleCount, time, date
    }
}

enum DifficultyLevel: Int, CaseIterable, Codable {
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
    
    @AppStorage(UserDefaultsKeys.isTimerOn.rawValue) var isTimerOn: Bool = true
    @AppStorage(UserDefaultsKeys.isSparkleStarsOn.rawValue) var isSparkleStarsOn: Bool = true
    
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
    
    // Add this at the top of SettingsManager.swift
    

    // Add these methods to SettingsManager class
    private let statisticsKey = "gameStatistics"

    func saveGameResult(name: String, difficulty: DifficultyLevel, exampleCount: Int, time: TimeInterval) {
        var results = loadGameResults()
        let newResult = GameResult(
            name: name,
            difficulty: difficulty,
            exampleCount: exampleCount,
            time: time,
            date: Date()
        )
        results.append(newResult)
        
        do {
            let encoded = try JSONEncoder().encode(results)
            userDefaults.set(encoded, forKey: statisticsKey)
        } catch {
            print("Failed to encode game results: \(error)")
        }
    }

    func loadGameResults() -> [GameResult] {
        guard let data = userDefaults.data(forKey: statisticsKey) else {
            return []
        }
        
        do {
            return try JSONDecoder().decode([GameResult].self, from: data)
        } catch {
            print("Failed to decode game results: \(error)")
            return []
        }
    }

    func clearStatistics() {
        userDefaults.removeObject(forKey: statisticsKey)
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
        isTimerOn = true
        isDivisionOn = true
        isSparkleStarsOn = true
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
