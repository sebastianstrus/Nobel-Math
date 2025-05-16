//
//  TimeInterval+Extensions.swift
//  Nobla Math
//
//  Created by Sebastian Strus on 2025-05-07.
//
import SwiftUI

extension TimeInterval {
    var formatedTime: String {
        let minutes = Int(self) / 60
        let seconds = Int(self) % 60
        let milliseconds = Int((self.truncatingRemainder(dividingBy: 1)) * 100)
        
        return String(format: "%02d:%02d.%02d", minutes, seconds, milliseconds)
        
    }
}
