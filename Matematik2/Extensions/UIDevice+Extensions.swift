//
//  UIDevice+Extensions.swift
//  Matematik
//
//  Created by Sebastian Strus on 2025-04-27.
//

import UIKit

extension UIDevice {
    static let deviceDidShakeNotification = Notification.Name(rawValue: "deviceDidShakeNotification")
}


extension UIDevice {
    var modelIdentifier: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }
    
    var modelName: String {
        let identifier = modelIdentifier
        return deviceMapping[identifier] ?? identifier
    }
    
    private var deviceMapping: [String: String] {
        return [
            // MARK: - iPhone
            "iPhone1,1": "iPhone",
            "iPhone1,2": "iPhone 3G",
            "iPhone2,1": "iPhone 3GS",
            "iPhone3,1": "iPhone 4 (GSM)",
            "iPhone3,2": "iPhone 4 (GSM Rev A)",
            "iPhone3,3": "iPhone 4 (CDMA)",
            "iPhone4,1": "iPhone 4S",
            "iPhone5,1": "iPhone 5 (GSM)",
            "iPhone5,2": "iPhone 5 (Global)",
            "iPhone5,3": "iPhone 5c (GSM)",
            "iPhone5,4": "iPhone 5c (Global)",
            "iPhone6,1": "iPhone 5s (GSM)",
            "iPhone6,2": "iPhone 5s (Global)",
            "iPhone7,1": "iPhone 6 Plus",
            "iPhone7,2": "iPhone 6",
            "iPhone8,1": "iPhone 6s",
            "iPhone8,2": "iPhone 6s Plus",
            "iPhone8,4": "iPhone SE (1st Gen)",
            "iPhone9,1": "iPhone 7 (GSM)",
            "iPhone9,3": "iPhone 7 (Global)",
            "iPhone9,2": "iPhone 7 Plus (GSM)",
            "iPhone9,4": "iPhone 7 Plus (Global)",
            "iPhone10,1": "iPhone 8 (GSM)",
            "iPhone10,4": "iPhone 8 (Global)",
            "iPhone10,2": "iPhone 8 Plus (GSM)",
            "iPhone10,5": "iPhone 8 Plus (Global)",
            "iPhone10,3": "iPhone X (GSM)",
            "iPhone10,6": "iPhone X (Global)",
            "iPhone11,2": "iPhone XS",
            "iPhone11,4": "iPhone XS Max (China)",
            "iPhone11,6": "iPhone XS Max (Global)",
            "iPhone11,8": "iPhone XR",
            "iPhone12,1": "iPhone 11",
            "iPhone12,3": "iPhone 11 Pro",
            "iPhone12,5": "iPhone 11 Pro Max",
            "iPhone12,8": "iPhone SE (2nd Gen)",
            "iPhone13,1": "iPhone 12 mini",
            "iPhone13,2": "iPhone 12",
            "iPhone13,3": "iPhone 12 Pro",
            "iPhone13,4": "iPhone 12 Pro Max",
            "iPhone14,2": "iPhone 13 Pro",
            "iPhone14,3": "iPhone 13 Pro Max",
            "iPhone14,4": "iPhone 13 mini",
            "iPhone14,5": "iPhone 13",
            "iPhone14,6": "iPhone SE (3rd Gen)",
            "iPhone14,7": "iPhone 14",
            "iPhone14,8": "iPhone 14 Plus",
            "iPhone15,2": "iPhone 14 Pro",
            "iPhone15,3": "iPhone 14 Pro Max",
            "iPhone15,4": "iPhone 15",
            "iPhone15,5": "iPhone 15 Plus",
            "iPhone16,1": "iPhone 15 Pro",
            "iPhone16,2": "iPhone 15 Pro Max",
            "iPhone17,1": "iPhone 16 (Expected)",
            "iPhone17,2": "iPhone 16 Plus (Expected)",
            "iPhone17,3": "iPhone 16 Pro (Expected)",
            "iPhone17,4": "iPhone 16 Pro Max (Expected)",

            // MARK: - iPad
            "iPad1,1": "iPad (1st Gen)",
            "iPad2,1": "iPad 2 (Wi-Fi)",
            "iPad2,2": "iPad 2 (GSM)",
            "iPad2,3": "iPad 2 (CDMA)",
            "iPad2,4": "iPad 2 (Wi-Fi Rev A)",
            "iPad3,1": "iPad (3rd Gen, Wi-Fi)",
            "iPad3,2": "iPad (3rd Gen, CDMA)",
            "iPad3,3": "iPad (3rd Gen, GSM)",
            "iPad3,4": "iPad (4th Gen, Wi-Fi)",
            "iPad3,5": "iPad (4th Gen, GSM)",
            "iPad3,6": "iPad (4th Gen, Global)",
            "iPad4,1": "iPad Air (Wi-Fi)",
            "iPad4,2": "iPad Air (Cellular)",
            "iPad4,3": "iPad Air (China)",
            "iPad5,3": "iPad Air 2 (Wi-Fi)",
            "iPad5,4": "iPad Air 2 (Cellular)",
            "iPad6,7": "iPad Pro 12.9\" (1st Gen)",
            "iPad6,8": "iPad Pro 12.9\" (1st Gen, Cellular)",
            "iPad6,3": "iPad Pro 9.7\" (Wi-Fi)",
            "iPad6,4": "iPad Pro 9.7\" (Cellular)",
            "iPad7,1": "iPad Pro 12.9\" (2nd Gen)",
            "iPad7,2": "iPad Pro 12.9\" (2nd Gen, Cellular)",
            "iPad7,3": "iPad Pro 10.5\" (Wi-Fi)",
            "iPad7,4": "iPad Pro 10.5\" (Cellular)",
            "iPad8,1": "iPad Pro 11\" (1st Gen, Wi-Fi)",
            "iPad8,2": "iPad Pro 11\" (1st Gen, 1TB, Wi-Fi)",
            "iPad8,3": "iPad Pro 11\" (1st Gen, Cellular)",
            "iPad8,4": "iPad Pro 11\" (1st Gen, 1TB, Cellular)",
            "iPad8,5": "iPad Pro 12.9\" (3rd Gen, Wi-Fi)",
            "iPad8,6": "iPad Pro 12.9\" (3rd Gen, 1TB, Wi-Fi)",
            "iPad8,7": "iPad Pro 12.9\" (3rd Gen, Cellular)",
            "iPad8,8": "iPad Pro 12.9\" (3rd Gen, 1TB, Cellular)",
            "iPad11,1": "iPad mini (5th Gen, Wi-Fi)",
            "iPad11,2": "iPad mini (5th Gen, Cellular)",
            "iPad11,3": "iPad Air (3rd Gen, Wi-Fi)",
            "iPad11,4": "iPad Air (3rd Gen, Cellular)",
            "iPad13,1": "iPad Air (4th Gen, Wi-Fi)",
            "iPad13,2": "iPad Air (4th Gen, Cellular)",
            "iPad13,4": "iPad Pro 11\" (2nd Gen)",
            "iPad13,5": "iPad Pro 11\" (2nd Gen, 1TB)",
            "iPad13,6": "iPad Pro 11\" (2nd Gen, Cellular)",
            "iPad13,7": "iPad Pro 11\" (2nd Gen, 1TB, Cellular)",
            "iPad13,8": "iPad Pro 12.9\" (4th Gen)",
            "iPad13,9": "iPad Pro 12.9\" (4th Gen, 1TB)",
            "iPad13,10": "iPad Pro 12.9\" (4th Gen, Cellular)",
            "iPad13,11": "iPad Pro 12.9\" (4th Gen, 1TB, Cellular)",
            "iPad14,1": "iPad mini (6th Gen, Wi-Fi)",
            "iPad14,2": "iPad mini (6th Gen, Cellular)",
            "iPad14,3": "iPad Pro 11\" (3rd Gen)",
            "iPad14,4": "iPad Pro 11\" (3rd Gen, 1TB)",
            "iPad14,5": "iPad Pro 12.9\" (5th Gen)",
            "iPad14,6": "iPad Pro 12.9\" (5th Gen, 1TB)",

            // MARK: - iPod
            "iPod1,1": "iPod touch (1st Gen)",
            "iPod2,1": "iPod touch (2nd Gen)",
            "iPod3,1": "iPod touch (3rd Gen)",
            "iPod4,1": "iPod touch (4th Gen)",
            "iPod5,1": "iPod touch (5th Gen)",
            "iPod7,1": "iPod touch (6th Gen)",
            "iPod9,1": "iPod touch (7th Gen)",

            // MARK: - Simulator
            "i386": "Simulator (32-bit)",
            "x86_64": "Simulator (64-bit)",
            "arm64": "Simulator (Apple Silicon)"
        ]
    }
}


