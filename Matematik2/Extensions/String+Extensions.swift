//
//  String+Extensions.swift
//  Matematik
//
//  Created by Sebastian Strus on 2025-04-27.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    func localized(with arguments: CVarArg...) -> String {
        String(format: localized, arguments: arguments)
    }
}
