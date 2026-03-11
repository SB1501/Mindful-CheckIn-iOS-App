// SB MINDFUL CHECK-IN - This is an extension adding custom functionality handling how colours are used within the app

import SwiftUI

//Optional Imports included to avoid breaking compilation on macOS / tvOS for future builds
#if canImport(UIKit)
import UIKit
#endif

#if canImport(AppKit)
import AppKit
#endif

extension Color { //this

    fileprivate init?(hex: String) { //initialises a colour from a HEX Code (quicker to lookup and tweak versus usual Swift RGB three number values, is failable as init? question mark gives it a nil response if the input given to it is invalid. The fileprivate limits its visibility to this file.
        var hexString = hex //this part makes a mutable (can be changed), so if the passed value into this extension has a hash, removes it
        if hexString.hasPrefix("#") {
            hexString.removeFirst()
        }
        guard hexString.count == 6 || hexString.count == 8 else { //ensures the hex passed is either 6 characters (RGB) or 8 (RGBA) otherwise initialisation fails and returns nil
            return nil
        }

        var hexNumber: UInt64 = 0
        guard Scanner(string: hexString).scanHexInt64(&hexNumber) else { //uses a Scanner to parse the hex string into a 64-bit integer, fails and return nil if invalid input
                return nil
            }

        let r, g, b, a: Double //constant value holding an RGB value in doubles. Uses bit masking below to extract each channel / part of the colour
        if hexString.count == 8 { //handling for 8 digits RGBA. All channels are in one integer, so this shift extracts each channel. Isolates each channel below into its 8 bits down to the least significant byte. Then divides by 255 to normalises from 0...255 to 0...1 for SwiftUIs 'Color', repeated for each channel:
            r = Double((hexNumber & 0xFF000000) >> 24) / 255
            g = Double((hexNumber & 0x00FF0000) >> 16) / 255
            b = Double((hexNumber & 0x0000FF00) >> 8) / 255
            a = Double(hexNumber & 0x000000FF) / 255 //alpha is last in the 8 digit
        } else { //handling for 6 digits RGB
            r = Double((hexNumber & 0xFF0000) >> 16) / 255
            g = Double((hexNumber & 0x00FF00) >> 8) / 255
            b = Double(hexNumber & 0x0000FF) / 255
            a = 1.0 //assuming alpha is 1.0 (fully opaque)
        }

        self.init(red: r, green: g, blue: b, opacity: a) //a 'Color' object is initialised using the channels computed above
    }
}

// FURTHER EXTENSION - handling darker variants of any 'Color'.
extension Color { //returns a darker colour by reducing brightness by a given amount 0...1, by default, 0.2

    func darkened(by amount: CGFloat = 0.2) -> Color {
        #if canImport(UIKit)
        let ui = UIColor(self) //passed Color is stored in ui to be processed below...
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0 //declares and initialises values to zero inside a CGFloat
        
        if ui.getHue(&h, saturation: &s, brightness: &b, alpha: &a) { //attempts to get these HSBA components...
            return Color(hue: Double(h), saturation: Double(s), brightness: Double(max(b - amount, 0)), opacity: Double(a)) //converts them into doubles if successful and subtracts amount from brightness (clamped to 0) and rebuilds a new Color
        } else { //but if HSBA is not available such as for grayscale colours it tries grayscale white+alpha
            var white: CGFloat = 0
            if ui.getWhite(&white, alpha: &a) {
                return Color(white: Double(max(white - amount, 0)), opacity: Double(a))
            }
            return self //if both of the above fail, it returns the original colour
        }
        #elseif canImport(AppKit) && !targetEnvironment(macCatalyst)
        let ns = NSColor(self)
        let converted = ns.usingColorSpace(.deviceRGB) ?? ns
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        converted.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return Color(hue: Double(h), saturation: Double(s), brightness: Double(max(b - amount, 0)), opacity: Double(a))
        #else
        return self
        #endif
    }
}

// EXTENSION - App Accent Colour

extension Color {
    static let appAccent: Color = Color(hex: "#00BFA0")! //dark teal. A static, app wide accent colour. Force unwrap (!) exclamation mark is used as the hex string is a known good literal, if malformed would cause the app to crash at launch. Acceptable here for a constant.
}

// EXTENSION - Question Topic Colours

extension QuestionTopic {

    public var color: Color { //public as this is part of the modules public API used within the app elsewhere. Each colour is pastel like for gentleness.
        
        switch self {
        case .sleep:           return Color(hex: "#D8CDEA")! //force unwraps, safe since literals are validated during development
        case .hydration:       return Color(hex: "#B3E5FC")!
        case .food:            return Color(hex: "#FAD4B0")!
        case .caffeine:        return Color(hex: "#DCC5B2")!
        case .sugar:           return Color(hex: "#F8F6F0")!
        case .rest:            return Color(hex: "#F6D1C1")!
        case .hygiene:         return Color(hex: "#D6EAF8")!
        case .strain:          return Color(hex: "#F2B5A0")!
        case .eyes:            return Color(hex: "#D0F0E0")!
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
        case .mentalBusy:      return Color(hex: "#E3D7F1")!
        case .taskLoad:        return Color(hex: "#E8DCC3")!
        case .mentalBreak:     return Color(hex: "#E6DAF0")!
        case .focus:           return Color(hex: "#B2DFDB")!
        case .avoidance:       return Color(hex: "#E0D6EB")!
        case .motivation:      return Color(hex: "#FFE0B2")!
        case .selfCheckIn:     return Color(hex: "#E5D4ED")!
        case .selfKindness:    return Color(hex: "#FADADD")!
        case .authenticity:    return Color(hex: "#D4E4D1")!
        }
    }

    
    public var backgroundColor: Color { //soft background colour
        color.opacity(0.5) //default value was 0.35, higher to make colours stronger
    }

    public var darkerTint: Color {
        color.darkened(by: 0.25) //25% less brightness when called
    }
}
