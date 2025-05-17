//
//  TimeInterval+Extensions.swift
//  Nobla Math
//
//  Created by Sebastian Strus on 2025-05-07.
//
import SwiftUI

extension TimeInterval {
    var formattedTimeWithMilliseconds: String {
        let totalSeconds = Int(self)
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60
        let milliseconds = Int((self.truncatingRemainder(dividingBy: 1)) * 100)
        
        if hours > 0 {
            return String(format: "%02d:%02d:%02d.%02d", hours, minutes, seconds, milliseconds)
        } else {
            return String(format: "%02d:%02d.%02d", minutes, seconds, milliseconds)
        }
    }
}

extension TimeInterval {
    var formattedTime: String {
        let totalSeconds = Int(self)
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60

        if hours > 0 {
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }
}