extension UIDevice {
    // ... (keep your existing modelName and modelIdentifier code)

    /// Returns screen size in points (e.g., "390×844 pt")
    var screenSizePoints: String {
        let bounds = UIScreen.main.bounds
        return "\(Int(bounds.width))×\(Int(bounds.height)) pt"
    }

    /// Returns screen size in pixels (e.g., "1170×2532 px")
    var screenSizePixels: String {
        let bounds = UIScreen.main.nativeBounds
        return "\(Int(bounds.width))×\(Int(bounds.height)) px"
    }

    /// Returns screen scale (e.g., "3.0x" for Retina displays)
    var screenScale: String {
        return String(format: "%.1fx", UIScreen.main.scale)
    }
}

extension UIDevice {
    /// Returns current orientation as a readable string
    var orientationName: String {
        if UIDevice.current.orientation.isValidInterfaceOrientation {
            switch UIDevice.current.orientation {
            case .portrait:
                return "Portrait"
            case .portraitUpsideDown:
                return "Portrait Upside Down"
            case .landscapeLeft:
                return "Landscape Left"
            case .landscapeRight:
                return "Landscape Right"
            case .faceUp:
                return "Face Up"
            case .faceDown:
                return "Face Down"
            default:
                return "Unknown Orientation"
            }
        } else {
            return "Flat (Not determined)"
        }
    }
}
