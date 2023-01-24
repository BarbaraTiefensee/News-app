//
//  String+Extension.swift
//  News App
//
//  Created by Premier on 19/07/21.
//

import Foundation
import UIKit

extension String {
    
    var isEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,20}"
        let emailTest  = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    var isValidPassword: Bool {
        if self.count >= 6 {
            return true
        }
        return false
    }
}

extension NSMutableAttributedString {
    var fontSize:CGFloat { return 13 }
    var boldFont:UIFont { return UIFont.default(ofSize: fontSize, weight: .bold) }
    var regularFont:UIFont { return UIFont.default(ofSize: fontSize, weight: .regular) }
    
    func bold(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font : boldFont,
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    func normal(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font : regularFont
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
}

