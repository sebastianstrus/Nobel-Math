//
//  EntitlementManager.swift
//  Nobel Math
//
//  Created by Sebastian Strus on 6/8/25.
//

import SwiftUI

class EntitlementManager: ObservableObject {
    static let userDefaults = UserDefaults(suiteName: "group.your.app")!

    @AppStorage("hasPro", store: userDefaults)
    var hasPro: Bool = false
}
