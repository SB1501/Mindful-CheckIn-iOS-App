import SwiftUI

extension Color {
    /// Initialize a Color from a hex code string like "#D8CDEA"
    fileprivate init?(hex: String) {
        var hexString = hex
        if hexString.hasPrefix("#") {
            hexString.removeFirst()
        }
        guard hexString.count == 6 || hexString.count == 8 else {
            return nil
        }

        var hexNumber: UInt64 = 0
        guard Scanner(string: hexString).scanHexInt64(&hexNumber) else {
            return nil
        }

        let r, g, b, a: Double
        if hexString.count == 8 {
            r = Double((hexNumber & 0xFF000000) >> 24) / 255
            g = Double((hexNumber & 0x00FF0000) >> 16) / 255
            b = Double((hexNumber & 0x0000FF00) >> 8) / 255
            a = Double(hexNumber & 0x000000FF) / 255
        } else {
            r = Double((hexNumber & 0xFF0000) >> 16) / 255
            g = Double((hexNumber & 0x00FF00) >> 8) / 255
            b = Double(hexNumber & 0x0000FF) / 255
            a = 1.0
        }

        self.init(red: r, green: g, blue: b, opacity: a)
    }
}

extension QuestionTopic {
    /// The main color associated with this topic
    public var color: Color {
        switch self {
        case .sleep:           return Color(hex: "#D8CDEA")!
        case .hydration:       return Color(hex: "#B3E5FC")!
        case .food:            return Color(hex: "#FAD4B0")!
        case .caffeine:        return Color(hex: "#DCC5B2")!
        case .sugar:           return Color(hex: "#F8F6F0")!
        case .rest:            return Color(hex: "#F6D1C1")!
        case .hygiene:         return Color(hex: "#D6EAF8")!
        case .strain:          return Color(hex: "#F2B5A0")!
        case .eyes:            return Color(hex: "#D0F0E0")! // Eye strain
        case .clothing:        return Color(hex: "#D8CFC4")!
        case .temperature:     return Color(hex: "#FFE4C4")!
        case .lighting:        return Color(hex: "#FFF5D7")!
        case .sound:           return Color(hex: "#EAEAEA")!
        case .socialising:     return Color(hex: "#FFD6C0")!
        case .outdoors:        return Color(hex: "#C8E6C9")!
        case .space:           return Color(hex: "#DADADA")!
        case .screenTime:      return Color(hex: "#D0E6F7")!
        case .tension:         return Color(hex: "#D7B9C5")!
        case .breathing:       return Color(hex: "#CDEDEB")!
        case .mentalBusy:      return Color(hex: "#E3D7F1")! // Mental load
        case .taskLoad:        return Color(hex: "#E8DCC3")!
        case .mentalBreak:    return Color(hex: "#E6DAF0")!
        case .focus:           return Color(hex: "#B2DFDB")!
        case .avoidance:       return Color(hex: "#E0D6EB")!
        case .motivation:      return Color(hex: "#FFE0B2")!
        case .selfCheckIn:     return Color(hex: "#E5D4ED")! // Self mindfulness
        case .selfKindness:    return Color(hex: "#FADADD")!
        case .authenticity:    return Color(hex: "#D4E4D1")!
        }
    }

    /// A soft background color with reduced opacity
    public var backgroundColor: Color {
        color.opacity(0.35)
    }

    /// The tint color for buttons
    public var buttonTint: Color {
        color
    }
}

#if canImport(UIKit)
import UIKit

extension Color {
    /// Convert Color to UIColor
    public var uiColor: UIColor {
        UIColor(self)
    }
}
#endif

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit

extension Color {
    /// Convert Color to NSColor
    public var nsColor: NSColor {
        NSColor(self)
    }
}
#endif

