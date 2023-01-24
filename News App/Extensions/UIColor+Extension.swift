//
//  UIColor+Extension.swift
//  News App
//
//  Created by Gabriel Varela on 16/07/21.
//

import UIKit

extension UIColor {
    
    open class var grayA2A2A2: UIColor {
        return UIColor(hex: "A2A2A2")
    }
    
    open class var gray414141: UIColor {
        return UIColor(hex: "414141")
    }
    
    open class var gray4D4D4D: UIColor {
        return UIColor(hex: "4D4D4D")
    }
    
    open class var green0ED39C: UIColor {
        return UIColor(hex: "0ED39C")
    }
    
    open class var blue1E234A: UIColor {
        return UIColor(hex: "1E234A")
    }
    
    open class var grayF4F4F4: UIColor {
        return UIColor(hex: "F4F4F4")
    }
    
    open class var black171717: UIColor {
        return UIColor(hex: "171717")
    }
    
    open class var gray171717: UIColor {
        return UIColor(hex: "171717")
    }
    
    open class var grayF2F2F2: UIColor {
        return UIColor(hex: "F2F2F2")
    }
}

extension UIColor {
    
    convenience init(hex: String) {
        let scanner = Scanner(string: hex.replacingOccurrences(of: "#", with: ""))
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        let red = (rgbValue & 0xff0000) >> 16
        let green = (rgbValue & 0xff00) >> 8
        let blue = rgbValue & 0xff
        self.init(
            red: CGFloat(red) / 0xff,
            green: CGFloat(green) / 0xff,
            blue: CGFloat(blue) / 0xff, alpha: 1
        )
    }
    
    static func dynamicColor(light: UIColor, dark: UIColor) -> UIColor {

             if #available(iOS 13.0, *) {
                 return UIColor(dynamicProvider: { mode in
                    switch mode.userInterfaceStyle {
                     case .dark:
                         return dark
                     case .light:
                         return light
                    default:
                         return light
                     }
                 })
             }
             return light
         }
}

