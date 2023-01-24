//
//  UIFont+Extension.swift
//  News App
//
//  Created by Gabriel Varela on 16/07/21.
//

import UIKit

extension UIFont {
    
    open class func `default`(ofSize size: CGFloat, weight: UIFont.Weight) -> UIFont {
        switch weight {
        case .bold:
            return UIFont(name: "Gibson-Bold", size: size) ?? UIFont.systemFont(ofSize: size, weight: weight)
        case .semibold:
            return UIFont(name: "Gibson-Semibold", size: size) ?? UIFont.systemFont(ofSize: size, weight: weight)
        case .regular:
            return UIFont(name: "Gibson-Regular", size: size) ?? UIFont.systemFont(ofSize: size, weight: weight)
        case .light:
            return UIFont(name: "Gibson-Light", size: size) ?? UIFont.systemFont(ofSize: size, weight: weight)
        default:
            return UIFont.systemFont(ofSize: size, weight: weight)
        }
    }
    
    open class func italic(ofSize size: CGFloat, weight: UIFont.Weight) -> UIFont {
        switch weight {
        case .bold:
            return UIFont(name: "Gibson-BoldItalic", size: size) ?? UIFont.systemFont(ofSize: size, weight: weight)
        case .semibold:
            return UIFont(name: "Gibson-SemiboldIt", size: size) ?? UIFont.systemFont(ofSize: size, weight: weight)
        case .regular:
            return UIFont(name: "Gibson-Italic", size: size) ?? UIFont.systemFont(ofSize: size, weight: weight)
        case .light:
            return UIFont(name: "Gibson-LightIt", size: size) ?? UIFont.systemFont(ofSize: size, weight: weight)
        default:
            return UIFont.systemFont(ofSize: size, weight: weight)
        }
    }
}
